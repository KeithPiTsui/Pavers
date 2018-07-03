//
//  MakeTokenParser.swift
//  ParsecMock
//
//  Created by Keith on 2018/7/3.
//  Copyright © 2018 Keith. All rights reserved.
//
import PaversFRP
//makeTokenParser :: (Stream s m Char)
//=> GenLanguageDef s u m -> GenTokenParser s u m
//makeTokenParser languageDef
public func makeTokenParser<S, U>(_ languageDef: GenLanguageDef<S, U>)
  -> GenTokenParser<S, U>
  where S: ParserStream, S.Element == Character {
    
    func parens<A>(_ p: Parser<S, U, A>) -> Parser<S, U, A> {
      return between(symbol("("), symbol(")"), p)
    }
    
    func braces<A>(_ p: Parser<S, U, A>) -> Parser<S, U, A> {
      return between(symbol("{"), symbol("}"), p)
    }
    
    func angles<A>(_ p: Parser<S, U, A>) -> Parser<S, U, A> {
      return between(symbol("<"), symbol(">"), p)
    }
    
    func brackets<A>(_ p: Parser<S, U, A>) -> Parser<S, U, A> {
      return between(symbol("["), symbol("]"), p)
    }
    
    func semi() -> Parser<S, U, String> {
      return symbol(";")
    }
    
    func comma() -> Parser<S, U, String> {
      return symbol(",")
    }
    
    func dot() -> Parser<S, U, String> {
      return symbol(".")
    }
    
    func colon() -> Parser<S, U, String> {
      return symbol(":")
    }
    
    func commaSep<A>(_ p: Parser<S, U, A>) -> Parser<S, U, [A]> {
      return sepBy(p, comma())
    }
    
    func semiSep<A>(_ p: Parser<S, U, A>) -> Parser<S, U, [A]> {
      return sepBy(p, semi())
    }
    
    func commaSep1<A>(_ p: Parser<S, U, A>) -> Parser<S, U, [A]> {
      return sepBy1(p, comma())
    }
    
    func semiSep1<A>(_ p: Parser<S, U, A>) -> Parser<S, U, [A]> {
      return sepBy1(p, semi())
    }
    
    func charLiteral() -> Parser<S, U, Character> {
      let a = between(char("'"), char("'") <?> "end of character", characterChar())
      return lexeme(a) <?> "character"
    }
    
    func characterChar() -> Parser<S, U, Character> {
      return (charLetter() <|> charEscape()) <?> "Literal character"
    }
    
    func charEscape() -> Parser<S, U, Character> {
      return char("\\") >>- {_ in escapeCode()}
    }
    
    func charLetter() -> Parser<S, U, Character> {
      return satisfy{ (c: Character) -> Bool in
        let m = c != "\'" && c != "\\"
        let n = c.unicodeScalars.count == 1
        let o = c.unicodeScalars.last! > UnicodeScalar(26)
        return m && n && o
      }
    }
    
    func stringLiteral() -> Parser<S, U, [Character]> {
      let a: Parser<S, U, [Character?]> =
        between(char("\""), char("\"") <?> "end of string", many(stringChar()))
      let b: Parser<S, U, [Character]> = a >>- {(str: [Character?]) -> Parser<S, U, [Character]> in
        let c = str.reduce([]){ (acc: [Character], maybeC: Character?) -> [Character] in
          guard let myC = maybeC else {return acc}
          return acc + [myC]
        }
        return pure(c)
      }
      return lexeme(b <?> "literal string")
    }
    
    func stringChar() -> Parser<S, U, Character?> {
      return ((stringLetter() >>- {c in pure(c)}) <|> stringEscape()) <?> "String character"
    }
    
    func stringLetter() -> Parser<S, U, Character> {
      return satisfy{ (c: Character) -> Bool in
        let m = c != "\"" && c != "\\"
        let n = c.unicodeScalars.count == 1
        let o = c.unicodeScalars.last! > UnicodeScalar(26)
        return m && n && o
      }
    }
    
    func stringEscape() -> Parser<S, U, Character?> {
      let a: Parser<S, U, Character?> = escapeGap() >>- {_ in pure(nil)}
      let b: Parser<S, U, Character?> = escapeEmpty() >>- {_ in pure(nil)}
      let c: Parser<S, U, Character?> = escapeCode() >>- {esc in pure(esc)}
      return char("\\") >>- (a <|> b <|> c)
    }
    
    func escapeEmpty() -> Parser<S, U, Character> {
      return char("&")
    }
    
    func escapeGap() -> Parser<S, U, Character> {
      return (many1(space()) >>- char("\\")) <?> "end of string gap"
    }
    
    func escapeCode() -> Parser<S, U, Character> {
      return charEsc() <|> charNum() <|> charAscii() <|> charControl() <?> "escape code"
    }
    
    func charControl() -> Parser<S, U, Character> {
      return char("^") >>- {_ in upper() >>- { (code) -> Parser<S, U, Character> in
        let a: Character = "A"
        let c = Character.toEnum(code.fromEnum - a.fromEnum + 1)
        return pure(c)
        }}
    }
    
    
    func charNum() -> Parser<S, U, Character> {
      let a = char("o") >>- number(8, octDigit())
      let b = char("x") >>- number(16, octDigit())
      return (decimal() <|> a <|> b) >>- { code in
        if code > 0x10FFFF {
          return parserFail("invalid escape sequence")
        } else {
          return pure(Character.toEnum(code))
        }
      }
    }
    
    func charEsc() -> Parser<S, U, Character> {
      func parseEsc<B>(_ c: Character, _ code: B) -> Parser<S, U, B> {
        return char(c) >>- {_ in pure(code)}
      }
      return choice(escMap().map(parseEsc))
    }
    
    func charAscii() -> Parser<S, U, Character> {
      func parseAscii<B>(_ asc: String, _ code: B) -> Parser<S, U, B> {
        let b: Parser<S, U, String> = string(asc)
        let a: Parser<S, U, B> = b >>- (pure(code) as Parser<S, U, B>)
        return try_( a )
      }
      let xs: [Parser<S, U, Character>] = asciiMap()
        .map { (arg) -> (String, Character) in
        let (cs, c) = arg
        return (String.init(cs), c)}
        .map(parseAscii)
      return choice(xs)
    }
    
    func escMap() -> [(Character, Character)] {
      let a = "nrt\\\"\'"
      let b = "\n\r\t\\\"\'"
      return zip(a, b).filter(trueness)
    }
    
    func asciiMap() -> [([Character], Character)] {
      let a  = ascii3codes() + ascii2codes()
      let b = ascii3() + ascii2()
      return zip(a, b).filter(trueness)
    }
    
    func ascii2codes() -> [[Character]] {
      return ["BS","HT","LF","VT","FF","CR","SO","SI","EM",
              "FS","GS","RS","US","SP"].map{$0.chars}
    }
    
    func ascii3codes() -> [[Character]] {
      return ["NUL","SOH","STX","ETX","EOT","ENQ","ACK","BEL",
       "DLE","DC1","DC2","DC3","DC4","NAK","SYN","ETB",
       "CAN","SUB","ESC","DEL"].map{$0.chars}
    }
    
    func ascii2() -> [Character] {
      return [8,9,10,11,12,13,14,15,
              25,28,29,30,31,32].map{Character(UnicodeScalar($0))}
    }
    
    func ascii3() -> [Character] {
      return [0,1,2,3,4,5,6,
        7,16,17,18,19,20,21,
        22,23,24,26,27,16].map{Character(UnicodeScalar($0))}
    }
    
    func naturalOrFloat() -> Parser<S, U, Either<Int, Double>> {
      return lexeme(natFloat()) <?> "number"
    }
    
    func float() -> Parser<S, U, Double> {
      return lexeme(floating()) <?> "float"
    }
    
    func integer() -> Parser<S, U, Int> {
      return lexeme(int()) <?> "integer"
    }
    
    func natural() -> Parser<S, U, Int> {
      return lexeme(nat()) <?> "natural"
    }
    
    func floating() -> Parser<S, U, Double> {
      return decimal() >>- {n in fractExponent(n)}
    }
    
    func natFloat() -> Parser<S, U, Either<Int, Double>> {
      return (char("0") >>- zeroNumFloat()) <|> decimalFloat()
    }
    
    func zeroNumFloat() -> Parser<S, U, Either<Int, Double>> {
      let a: Parser<S, U, Either<Int, Double>> =
        (hexadecimal() <|> octal()) >>- {n in pure(Either.left(n))}
      return a <|> decimalFloat() <|> fractFloat(0) <|> pure(Either.left(0))
    }
    
    func decimalFloat() -> Parser<S, U, Either<Int, Double>> {
      return decimal() >>- {n in  option(Either.left(n), fractFloat(n)) }
    }
    
    func fractFloat<A, B, C>(_ a: A) -> Parser<S, U, Either<B, C>> {
      return fractExponent(a) >>- {f in pure(Either.right(f))}
    }
    
    func fractExponent<A, B>(_ a: A) -> Parser<S, U, B> {
      func readDouble(_ s: String) -> Parser<S, U, B> {
        guard let f = Double(s) else {return parserZero()}
        let r: Parser<S, U, Double> = pure(f)
        return r as! Parser<S, U, B>
      }
      let a: Parser<S, U, B> = fraction() >>- {fract in
        option("", exponent_().fmap{String($0)}) >>- {expo in
          readDouble("\(a)\(fract)\(expo)")} }
      let b: Parser<S, U, B> = exponent_() >>- {expo in
        readDouble("\(a)\(expo)")
      }
      return a <|> b
    }
    
    func fraction() -> Parser<S, U, [Character]> {
      let a: Parser<S, U, Character> = char(".")
      let b: Parser<S, U, [Character]> = many1(digit()) <?> "fraction"
      return a >>- {_ in b >>- {ds in pure(["."] + ds)}}
    }
    
    func exponent_() -> Parser<S, U, [Character]> {
      let a: Parser<S, U, Character> = oneOf("eE".chars)
      let b: Parser<S, U, Character> = oneOf("+-".chars)
      let c: Parser<S, U, [Character]> = b.fmap{[$0]}
      let d: Parser<S, U, [Character]> = c <|> pure([])
      let e: Parser<S, U, Int> = decimal() <?> "exponent"
      let f: Parser<S, U, [Character]> = a >>- {_ in d >>- {sign_ in e >>- {e_ in pure("e\(sign_)\(e_)".chars)}}}
      return f <?> "exponent"
    }
    
    func `int`() -> Parser<S, U, Int> {
      return lexeme(sign()) >>- {f in nat() >>- {n in pure(f(n))}}
    }
    
    func sign() -> Parser<S, U, (Int) -> Int> {
      let a: Parser<S, U, (Int) -> Int> = char("-") >>- pure((-))
      let b: Parser<S, U, (Int) -> Int> = char("-") >>- pure((+))
      return a <|> b <|> pure(id)
    }
    
    func nat() -> Parser<S, U, Int> {
      return zeroNumber() <|> decimal()
    }
    
    func zeroNumber() -> Parser<S, U, Int> {
      let b: Parser<S, U, Int> = hexadecimal() <|> octal() <|> decimal() <|> pure(0)
      return (char("0") >>- b) <?> ""
    }
    
    func decimal() -> Parser<S, U, Int> {
      return number(10, digit())
    }
    
    func hexadecimal() -> Parser<S, U, Int> {
      fatalError("Not implemented yet")
    }
    
    func octal() -> Parser<S, U, Int> {
      fatalError("Not implemented yet")
    }
    
    func number(_ base: Int, _ baseDigit: Parser<S, U, Character>) -> Parser<S, U, Int> {
      fatalError("Not implemented yet")
    }
    
    func reservedOp(_ name: String) -> Parser<S, U, ()> {
      fatalError("Not implemented yet")
    }
    
    func `operator`() -> Parser<S, U, [Character]> {
      fatalError("Not implemented yet")
    }
    
    
    func oper() -> Parser<S, U, [Character]> {
      fatalError("Not implemented yet")
    }
    
    func isReservedOp(_ name: String) -> Bool {
      fatalError("Not implemented yet")
    }
    
    func reserved(_ name: String) -> Parser<S, U, ()> {
      fatalError("Not implemented yet")
    }
    
    func caseString(_ name: String) -> Parser<S, U, String> {
      fatalError("Not implemented yet")
    }
    
    func identifier() -> Parser<S, U, [Character]> {
      fatalError("Not implemented yet")
    }
    
    func ident() -> Parser<S, U, Character> {
      fatalError("Not implemented yet")
    }
    
    func isReservedName(_ name: String) -> Bool {
      fatalError("Not implemented yet")
    }
    
    func isReserved<P>(_ names: [P], _ name: P) -> Bool {
      fatalError("Not implemented yet")
    }
    
    func theReservedNames() -> [String] {
      fatalError("Not implemented yet")
    }
    
    
    func symbol(_ name: String) -> Parser<S, U, String> {
      fatalError("Not implemented yet")
    }
    
    func lexeme<A>(_ p: Parser<S, U, A>) -> Parser<S, U, A> {
      //      return p >>- {x in whitespace}
      fatalError("Not implemented yet")
    }
    
    func whiteSpace() -> Parser<S, U, ()> {
      let noLine = languageDef.commentLine.isEmpty
      let noMulti = languageDef.commentStart.isEmpty
      if noLine && noMulti {
        skipMany(simpleSpace() <?> "")
      } else if noLine {
        skipMany(simpleSpace() <|> multiLineComment() <?> "")
      }
      fatalError("Not implemented yet")
    }
    func simpleSpace() -> Parser<S, U, ()> {
      let space: Parser<S, U, Character> = satisfy(CharacterSet.whitespaces.contains)
      return skipMany1(space)
    }
    
    func oneLineComment() -> Parser<S, U, ()> {
      fatalError("Not implemented yet")
    }
    
    func multiLineComment() -> Parser<S, U, ()> {
      fatalError("Not implemented yet")
    }
    
    func inComment() -> Parser<S, U, ()> {
      fatalError("Not implemented yet")
    }
    
    func inCommentMulti() -> Parser<S, U, ()> {
      fatalError("Not implemented yet")
    }
    
    func inCommentSingle() -> Parser<S, U, ()> {
      fatalError("Not implemented yet")
    }
    
    
    return GenTokenParser<S, U> (
      identifier: identifier().fmap({"\($0)"})
      , reserved: reserved
      , operator: `operator`().fmap({"\($0)"})
      , reservedOp: reservedOp
      , charLiteral: charLiteral()
      , stringLiteral: stringLiteral().fmap({"\($0)"})
      , natural: natural()
      , integer: integer()
      , float: float()
      , naturalOrFloat: naturalOrFloat()
      , decimal: decimal()
      , hexadecimal: hexadecimal()
      , octal: octal()
      , symbol: symbol
      , lexeme: lexeme
      , whiteSpace: whiteSpace()
      , parens: parens
      , braces: braces
      , angles: angles
      , brackets: brackets
      , squares: brackets
      , semi: semi()
      , comma: comma()
      , colon: colon()
      , dot: dot()
      , semiSep: semiSep
      , semiSep1: semiSep1
      , commaSep: commaSep
      , commaSep1: commaSep1
    )
    
}

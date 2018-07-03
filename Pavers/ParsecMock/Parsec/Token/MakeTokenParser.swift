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
      fatalError("Not implemented yet")
    }
    
    func stringLetter() -> Parser<S, U, Character> {
      fatalError("Not implemented yet")
    }
    
    func stringEscape() -> Parser<S, U, Character?> {
      fatalError("Not implemented yet")
    }
    
    func escapeEmpty() -> Parser<S, U, Character> {
      fatalError("Not implemented yet")
    }
    
    func escapeGap() -> Parser<S, U, Character> {
      fatalError("Not implemented yet")
    }
    
    func escapeCode() -> Parser<S, U, Character> {
      fatalError("Not implemented yet")
    }
    
    func charControl() -> Parser<S, U, Character> {
      fatalError("Not implemented yet")
    }
    
    
    func charNum() -> Parser<S, U, Character> {
      fatalError("Not implemented yet")
    }
    
    func charEsc() -> Parser<S, U, Character> {
      fatalError("Not implemented yet")
    }
    
    func charAscii() -> Parser<S, U, Character> {
      fatalError("Not implemented yet")
    }
    
    func escMap() -> [(Character, Character)] {
      let a = "nrt\\\"\'"
      let b = "\n\r\t\\\"\'"
      return zip(a, b).filter(trueness)
    }
    
    func asciiMap() -> [([Character], Character)] {
      fatalError("Not implemented yet")
    }
    
    func ascii2codes() -> [[Character]] {
      fatalError("Not implemented yet")
    }
    
    func ascii3codes() -> [[Character]] {
      fatalError("Not implemented yet")
    }
    
    func ascii2() -> [Character] {
      fatalError("Not implemented yet")
    }
    
    func ascii3() -> [Character] {
      fatalError("Not implemented yet")
    }
    
    func naturalOrFloat() -> Parser<S, U, Either<Int, Double>> {
      fatalError("Not implemented yet")
    }
    
    func float() -> Parser<S, U, Double> {
      fatalError("Not implemented yet")
    }
    
    func integer() -> Parser<S, U, Int> {
      fatalError("Not implemented yet")
    }
    
    func natural() -> Parser<S, U, Int> {
      fatalError("Not implemented yet")
    }
    
    func floating() -> Parser<S, U, Double> {
      fatalError("Not implemented yet")
    }
    
    func natFloat() -> Parser<S, U, Either<Int, Double>> {
      fatalError("Not implemented yet")
    }
    
    func zeroNumFloat() -> Parser<S, U, Either<Int, Double>> {
      fatalError("Not implemented yet")
    }
    
    func decimalFloat() -> Parser<S, U, Either<Int, Double>> {
      fatalError("Not implemented yet")
    }
    
    func fractFloat<A, B, C>(_ a: A) -> Parser<S, U, Either<B, C>> {
      fatalError("Not implemented yet")
    }
    
    func fractExponent<A, B>(_ a: A) -> Parser<S, U, B> {
      fatalError("Not implemented yet")
    }
    
    func fraction() -> Parser<S, U, [Character]> {
      fatalError("Not implemented yet")
    }
    
    func exponent_() -> Parser<S, U, [Character]> {
      fatalError("Not implemented yet")
    }
    
    func `int`() -> Parser<S, U, Int> {
      fatalError("Not implemented yet")
    }
    
    func sign() -> Parser<S, U, (Int) -> Int> {
      fatalError("Not implemented yet")
    }
    
    func nat() -> Parser<S, U, Int> {
      fatalError("Not implemented yet")
    }
    
    func zeroNumber() -> Parser<S, U, Int> {
      fatalError("Not implemented yet")
    }
    
    func decimal() -> Parser<S, U, Int> {
      fatalError("Not implemented yet")
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

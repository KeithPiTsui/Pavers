////
////  JSONParser.swift
////  PaversParsec2
////
////  Created by Keith on 2018/6/26.
////  Copyright © 2018 Keith. All rights reserved.
////
//
import PaversFRP

public enum JSON {
  
  internal static let whitespace: ParserS<Character> = satisfy(CharacterSet.whitespacesAndNewlines.contains) <?> "whitespace"
  internal static let whitespaces = many(whitespace) <?> "whitespaces"
  
  /// Null Type
  public static let null: ParserS<()> = string("null").fmap(terminal) <?> "null"
  
  /// Bool Type
  internal static let bTrue: ParserS<String> = string("true") <?> "true"
  internal static let bFalse: ParserS<String> = string("false") <?> "false"
  public static let bool = (bTrue <|> bFalse).fmap{ $0 == "true" ? true : false } <?> "bool"
  
  
  /// Number Type
  internal static let digit: ParserS<Character> = satisfy(CharacterSet.decimalDigits.contains) <?> "digit"
  internal static let digits = many1(digit) <?> "digits"
  internal static let dicimalPoint: ParserS<Character> = char(".") <?> "dicimal point"
  internal static let plusSign: ParserS<Character> = char("+") <?> "plus sign"
  internal static let minusSign: ParserS<Character> = char("-") <?> "minus sign"
  internal static let plusOrMinus = plusSign <|> minusSign <?> "sign"
  internal static let decimalFactionPart = (dicimalPoint >>> digits) <?> "decimalFactionPart"
  public static let number =
    (plusOrMinus.?
      >>> digits
      >>> decimalFactionPart.?)
      .fmap { (numberParts) -> Double in
        let sign = numberParts.0
        let decimalString = numberParts.1.0
        let fractionString = numberParts.1.1?.1
        var result: Double = 0
        for (i, d) in decimalString.reversed().enumerated() {
          let e: Double = Double(powf(10, Float(i)))
          guard let dd = Double("\(d)") else {fatalError("\(d) must be a digit")}
          result += dd * e
          
        }
        return result
  } <?> "number"
  
  /// String Type
  internal static let letter: ParserS<Character> = satisfy{$0 != "\""}  <?> "letter"
  internal static let letters = many1(letter)  <?> "letters"
  internal static let doubleQuoate: ParserS<Character> = char("\"")  <?> "double quoate"
  public static let jstring = (doubleQuoate >>> letters.? >>> doubleQuoate)
    .fmap { stringParts -> String in
      return String.init(stringParts.1.0 ?? [])
  }  <?> "jstring"
  
  /// Array Type
  internal static let squareBracketFront: ParserS<Character> = char("[")  <?> "squareBracketFront"
  internal static let squareBracketBack: ParserS<Character> = char("]") <?> "squareBracketBack"
  
  internal static let item: () -> ParserS<Any> =
    (try_(anize(null))
      <|> try_(anize(number))
      <|> try_(anize(jstring))
      <|> try_(anize(bool))
      <|> try_(anize({array}))) <?> "item"
  
  
  internal static let comma: ParserS<Character> = char(",")  <?> "comma"
  internal static let itemCommaList: () -> ParserS<[Any]> =
    fmap(item >>> whitespaces >>> many(comma >>> whitespaces >>> item)){
      (parts: (Any, ([Character]?, [(Character, ([Character]?, Any))]?))) -> [Any] in
      let first = parts.0
      if let rest = parts.1.1 {
        let restAnys = rest.map(second).map(second)
        return [first] + restAnys
      } else {
        return [first]
      }
  }  <?> "itemCommaList"
  
  public static let array: () -> ParserS<[Any]> =
    fmap(squareBracketFront >>> whitespaces >>> itemCommaList.? >>> whitespaces >>> squareBracketBack) { (parts: (Character, ([Character]?, ([Any]?, ([Character]?, Character))))) -> [Any] in
      return parts.1.1.0 ?? [] } <?> "array"
  
  
  internal static func anize<A> (_ a : @autoclosure () -> ParserS<A>) -> ParserS<Any> {
    return a().fmap{ (x) -> Any in return x }
  }
  
  internal static func anize<A> (_ a : @escaping () -> ParserS<A>) -> () -> ParserS<Any> {
    return {a().fmap{ (x) -> Any in return x }}
  }
  
  internal static func anize<A> (_ a : @escaping () -> () -> ParserS<A>) -> () -> ParserS<Any> {
    return {a()().fmap{ (x) -> Any in return x }}
  }
  
  /// Object
  internal static let bracketFront: ParserS<Character> = char("{") <?> "bracketFront"
  internal static let bracketEnd: ParserS<Character> = char("}") <?> "bracketEnd"
  internal static let key = jstring <?> "key"
  internal static let colon: ParserS<Character> = char(":") <?> "colon"
  internal static let value: () -> ParserS<Any> =
    (try_(anize(null))
      <|> try_(anize(number))
      <|> try_(anize(jstring))
      <|> try_(anize(bool))
      <|> try_(anize(array))
      <|> try_(anize({object}))) <?> "value"
  
  internal static let keyValuePair: () -> ParserS<(String, Any)> =
    fmap(key >>> whitespaces >>> colon >>> whitespaces >>> value){
      (parts: (String, ([Character]?, (Character, ([Character]?, Any))))) -> (String, Any) in
      let k = parts.0
      let v = parts.1.1.1.1
      return (k, v)
  } <?> "key value pair"
  
  internal static let kvCommaList: () -> ParserS<Dictionary<String, Any>> =
    fmap(keyValuePair >>> whitespaces >>> many(comma >>> whitespaces >>> keyValuePair)){
      (parts: ((String, Any), ([Character]?, [(Character, ([Character]?, (String, Any)))]?))) -> Dictionary<String, Any> in
      let first = parts.0
      var result: [(String, Any)]
      if let rest = parts.1.1 {
        let restAnys = rest.map(second).map(second)
        result = [first] + restAnys
      } else {
        result = [first]
      }
      return Dictionary.init(uniqueKeysWithValues: result)
  } <?> "kvCommaList"
  
  public static let object: () -> ParserS<Dictionary<String, Any>> =
    fmap(bracketFront >>> whitespaces >>> kvCommaList.? >>> whitespaces >>> bracketEnd){
      (parts: (Character, ([Character]?, (Dictionary<String, Any>?, ([Character]?, Character))))) -> Dictionary<String, Any> in
      return parts.1.1.0 ?? [:]
  } <?> "object"
}

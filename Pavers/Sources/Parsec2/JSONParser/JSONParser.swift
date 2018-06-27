////
////  JSONParser.swift
////  PaversParsec2
////
////  Created by Keith on 2018/6/26.
////  Copyright © 2018 Keith. All rights reserved.
////
//
import PaversFRP

internal let whitespace = satisfy(CharacterSet.whitespacesAndNewlines.contains)
internal let whitespaces = many1(whitespace).?

/// Null Type
public let null = string("null")
  .fmap{_ in ()}

/// Bool Type
internal let bTrue = string("true")
internal let bFalse = string("false")
public let bool = (bTrue <|> bFalse)
  .fmap{ $0 == "true" ? true : false }


/// Number Type
internal let digit = satisfy(CharacterSet.decimalDigits.contains)
internal let digits = many1(digit)
internal let dicimalPoint = char(".")
internal let plusSign = char("+")
internal let minusSign = char("-")
internal let plusOrMinus = plusSign <|> minusSign
internal let decimalFactionPart = dicimalPoint >>> digits
public let number =
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
}

/// String Type
internal let letter = satisfy{$0 != "\""}
internal let letters = many1(letter)
internal let doubleQuoate = char("\"")
public let jstring = (doubleQuoate >>> letters.? >>> doubleQuoate)
  .fmap { stringParts -> String in
    return String.init(stringParts.1.0 ?? [])
}

/// Array Type
internal let squareBracketFront = char("[")
internal let squareBracketBack = char("]")

internal let item: () -> Parser<Any> =
  try_(anize(null))
    <|> try_(anize(number))
    <|> try_(anize(jstring))
    <|> try_(anize(bool))
    <|> try_(anize({array}))


internal let comma = char(",")
internal let itemCommaList: () -> Parser<[Any]> =
  fmap(item >>> whitespaces >>> many1(comma >>> whitespaces >>> item).?){
    (parts: (Any, ([Character]?, [(Character, ([Character]?, Any))]?))) -> [Any] in
    let first = parts.0
    if let rest = parts.1.1 {
      let restAnys = rest.map(second).map(second)
      return [first] + restAnys
    } else {
      return [first]
    }
}

public let array: () -> Parser<[Any]> =
  fmap(squareBracketFront >>> whitespaces >>> itemCommaList.? >>> whitespaces >>> squareBracketBack) { (parts: (Character, ([Character]?, ([Any]?, ([Character]?, Character))))) -> [Any] in
    return parts.1.1.0 ?? [] }


internal func anize<A> (_ a : @autoclosure () -> Parser<A>) -> Parser<Any> {
  return a().fmap{ (x) -> Any in return x }
}

internal func anize<A> (_ a : @escaping () -> Parser<A>) -> () -> Parser<Any> {
  return {a().fmap{ (x) -> Any in return x }}
}

internal func anize<A> (_ a : @escaping () -> () -> Parser<A>) -> () -> Parser<Any> {
  return {a()().fmap{ (x) -> Any in return x }}
}

/// Object
internal let bracketFront = char("{")
internal let bracketEnd = char("}")
internal let key = jstring
internal let colon = char(":")
internal let value: () -> Parser<Any> =
  try_(anize(null))
    <|> try_(anize(number))
    <|> try_(anize(jstring))
    <|> try_(anize(bool))
    <|> try_(anize(array))
    <|> try_(anize({object}))

internal let keyValuePair: () -> Parser<(String, Any)> =
  fmap(key >>> whitespaces >>> colon >>> whitespaces >>> value){
    (parts: (String, ([Character]?, (Character, ([Character]?, Any))))) -> (String, Any) in
    let k = parts.0
    let v = parts.1.1.1.1
    return (k, v)
}

internal let kvCommaList: () -> Parser<Dictionary<String, Any>> =
  fmap(keyValuePair >>> whitespaces >>> many1(comma >>> whitespaces >>> keyValuePair).?){
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
}

public let object: () -> Parser<Dictionary<String, Any>> =
  fmap(bracketFront >>> whitespaces >>> kvCommaList.? >>> whitespaces >>> bracketEnd){
    (parts: (Character, ([Character]?, (Dictionary<String, Any>?, ([Character]?, Character))))) -> Dictionary<String, Any> in
    return parts.1.1.0 ?? [:]
}

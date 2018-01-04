//
//  JSONType.swift
//  PaversParsec
//
//  Created by Keith on 04/01/2018.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

let whitespaces = whitespace.*

public let JSONNumber = number()

let x = decimals >>> (decimalPoint >>> decimals).?

func _JSONNull()
  -> () -> Parser<String, Optional<Any>> {
    return {({ _ in return nil } <^> (string("null")))()}
}

public let JSONNull = _JSONNull()

func _JSONBool()
  -> () -> Parser<String, Bool> {
    return {({ value in Bool.init(value)! } <^> (string("true") .|. string("false")))()}
}

public let JSONBool = _JSONBool()

let _JSONQuotaion = string("\"")
let _JSONAnyStringCharacter = character{ $0 != "\"" }
let __JSONString = _JSONQuotaion >>> (_JSONAnyStringCharacter.*) >>> _JSONQuotaion

func _JSONString()
  -> () -> Parser<String, String> {
    return {({ (q, args) in String.init(args.0)  } <^> __JSONString)()}
}

public let JSONString = _JSONString()


let JSONLeftBracket = string("[")
let JSONRightBracket = string("]")
let JSONComma = character{ $0 == "," }
let JSONSemiColon = string(":")


let JSONLeftCurlyBracket = string("{")
let JSONRightCurlyBracket = string("}")
let JSONObjectKey = JSONString
let JSONObjectValue = JSONString .|. JSONNumber .|. JSONNull .|. JSONBool .|. _JSONObject() .|. _JSONArray()
let __JSONObjectKeyValue = JSONObjectKey >>> JSONSemiColon >>> JSONObjectValue
func _JSONObjectKeyValue()
  -> () -> Parser<String, Dictionary<String, Any>> {
    return {({ (key, args) in return [key: args.1]  } <^> __JSONObjectKeyValue)()}
}
public let JSONObjectKeyValue = _JSONObjectKeyValue()


let __JSONObjectKeyValueList = JSONObjectKeyValue >>> (JSONComma >>> JSONObjectKeyValue).*

func + <A, B> (lhs: Dictionary<A, B>, rhs: Dictionary<A, B>) -> Dictionary<A,B> {
  return lhs.merging(rhs, uniquingKeysWith: { (f, s) -> B in
    return s
  })
}

func _JSONObjectKeyValueList()
  -> () -> Parser<String, Dictionary<String, Any>> {
    return {({ (firstKV, _kvs) in _kvs.reduce(firstKV, { (acc, pair) -> Dictionary<String, Any> in acc + pair.1})}
      <^> __JSONObjectKeyValueList)()}
}

public let JSONObjectKeyValueList = _JSONObjectKeyValueList()

let __JSONObject = JSONLeftCurlyBracket >>> JSONObjectKeyValueList.? >>> JSONRightCurlyBracket

func _JSONObject()
  -> () -> Parser<String, Dictionary<String, Any>> {
    return {({ (q, args) in args.0 ?? [:]  } <^> __JSONObject)()}
}

public let JSONObject = _JSONObject()


let __JSONNumberArray = JSONLeftBracket >>> (JSONNumber >>> (JSONComma >>> JSONNumber).*).? >>> JSONRightBracket
//(String, ((Double, [(String, Double)])?, String))
func _JSONNumberArray()
  -> () -> Parser<String, [Double]> {
    return {({ (_, args) in
      guard let (first, ns) = args.0 else {return []}
      return [first] + ns.map(second)
      } <^> __JSONNumberArray)()}
}
let JSONNumberArray = _JSONNumberArray()



let __JSONBoolArray = JSONLeftBracket >>> (JSONBool >>> (JSONComma >>> JSONBool).*).? >>> JSONRightBracket
func _JSONBoolArray()
  -> () -> Parser<String, [Bool]> {
    return {({ (_, args) in
      guard let (first, ns) = args.0 else {return []}
      return [first] + ns.map(second)
      } <^> __JSONBoolArray)()}
}
let JSONBoolArray = _JSONBoolArray()

let __JSONStringArray = JSONLeftBracket >>> (JSONString >>> (JSONComma >>> JSONString).*).? >>> JSONRightBracket
func _JSONStringArray()
  -> () -> Parser<String, [String]> {
    return {({ (_, args) in
      guard let (first, ns) = args.0 else {return []}
      return [first] + ns.map(second)
      } <^> __JSONStringArray)()}
}
let JSONStringArray = _JSONStringArray()


let __JSONObjectArray = JSONLeftBracket >>> (JSONObject >>> (JSONComma >>> JSONObject).*).? >>> JSONRightBracket
func _JSONObjectArray()
  -> () -> Parser<String, [Any]> {
    return {({ (_, args) in
      guard let (first, ns) = args.0 else {return []}
      return [first] + ns.map(second)
      } <^> __JSONObjectArray)()}
}
let JSONObjectArray = _JSONObjectArray()

let __JSONArray = JSONNumberArray .|. JSONBoolArray .|. JSONStringArray .|. JSONObjectArray
func _JSONArray()
  -> () -> Parser<String, [Any]> {
    return {({ arr in arr as! [Any]  } <^> __JSONArray)()}
}
public let JSONArray = _JSONArray()


















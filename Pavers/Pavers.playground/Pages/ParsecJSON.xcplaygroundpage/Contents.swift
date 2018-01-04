//: [Previous](@previous)

import PaversParsec

let jsonNumberLiteral = "1.2"
let jsonStringLiteral = "\"xxxser\""
let jsonBoolLiteral = "true"
let jsonNullLiteral = "null"
let jsonArrayLiteral = "[\"xx\",\"abc\",\"qwe\",\"123\"]"
let jsonObjectLiteral = "{\"name\":\"keith\"}"

let json = 


let numberResutl = JSONNumber().run(ParserInput<String>.init(jsonNumberLiteral))
let boolResutl = JSONBool().run(ParserInput<String>.init(jsonBoolLiteral))
let nullResutl = JSONNull().run(ParserInput<String>.init(jsonNullLiteral))
let stringResutl = JSONString().run(ParserInput<String>.init(jsonStringLiteral))
let arrayResutl = JSONArray().run(ParserInput<String>.init(jsonArrayLiteral))
let objectResutl = JSONObject().run(ParserInput<String>.init(jsonObjectLiteral))

let keyValueLiteral = "\"name\":\"keith\""
let keyValueResult = JSONObjectKeyValueList().run(ParserInput<String>.init(keyValueLiteral))

//: [Next](@next)

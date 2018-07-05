//: [Previous](@previous)

import ParsecMock
import PaversFRP

let a: ParserS<Character> = satisfy(CharacterSet.alphanumerics.contains)

/// parse with empty input, should return empty error
let emptyInput = ParserStateS("")
print(a.unParser(emptyInput))

/// parse with a valid string, should return consumed ok with cursor moved next
let validInput = ParserStateS("a###")
print(a.unParser(validInput))

print()

/// parser with invalid string, should return empty error
let invalidInput = ParserStateS("###")
print(a.unParser(invalidInput))


//: [Next](@next)

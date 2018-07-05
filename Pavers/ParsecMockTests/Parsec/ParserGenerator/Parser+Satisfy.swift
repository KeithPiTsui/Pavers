//
//  Parser+Satisfy.swift
//  ParsecMockTests
//
//  Created by Keith on 2018/7/5.
//  Copyright © 2018 Keith. All rights reserved.
//

import XCTest
@testable import ParsecMock
import PaversFRP

class Parser_Satisfy: XCTestCase {
  
  let a: ParserS<Character> = satisfy(CharacterSet.alphanumerics.contains)
  
  let la: LazyParserS<Character> = satisfy(CharacterSet.alphanumerics.contains)
  
  func testEmptyInput() {
    let emptyInput = ParserStateS("")
    let r = a.unParser(emptyInput)
    if case ParserResult.empty(Reply.error(_)) = r {
      XCTAssert(true)
    } else {
      XCTAssert(false, "Parse with empty input, should return empty error.\(r)")
    }
    
    
    let r1 = la().unParser(emptyInput)
    if case ParserResult.empty(Reply.error(_)) = r1 {
      XCTAssert(true)
    } else {
      XCTAssert(false, "Lazy Parse with empty input, should return empty error.\(r)")
    }
  }
  
  func testValidInput() {
    let validInput = ParserStateS("a###")
    let r = a.unParser(validInput)
    if case let ParserResult.consumed(Reply.ok(a, nextState, _)) = r {
      XCTAssert(a == validInput.stateInput.first()! ,
                "Should move one character forward")
      XCTAssert(nextState.stateInput == validInput.stateInput.tail() ,
                "Should move one character forward")
      XCTAssert(nextState.statePos.column == validInput.statePos.column + 1 ,
                "Should move one character forward")
    } else {
      XCTAssert(false, "parse with a valid string, should return consumed ok with cursor moved next.\(r)")
    }
    
    let r1 = la().unParser(validInput)
    if case let ParserResult.consumed(Reply.ok(a, nextState, _)) = r1 {
      XCTAssert(a == validInput.stateInput.first()! ,
                "Should move one character forward")
      XCTAssert(nextState.stateInput == validInput.stateInput.tail() ,
                "Should move one character forward")
      XCTAssert(nextState.statePos.column == validInput.statePos.column + 1 ,
                "Should move one character forward")
    } else {
      XCTAssert(false, "Lazy parse with a valid string, should return consumed ok with cursor moved next.\(r)")
    }
  }
  
  func testInvalidInput() {
    let invalidInput = ParserStateS("###")
    let r = a.unParser(invalidInput)
    if case ParserResult.empty(Reply.error(_)) = r {
      XCTAssert(true)
    } else {
      XCTAssert(false, "parser with invalid string, should return empty error.\(r)")
    }
    
    let r1 = la().unParser(invalidInput)
    if case ParserResult.empty(Reply.error(_)) = r1 {
      XCTAssert(true)
    } else {
      XCTAssert(false, "Lazy parser with invalid string, should return empty error.\(r)")
    }
  }
  
}

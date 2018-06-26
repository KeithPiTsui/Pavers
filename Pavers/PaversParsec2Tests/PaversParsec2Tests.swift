//
//  PaversParsec2Tests.swift
//  PaversParsec2Tests
//
//  Created by Keith on 2018/6/25.
//  Copyright © 2018 Keith. All rights reserved.
//

import XCTest
@testable import PaversParsec2

class PaversParsec2Tests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
//    print("hello")
//    let a = char("a")
//    let r = a.parse("a")
//    print(r)
//    let r = expr.parse("let let_expression")
//    print(r)
//    print("xxx".startIndex)
    
    let r = identifier.parse("abc@")
    print(r)
    
    
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}

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
    
    //    let r = identifier.parse("abc@")
    //    print(r)
//    let r = number.parse("+12.23")
//    print(r)
//    let r1 = number.parse("-12.23")
//    print(r1)
//    let r2 = number.parse("0.23")
//    print(r2)
//    let r3 = number.parse("021")
//    print(r3)
//    let r4 = number.parse(".23")
//    print(r4)
//      print("\(pow(10, 2))")
    
      let r = array.parse("[1,2,\"123\"]")
    print(r)
    let r1 = object.parse("{\"keith\":[1,2,\"123\"]}")
    print(r1)
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}

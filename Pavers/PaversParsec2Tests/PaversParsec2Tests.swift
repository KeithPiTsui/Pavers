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
    let arr = array()
    let r = arr.parse("[ 1, 2, \"123\" ]")
    print(r)
    let r2 = arr.parse("[ 1, 2, \"123\", [ 1, 2, \"123\" ] ]")
    print(r2)
    
    //    let r1 = object.parse("{\"keith\":[1,2,\"123\"]}")
    //    print(r1)
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}

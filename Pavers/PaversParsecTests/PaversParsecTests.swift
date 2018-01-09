//
//  PaversParsecTests.swift
//  PaversParsecTests
//
//  Created by Keith on 30/11/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
@testable import PaversParsec

class PaversParsecTests: XCTestCase {
  
    func testExample() {
//        let x = arithmetic().run("(1+2*3/(5-5*(2.5-1)+3))*2+(1-2)-1")
      let expression = "1.5E-10"
      let x = num().run(ParserInput.init(source: expression, cursor: expression.startIndex))
      print(x)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

//
//  PaversParsecTests.swift
//  PaversParsecTests
//
//  Created by Keith on 30/11/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import XCTest
import PaversFRP
@testable import PaversParsec

class PaversParsecTests: XCTestCase {
  
  func testExample() {
    //        let x = arithmetic().run("(1+2*3/(5-5*(2.5-1)+3))*2+(1-2)-1")
    let expression = "1.5E-10"
    let x = num().run(ParserInput.init(source: expression, cursor: expression.startIndex))
    print(x)
  }
  
  func testJSONParser() {
    guard let jsonStr = jsonString(named: "test") else {print("cannot get json string"); return}
    let trimmedJsonStr = jsonStr.removingWhitespacesAndNewlines()
    print("\(trimmedJsonStr)")
    let objectParser = JSONObject()
    let input = ParserInput<String>.init(trimmedJsonStr)
    let result = objectParser.run(input)
    print("\(result)")
  }
  
}

internal func jsonString(named filename: String, and fileextension: String = "json") -> String? {
  let bundle = Bundle(for: PaversParsecTests.self)
  guard
    let filePath = bundle.path(
      forResource: filename,
      ofType: fileextension,
      inDirectory: nil)
    else { XCTAssert(false, "No corresponding json file \(filename).\(fileextension)"); return nil }
  let fileURL = URL(fileURLWithPath: filePath)
  guard
    let jsonStr = try? String(contentsOf: fileURL)
    else { XCTAssert(false, "Cannot extract string from file \(fileURL)"); return nil }
  return jsonStr
}

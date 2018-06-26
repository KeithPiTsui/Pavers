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
  
  let json: String = """
  {"code":"1",
    "data":{
  "a":"1511513956242234968",
  "b":"alipay_sdk=alipay-sdk-php-20161101&app_id=2017072507893211&biz_content=%7B%22body%22%3A%22%E6%B8%B8%E6%88%8F%E5%B8%81%22%2C%22subject%22%3A+%22%E6%B8%B8%E6%88%8F%E5%B8%81%E5%85%85%E5%80%BC%22%2C%22out_trade_no%22%3A+%221511513956242234968%22%2C%22timeout_express%22%3A+%2230m%22%2C%22total_amount%22%3A+%220.01%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%7D&charset=UTF-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2Fwww.521qw.com%2Fsdk3.0%2Falipay%2Fnotify_url.php&sign_type=RSA2&timestamp=2017-11-24+16%3A59%3A16&version=1.0&sign=ZBjf%2BH3izhfHy64txhMH7fgVWZ7NKdwguMibqAwYBQTTrlzKmSBv9EcNXcPJfqKTntGf0FwGi8PTdz8hFWfQfn9o9NfRGZHGsTS%2FFlh4I%2B%2FJqtS6XSQj4dZS%2BX6aYAbCsrFGVc3o1ANvdXuPRJdkw7tLjssWSD09DMo%2FsQctIE0%3D"},
  "msg":"abcsede"
  }
  """
  
  
  func testExample() {
    print(self.json)
    let ob = object()
    let r5 = ob.parse(ParserState.init(stringLiteral: self.json))
    print(r5)
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}

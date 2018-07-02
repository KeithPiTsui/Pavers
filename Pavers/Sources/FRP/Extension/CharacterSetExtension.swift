//
//  CharacterSetExtension.swift
//  ParsecMock
//
//  Created by Keith on 2018/7/2.
//  Copyright © 2018 Keith. All rights reserved.
//

import Foundation


extension CharacterSet {
  public static var hexDigits: CharacterSet {
    let abc = CharacterSet(charactersIn: "abcdefABCDEF")
    return CharacterSet.decimalDigits.union(abc)
  }
  
  public static var octalDigits: CharacterSet {
    return CharacterSet(charactersIn: "01234567")
  }
  
  public func contains(_ c: Character) -> Bool {
    let cs = CharacterSet.init(charactersIn: "\(c)")
    return self.isSuperset(of: cs)
  }
  
  
}

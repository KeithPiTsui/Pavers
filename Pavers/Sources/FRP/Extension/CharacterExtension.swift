//
//  CharacterExtension.swift
//  ParsecMock
//
//  Created by Keith on 2018/7/3.
//  Copyright © 2018 Keith. All rights reserved.
//

extension Character {
  public var fromEnum: Int {
    return Int(self.unicodeScalars.first!.value)
  }
  
  public static func toEnum(_ n: Int) -> Character {
    return Character.init(UnicodeScalar.init(n)!)
  }
}

//
//  CharacterSetExtension.swift
//  ParsecMock
//
//  Created by Keith on 2018/7/2.
//  Copyright © 2018 Keith. All rights reserved.
//

import Foundation

extension CharacterSet {
  public func contains(_ c: Character) -> Bool {
    let cs = CharacterSet.init(charactersIn: "\(c)")
    return self.isSuperset(of: cs)
  }
  
  public static func + (_ lhs: CharacterSet, _ rhs: CharacterSet) -> CharacterSet {
    return lhs.union(rhs)
  }
}

extension NSCharacterSet {
  public var characters:[String] {
    var chars = [String]()
    for plane:UInt8 in 0...16 {
      if self.hasMemberInPlane(plane) {
        let p0 = UInt32(plane) << 16
        let p1 = (UInt32(plane) + 1) << 16
        for c:UTF32Char in p0..<p1 {
          if self.longCharacterIsMember(c) {
            var c1 = c.littleEndian
            if let s = NSString(bytes: &c1, length: 4, encoding: String.Encoding.utf32LittleEndian.rawValue) {
              chars.append(String(s))
            }
          }
        }
      }
    }
    return chars
  }
}


extension CharacterSet {
  public var characters: [String] {
    return (self as NSCharacterSet).characters
  }
}

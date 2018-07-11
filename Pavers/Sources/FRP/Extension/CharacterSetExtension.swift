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
  public var lazyCharacters:
    LazyCollection<FlattenCollection<LazyMapCollection<LazyFilterCollection<(ClosedRange<UInt8>)>, [Character]>>> {
    return ((0...16) as ClosedRange<UInt8>)
      .lazy
      .filter(self.hasMemberInPlane)
      .flatMap { (plane) -> [Character] in
        let p0 = UInt32(plane) << 16
        let p1 = (UInt32(plane) + 1) << 16
        return ((p0 ..< p1) as Range<UTF32Char>)
          .lazy
          .filter(self.longCharacterIsMember)
          .compactMap(UnicodeScalar.init)
          .map(Character.init)}
  }
  
  public var characters:[Character] {
      return Array(self.lazyCharacters)
  }
}

extension CharacterSet {
  public var characters: [Character] {
    return (self as NSCharacterSet).characters
  }
}

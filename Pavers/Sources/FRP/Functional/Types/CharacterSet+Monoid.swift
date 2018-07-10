//
//  CharacterSet+Monoid.swift
//  PaversFRP
//
//  Created by Keith on 2018/7/10.
//  Copyright © 2018 Keith. All rights reserved.
//

extension CharacterSet: Semigroup {
  public func op(_ other: CharacterSet) -> CharacterSet {
    return self + other
  }
}

extension CharacterSet: Monoid {
  public static func identity() -> CharacterSet {
    return CharacterSet()
  }
}

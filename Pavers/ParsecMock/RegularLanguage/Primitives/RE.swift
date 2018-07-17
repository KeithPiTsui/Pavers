//
//  RegularExpression.swift
//  ParsecMock
//
//  Created by Keith on 2018/7/16.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public enum RegularExpression<Symbol> {
  /// empty string of symbol
  case epsilon
  /// empty language that contain no string of symbol
  case empty
  /// one symbol
  case primitives(Symbol)
  indirect case union(RegularExpression<Symbol>, RegularExpression<Symbol>)
  indirect case concatenation(RegularExpression<Symbol>, RegularExpression<Symbol>)
  indirect case kleeneClosure(RegularExpression<Symbol>)
  indirect case parenthesis(RegularExpression<Symbol>)
}

extension RegularExpression {
  public static func + (_ lhs: RegularExpression, _ rhs: RegularExpression)
    -> RegularExpression {
      return .union(lhs, rhs)
  }
  
  public static func * (_ lhs: RegularExpression, _ rhs: RegularExpression)
    -> RegularExpression {
      return .concatenation(lhs, rhs)
  }
  
  public static postfix func .* (_ re: RegularExpression)
    -> RegularExpression {
      return .kleeneClosure(re)
  }
}





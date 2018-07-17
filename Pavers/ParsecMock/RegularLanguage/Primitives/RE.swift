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

extension RegularExpression: CustomStringConvertible {
  public var description: String {
    switch self {
    case .epsilon:
      return "ε"
    case .empty:
      return "∅"
    case .primitives(let s):
      return "\(s)"
    case .union(let lhs, let rhs):
      return "\(lhs.description) + \(rhs.description)"
    case .concatenation(let lhs, let rhs):
      return "(\(lhs.description))(\(rhs.description))"
    case .kleeneClosure(let re):
      return "(\(re.description))*"
    case .parenthesis(let re):
      return "(\(re.description)"
    }
  }
}

extension RegularExpression {
  public static func + (_ lhs: RegularExpression, _ rhs: RegularExpression)
    -> RegularExpression {
      switch (lhs, rhs) {
      case (.empty, let rhs):
        return rhs
      case (let lhs, .empty):
        return lhs
      default:
        return .union(lhs, rhs)
      }
  }
  
  public static func * (_ lhs: RegularExpression, _ rhs: RegularExpression)
    -> RegularExpression {
      switch (lhs, rhs) {
      case (.empty, _), (_, .empty):
        return .empty
      case (.epsilon, let rhs):
        return rhs
      case (let lhs, .epsilon):
        return lhs
      default:
        return .concatenation(lhs, rhs)
      }
  }
  
  public static postfix func .* (_ re: RegularExpression)
    -> RegularExpression {
      switch re {
      case .empty:
        return .empty
      case .epsilon:
        return .epsilon
      case .union(let lhs, let rhs):
        if case .epsilon = lhs {
          return .kleeneClosure(rhs)
        } else if case .epsilon = rhs {
          return .kleeneClosure(lhs)
        } else {
          return .kleeneClosure(re)
        }
      default:
        return .kleeneClosure(re)
      }
  }
}





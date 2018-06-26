//
//  Parser+Try.swift
//  PaversParsec2
//
//  Created by Keith on 2018/6/26.
//  Copyright © 2018 Keith. All rights reserved.
//

public func try_ <A> (_ a: Parser<A>) -> Parser<A> {
  return Parser {
    switch a.parse($0) {
    case .consumed(.error(let e)):
      return .empty(.error(e))
    case let otherwise:
      return otherwise
    }
  }
}

public func try_ <A> (_ a: @escaping () -> Parser<A>) -> () -> Parser<A> {
  return {
    Parser {
      switch a().parse($0) {
      case .consumed(.error(let e)):
        return .empty(.error(e))
      case let otherwise:
        return otherwise
      }
    }
  }
}

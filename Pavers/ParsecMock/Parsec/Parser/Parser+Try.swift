//
//  Parser+Try.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/28.
//  Copyright © 2018 Keith. All rights reserved.
//

public func try_ <S, U, A> (_ a: Parser<S, U, A>) -> Parser<S, U, A> {
  return Parser {
    switch a.unParser($0) {
    case .consumed(.error(let e)):
      return .empty(.error(e))
    case let otherwise:
      return otherwise
    }
  }
}


public func try_ <S, U, A> (_ a: @escaping () -> Parser<S, U, A>) -> () -> Parser<S, U, A> {
  return {Parser {
    switch a().unParser($0) {
    case .consumed(.error(let e)):
      return .empty(.error(e))
    case let otherwise:
      return otherwise
    }
    }}
}
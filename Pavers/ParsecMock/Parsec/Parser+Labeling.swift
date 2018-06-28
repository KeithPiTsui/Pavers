//
//  Parser+Labeling.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/28.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public func <?> <S,U,A> (_ a: Parser<S,U,A>, _ label: String) -> Parser<S,U,A> {
  return Parser {
    switch a.unParser($0) {
    case .empty(.error(let e)):
      return .empty(.error(expect(e, label)))
    case .empty(let .ok(x, state, e)):
      return .empty(.ok(x, state, expect(e, label)))
    case let otherwise: return otherwise
    }
  }
}

private func expect (_ e: ParserError, _ exp: String) -> ParserError {
  return e.add(error: Message.expect(exp))
}

//
//  Parser+Labeling.swift
//  PaversParsec2
//
//  Created by Keith on 2018/6/26.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public func <?> <A> (_ a: Parser<A>, _ label: String) -> Parser<A> {
  return Parser {
    switch a.parse($0) {
    case .empty(.error(let msg)):
      return .empty(.error(expect(msg, label)))
    case .empty(let .okay(x, state, msg)):
      return .empty(.okay(x, state, expect(msg, label)))
    case let otherwise: return otherwise
    }
  }
}

private func expect (_ msg: ParserMessage, _ exp: String) -> ParserMessage {
  return ParserMessage(position: msg.position, message: msg.message, grammarProductions: [exp])
}

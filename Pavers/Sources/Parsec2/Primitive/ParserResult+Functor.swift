//
//  ParserResult+Functor.swift
//  PaversParsec2
//
//  Created by Keith on 2018/6/26.
//  Copyright © 2018 Keith. All rights reserved.
//


extension Reply {
  public func fmap<B>(_ f: (A) -> B) -> Reply<B> {
    switch self {
    case let .okay(a, state, message):
      return .okay(f(a), state, message)
    case let .error(e):
      return .error(e)
    }
  }
}

extension ParseResult {
  public func fmap<B>(_ f: (A) -> B) -> ParseResult<B> {
    switch self {
    case let .consumed(r):
      return .consumed(r.fmap(f))
    case let .empty(r):
      return .empty(r.fmap(f))
    }
  }
}


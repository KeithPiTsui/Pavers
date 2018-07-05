//
//  Parser+Alternative.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/28.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public func <|> <S, U, A> (_ a: @escaping LazyParser<S, U, A>, _ b: @escaping LazyParser<S, U, A>)
  -> LazyParser<S, U, A> {
    return {Parser {
      switch a().unParser($0) {
      case .consumed(let r): return .consumed(r)
      case .empty(.error(let e1)):
        switch b().unParser($0) {
        case .consumed(let r): return .consumed(r)
        case .empty(.error(let e2)): return .empty(.error(e1.op(e2)))
        case .empty(let .ok(x, s, e2)): return .empty(.ok(x, s, e1.op(e2)))
        }
      case .empty(let .ok(x, s, e1)):
        switch b().unParser($0) {
        case .consumed(let r): return .consumed(r)
        case .empty(.error(let e2)):
          return .empty(.ok(x, s, e1.op(e2)))
        case .empty(let .ok(_, _, e2)):
          return .empty(.ok(x, s, e1.op(e2)))
        }
      }
      }
    }
}

public func <|> <S, U, A>
  (_ a: Parser<S, U, A>, _ b: Parser<S, U, A>)
  -> Parser<S, U, A> {
    return ({a} <|> {b})()
}

public func <|> <S, U, A> (_ a: Parser<S, U, A>, _ b: @escaping LazyParser<S, U, A>)
  -> LazyParser<S, U, A> {
    return {a} <|> b
}

public func <|> <S, U, A> (_ a: @escaping LazyParser<S, U, A>, _ b:Parser<S, U, A>)
  -> LazyParser<S, U, A> {
    return a <|> {b}
}

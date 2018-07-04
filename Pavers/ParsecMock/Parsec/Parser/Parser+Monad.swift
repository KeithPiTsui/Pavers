//
//  Parser+Monad.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/28.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public func >>- <S, U, A, B> (_ a: Parser<S, U, A>, _ f: @escaping (A) -> Parser<S, U, B>) -> Parser<S, U, B> {
  return Parser{
    switch a.unParser($0) {
    case .consumed (let reply):
      switch reply {
      case .error(let e): return .consumed(.error(e))
      case let .ok(x, input, _):
        switch f(x).unParser(input) {
        case .consumed(let r): return .consumed(r)
        case .empty(let r): return .consumed(r)
        }
      }
    case .empty(let reply):
      switch reply {
      case .error(let e): return .empty(.error(e))
      case let .ok(x, input, _): return f(x).unParser(input)
      }
    }
  }
}

public func >>- <S, U, A, B> (_ a: Parser<S, U, A>, _ b: Parser<S, U, B>) -> Parser<S, U, B> {
  return a >>- {_ in b}
}


/// m a -> m b -> m (a, b)
public func >>> <S, U, A, B> (_ a: Parser<S, U, A>, _ b: Parser<S, U, B>) -> Parser<S, U, (A, B)> {
  return a >>- {a in b >>- {b in pure((a, b))}}
}

public func >>> <S, U, A, B> (_ a: @escaping () -> Parser<S, U, A>, _ b:Parser<S, U, B>) -> () -> Parser<S, U, (A, B)> {
  return {a() >>- {a in b >>- {b in pure((a, b))}}}
}

public func >>> <S, U, A, B> (_ a: Parser<S, U, A>, _ b: @escaping () -> Parser<S, U, B>) -> () -> Parser<S, U, (A, B)> {
  return {a >>- {a in b() >>- {b in pure((a, b))}}}
}

public func >>> <S, U, A, B> (_ a: @escaping () -> Parser<S, U, A>, _ b: @escaping () -> Parser<S, U, B>) -> () -> Parser<S, U, (A, B)> {
  return {a() >>- {a in b() >>- {b in pure((a, b))}}}
}

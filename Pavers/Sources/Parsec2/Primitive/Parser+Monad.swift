//
//  Parser+Monad.swift
//  PaversParsec2
//
//  Created by Keith on 2018/6/26.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public func >>- <A, B> (_ a: Parser<A>, _ f: @escaping (A) -> Parser<B>) -> Parser<B> {
  return Parser{
    switch a.parse($0) {
    case .consumed (let reply):
      switch reply {
      case .error(let e): return .consumed(.error(e))
      case let .okay(x, input, _):
        switch f(x).parse(input) {
        case .consumed(let r): return .consumed(r)
        case .empty(let r): return .consumed(r)
        }
      }
    case .empty(let reply):
      switch reply {
      case .error(let e): return .empty(.error(e))
      case let .okay(x, input, _): return f(x).parse(input)
      }
    }
  }
}

public func >>- <A, B> (_ a: Parser<A>, _ b: Parser<B>) -> Parser<B> {
  return a >>- {_ in b}
}


/// m a -> m b -> m (a, b)
public func >>> <A, B> (_ a: Parser<A>, _ b: Parser<B>) -> Parser<(A, B)> {
  return a >>- {a in b >>- {b in pure((a, b))}}
}

public func >>> <A, B> (_ a: @escaping () -> Parser<A>, _ b:Parser<B>) -> () -> Parser<(A, B)> {
  return {a() >>- {a in b >>- {b in pure((a, b))}}}
}

public func >>> <A, B> (_ a: Parser<A>, _ b: @escaping () -> Parser<B>) -> () -> Parser<(A, B)> {
  return {a >>- {a in b() >>- {b in pure((a, b))}}}
}


public func >>> <A, B> (_ a: @escaping () -> Parser<A>, _ b: @escaping () -> Parser<B>) -> () -> Parser<(A, B)> {
  return {a() >>- {a in b() >>- {b in pure((a, b))}}}
}

//
//  Parser+Monad.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/28.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

//parserReturn :: a -> ParsecT s u m a
//parserReturn x
//= ParsecT $ \s _ _ eok _ ->
//eok x s (unknownError s)
public func parserReturn<S, U, A>(_ a: A) -> LazyParser<S, U, A> {
  return {Parser<S, U, A>{ state in ParserResult<Reply<S, U, A>>.empty(
    {Reply<S, U, A>.ok(a, state, ParserError(pos: state.statePos, msgs: []))})
    }
  }
}

public func parserReturn<S, U, A>(_ a: A) -> Parser<S, U, A> {
  return parserReturn(a)()
}

/// m a -> (a -> m b) -> m b
public func >>- <S, U, A, B> (_ a: @escaping LazyParser<S, U, A>, _ f: @escaping (A) -> LazyParser<S, U, B>)
  -> LazyParser<S, U, B> {
    return {Parser{
      switch a().unParser($0) {
      case .consumed (let reply):
        switch reply() {
        case .error(let e): return .consumed({.error(e)})
        case let .ok(x, input, _):
          switch f(x)().unParser(input) {
          case .consumed(let r): return .consumed(r)
          case .empty(let r): return .consumed(r)
          }
        }
      case .empty(let reply):
        switch reply() {
        case .error(let e): return .empty({.error(e)})
        case let .ok(x, input, _): return f(x)().unParser(input)
        }
      }
      }}
}

public func >>- <S, U, A, B> (_ a: @escaping LazyParser<S, U, A>, _ f: @escaping (A) -> Parser<S, U, B>)
  -> LazyParser<S, U, B> {
    return a >>- {a in {f(a)}}
}

public func >>- <S, U, A, B> (_ a: Parser<S, U, A>, _ f: @escaping (A) -> LazyParser<S, U, B>)
  -> LazyParser<S, U, B> {
    return {a} >>- f
}


public func >>- <S, U, A, B> (_ a: Parser<S, U, A>, _ f: @escaping (A) -> Parser<S, U, B>) -> Parser<S, U, B> {
  return ({a} >>- f)()
}


/// m a -> m b -> m b
public func >>- <S, U, A, B> (_ a: @escaping LazyParser<S, U, A>, _ b: @escaping LazyParser<S, U, B>)
  -> LazyParser<S, U, B> {
    return a >>- {_ in b}
}


public func >>- <S, U, A, B> (_ a: Parser<S, U, A>, _ b: @escaping LazyParser<S, U, B>)
  -> LazyParser<S, U, B> {
    return a >>- {_ in b}
}

public func >>- <S, U, A, B> (_ a: @escaping LazyParser<S, U, A>, _ b: Parser<S, U, B>)
  -> LazyParser<S, U, B> {
    return a >>- {_ in b}
}

public func >>- <S, U, A, B> (_ a: Parser<S, U, A>, _ b: Parser<S, U, B>) -> Parser<S, U, B> {
  return a >>- {_ in b}
}


/// m a -> m b -> m (a, b)
public func >>> <S, U, A, B> (_ a: @escaping LazyParser<S, U, A>, _ b: @escaping LazyParser<S, U, B>)
  -> LazyParser<S, U, (A, B)> {
    return {a() >>- {a in b() >>- {b in pure((a, b))}}}
}

public func >>> <S, U, A, B> (_ a: @escaping LazyParser<S, U, A>, _ b:Parser<S, U, B>)
  -> LazyParser<S, U, (A, B)> {
    return a >>> {b}
}

public func >>> <S, U, A, B> (_ a: Parser<S, U, A>, _ b: @escaping LazyParser<S, U, B>)
  -> LazyParser<S, U, (A, B)> {
    return {a} >>> b
}

public func >>> <S, U, A, B> (_ a: Parser<S, U, A>, _ b: Parser<S, U, B>)
  -> Parser<S, U, (A, B)> {
    return ({a} >>> {b})()
}


//
//  Parser+Monoid.swift
//  ParsecMock
//
//  Created by Keith on 2018/7/5.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

//parserZero :: ParsecT s u m a
//parserZero
//= ParsecT $ \s _ _ _ eerr ->
//eerr $ unknownError s

public func parserZero<S, U, A> () -> Parser<S, U, A> {
  return Parser{ state in
    .empty(.error( ParserError(unknownErrorWith: state.statePos) ))
  }
}

extension Parser: Semigroup where A: Semigroup {
  public func op(_ other: Parser<S, U, A>) -> Parser<S, U, A> {
    return self.op({other})()
  }
  
  public func op(_ other: @escaping LazyParser<S, U, A>) -> LazyParser<S, U, A> {
    return {Parser<S, U, A> { (s: ParserState<S, U>) in
      switch self.unParser(s) {
      case .consumed(let rep):
        switch rep {
        case let .ok(a, s_, _):
          switch other().unParser(s_) {
          case .consumed(let rep_):
            switch rep_ {
            case let .ok(a_, s__, e_):
              return .consumed(.ok(a.op(a_), s__, e_))
            case let otherwise:
              return .consumed(otherwise)
            }
          case .empty(let rep_):
            switch rep_ {
            case let .ok(a_, s__, e_):
              return .consumed(.ok(a.op(a_), s__, e_))
            case let otherwise:
              return .consumed(otherwise)
            }
          }
          
        case let otherwise: return .consumed(otherwise)
        }
      case .empty(let rep):
        switch rep {
        case let .ok(a, s_, _):
          switch other().unParser(s_) {
          case .consumed(let rep_):
            switch rep_ {
            case let .ok(a_, s__, e_):
              return .consumed(.ok(a.op(a_), s__, e_))
            case let otherwise:
              return .consumed(otherwise)
            }
          case .empty(let rep_):
            switch rep_ {
            case let .ok(a_, s__, e_):
              return .empty(.ok(a.op(a_), s__, e_))
            case let otherwise:
              return .empty(otherwise)
            }
          }
          
        case let otherwise: return .consumed(otherwise)
        }
      }
    }
    }}
  
}

extension Parser: Monoid where A: Monoid {
  public static func identity() -> Parser<S, U, A> {
    return parserZero()
  }
}

/// (Monoid a) => m a -> m a -> m a
public func >>> <S, U, A> (_ a: @escaping LazyParser<S, U, A>, _ b: @escaping LazyParser<S, U, A>)
  -> LazyParser<S, U, A> where A: Semigroup {
    return { a().op(b)() }
}

public func >>> <S, U, A> (_ a: @escaping LazyParser<S, U, A>, _ b:Parser<S, U, A>)
  -> LazyParser<S, U, A> where A: Semigroup {
    return a >>> {b}
}

public func >>> <S, U, A> (_ a: Parser<S, U, A>, _ b: @escaping LazyParser<S, U, A>)
  -> LazyParser<S, U, A> where A: Semigroup  {
    return {a} >>> b
}

public func >>> <S, U, A> (_ a: Parser<S, U, A>, _ b: Parser<S, U, A>)
  -> Parser<S, U, A> where A: Semigroup {
    return ({a} >>> {b})()
}

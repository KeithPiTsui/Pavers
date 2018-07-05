//
//  Primitive.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/27.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

/**
 Monadic Parser which can parse language both context free and context sensitive.
 Monadic Parser are unable to deal with left-recursion.
 The first thing a left-recursive parser would do is to call itself, resulting in an infinite
 
 `expr ::= expr "+" factor`
 
 `factor ::= number | "(" expr ")"`
 
 LL Parsing algorithm.
 
 predictive parser with limited look ahead.
 */
public struct Parser<S, U, A> {
  public let unParser: (ParserState<S, U>) -> ParserResult<Reply<S, U, A>>
}

public typealias ParserS<A> = Parser<String, (), A>
public typealias LazyParser<S, U, A> = () -> Parser<S, U, A>
public typealias LazyParserS<A> = LazyParser<String, (), A>

public typealias ParserResultHandler<S, U, A> = (ParserResult<Reply<S, U, A>>) -> ()
public func attach<S, U, A>(_ p: @escaping LazyParser<S, U, A>, with handler: @escaping ParserResultHandler<S, U, A>)
  -> LazyParser<S, U, A> {
    return {Parser<S, U, A> { state in
      let x = p().unParser(state)
      handler(x)
      return x
      }
    }
}

public func attach<S, U, A>(_ p: Parser<S, U, A>, with handler: @escaping ParserResultHandler<S, U, A>)
  -> Parser<S, U, A> {
    return attach({p}, with: handler)()
}

public func <?> <S,U,A>(_ p: Parser<S, U, A>, handler: @escaping ParserResultHandler<S, U, A>)
  -> Parser<S, U, A> {
  return attach(p, with: handler)
}

public func <?> <S,U,A>(_ p: @escaping LazyParser<S, U, A>, handler: @escaping ParserResultHandler<S, U, A>)
  -> LazyParser<S, U, A> {
    return attach(p, with: handler)
}

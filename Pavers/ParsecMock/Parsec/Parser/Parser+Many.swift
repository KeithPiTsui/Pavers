//
//  Parser+Many.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/28.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public func manyAccum<S, U, A>(_ acc: @escaping ([A], A) -> [A], _ p : @escaping LazyParser<S, U, A>)
  -> LazyParser<S, U, [A]> {
    return p >>- {x in
      manyAccum(acc, p) <|> (pure([]) as LazyParser<S, U, [A]>) >>- {xs in
        pure(acc(xs, x)) as LazyParser<S, U, [A]> }}
}

public func manyAccum<S, U, A>(acc: @escaping ([A], A) -> [A], p : Parser<S, U, A>) -> Parser<S, U, [A]> {
  return p >>- { x in (manyAccum(acc: acc, p: p) <|> pure([])) >>- {xs in pure(acc(xs, x))} }
}

public func many<S,U,A> (_ a: Parser<S,U,A>) -> Parser<S,U,[A]> {
  return manyAccum(acc: { $0 + [$1]}, p: a)
}

public func many1<S,U,A> (_ a: Parser<S,U,A>) -> Parser<S,U,[A]> {
  return a >>- { x in many(a) >>- {xs in pure([x] + xs)} }
}

public func many1<S, U, A> (_ a: @escaping () -> Parser<S, U, A>) -> () -> Parser<S, U, [A]> {
  return { () -> Parser<S, U, [A]> in
    a() >>- {(x:A) -> Parser<S, U, [A]> in
      (many1(a)() <|> (pure([]) as Parser<S, U, [A]>)) >>- {
        (xs: [A]) -> Parser<S, U, [A]> in
        pure([x] + xs)
      }
    }
  }
}

public func skipMany<S,U,A>(_ p: Parser<S, U, A>) -> Parser<S, U, ()> {
  return many(p).fmap{_ in ()}
}


//
//  Parser+Many.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/28.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP
public func many1<S,U,A> (_ a: Parser<S,U,A>) -> Parser<S,U,[A]> {
  return a >>- { x in (many1(a) <|> pure([])) >>- {xs in pure([x] + xs)} }
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

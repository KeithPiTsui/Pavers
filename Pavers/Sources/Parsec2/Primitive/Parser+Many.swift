//
//  Parser+Many.swift
//  PaversParsec2
//
//  Created by Keith on 2018/6/26.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public func many1<A> (_ a: Parser<A>) -> Parser<[A]> {
  return a >>- { x in (many1(a) <|> pure([])) >>- {xs in pure([x] + xs)} }
}

public func many1<A> (_ a: @escaping () -> Parser<A>) -> () -> Parser<[A]> {
  return { () -> Parser<[A]> in
    a() >>- {(x:A) -> Parser<[A]> in
      (many1(a)() <|> (pure([]) as Parser<[A]>)) >>- {
        (xs: [A]) -> Parser<[A]> in
        pure([x] + xs)
      }
    }
  }
}
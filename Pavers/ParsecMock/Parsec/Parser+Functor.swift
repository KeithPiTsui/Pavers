//
//  Parser+Functor.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/28.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP


extension Parser {
  /// fmap :: (a -> b) -> f a -> f b
  public func fmap<B>(_ f: @escaping (A) -> B ) -> Parser<S, U, B>  {
    return Parser<S, U, B> { self.unParser($0).fmap{ $0.fmap(f) } }
  }
}

/// fmap :: (a -> b) -> f a -> f b
public func fmap<S, U, A, B>
  (_ fa: @escaping () -> Parser<S, U, A>, _ f: @escaping (A) -> B)
  -> () -> Parser<S, U, B> {
    return { Parser<S, U, B> { fa().unParser($0).fmap{ $0.fmap(f) } } }
}

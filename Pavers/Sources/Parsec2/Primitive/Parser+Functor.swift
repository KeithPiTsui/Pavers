//
//  Parser+Functor.swift
//  PaversParsec2
//
//  Created by Keith on 2018/6/26.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

extension Parser {
  /// fmap :: (a -> b) -> f a -> f b
  public func fmap<B>(_ f: @escaping (A) -> B ) -> Parser<B>  {
    return Parser<B>{ self.parse($0).fmap(f) }
  }
}

//
//  Paser+Applicative.swift
//  PaversParsec2
//
//  Created by Keith on 2018/6/26.
//  Copyright © 2018 Keith. All rights reserved.
//

public func pure<A> (_ a: A) -> Parser<A> {
  return Parser{ .empty(.okay(a, $0,
                              ParserMessage(position: $0.position, message: "", grammarProductions: [])))}
}

/// apply :: f (a -> b) -> f a -> f b
//public func apply

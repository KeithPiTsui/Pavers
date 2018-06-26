//
//  Parser+Optional.swift
//  PaversParsec2
//
//  Created by Keith on 2018/6/26.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public func optionalize<A>(_ a: Parser<A>) -> Parser<A?> {
  return try_(a.fmap(Optional.init)) <|> pure(nil)
}

postfix func .? <A> (_ a: Parser< A>)
  -> Parser<A?> {
    return optionalize(a)
}


public func optionalize<A>(_ a: @escaping () -> Parser<A>) -> () -> Parser<A?> {
  return {try_(a().fmap(Optional.init)) <|> pure(nil)}
}

postfix func .? <A> (_ a: @escaping () -> Parser< A>)
  -> () -> Parser<A?> {
    return optionalize(a)
}

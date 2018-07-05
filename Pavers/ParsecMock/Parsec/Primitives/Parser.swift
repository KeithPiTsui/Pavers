//
//  Primitive.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/27.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public struct Parser<S, U, A> {
  public let unParser: (ParserState<S, U>) -> ParserResult<Reply<S, U, A>>
}

public typealias LazyParser<S, U, A> = () -> Parser<S, U, A>

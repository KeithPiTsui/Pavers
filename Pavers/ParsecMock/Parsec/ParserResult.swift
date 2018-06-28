//
//  ParserResult.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/27.
//  Copyright © 2018 Keith. All rights reserved.
//

public enum ParserResult<A> {
  case consumed(A)
  case empty(A)
}

public enum Reply<S, U, A> {
  case ok(A, ParserState<S, U>, ParserError)
  case error(ParserError)
}



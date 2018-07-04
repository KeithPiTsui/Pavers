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

//lookAhead :: (Stream s m t) => ParsecT s u m a -> ParsecT s u m a
//lookAhead p =
//ParsecT $ \s _ cerr eok eerr -> do
//let eok' a _ _ = eok a s (newErrorUnknown (statePos s))
//unParser p s eok' cerr eok' eerr
public func lookAhead<S, U, A>(p: Parser<S, U, A>) -> Parser<S, U, A> {
  return Parser<S, U, A> { state in
    switch p.unParser(state) {
    case .consumed(let reply):
      switch reply {
      case let .ok(a, _, _):
        return .empty(.ok(a, state, ParserError(unknownErrorWith: state.statePos)))
      case let otherwise: return .consumed(otherwise)
      }
    case .empty(let reply):
      switch reply {
      case let .ok(a, _, _):
        return .empty(.ok(a, state, ParserError(unknownErrorWith: state.statePos)))
      case let otherwise: return .empty(otherwise)
      }
    }
  }
}


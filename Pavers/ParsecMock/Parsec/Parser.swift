//
//  Primitive.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/27.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public func unknownError<S, U>(_ s: ParserState<S, U>) -> ParserError {
  return ParserError(unknownErrorWith: s.statePos)
}

public func sysUnExpectError<S, U, A>(_ msg: String, _ pos: SourcePos) -> Reply<S, U, A> {
  return Reply<S, U, A>
    .error(ParserError(newErrorWith: Message.sysUnExpect(msg),
                       pos: pos))
}

public struct Parser<S, U, A> {
  public let unParser: (ParserState<S, U>) -> ParserResult<Reply<S, U, A>>
}


//parserReturn :: a -> ParsecT s u m a
//parserReturn x
//= ParsecT $ \s _ _ eok _ ->
//eok x s (unknownError s)



//extension Parser: Semigroup where A: Semigroup {
//  public func op(_ other: Parser<S, U, A>) -> Parser<S, U, A> {
//    return Parser<S, U, A> { (s: ParserState<S, U>) in
//      switch self.unParser(s) {
//      case .consumed(let rep):
//        switch rep {
//
//        case let .ok(a, s_, e):
//          switch other.unParser(s_) {
//          case .consumed(let rep_):
//            switch rep_ {
//            case let .ok(a_, s__, e_):
//              return .consumed(.ok(a.op(a_), s__, e_))
//            case let otherwise:
//              return .consumed(otherwise)
//            }
//          case .empty(let rep_):
//            switch rep_ {
//            case let .ok(a_, s__, e_):
//              return .consumed(.ok(a.op(a_), s__, e_))
//            case let otherwise:
//              return .consumed(otherwise)
//            }
//          }
//
//          case let otherwise: return .consumed(otherwise)
//        }
//      case .empty(let rep):
//        switch rep {
//        case let .ok(a, s_, e):
//          break;
//        case let otherwise: return .empty(otherwise)
//        }
//      }
//    }
//  }
//
//
//}

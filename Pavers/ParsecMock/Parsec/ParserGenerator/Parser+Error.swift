//
//  Parser+Error.swift
//  ParsecMock
//
//  Created by Keith on 2018/7/4.
//  Copyright © 2018 Keith. All rights reserved.
//

//parserFail :: String -> ParsecT s u m a
//parserFail msg
//= ParsecT $ \s _ _ _ eerr ->
//eerr $ newErrorMessage (Message msg) (statePos s)
public func parserFail<S, U, A>(_ msg: String) -> Parser<S, U, A> {
  return Parser<S, U, A> { state in
    return ParserResult.empty(Reply.error(ParserError(newErrorWith: Message.message(msg), pos: state.statePos)))
  }
}

//unexpected :: (Stream s m t) => String -> ParsecT s u m a
//unexpected msg
//= ParsecT $ \s _ _ _ eerr ->
//eerr $ newErrorMessage (UnExpect msg) (statePos s)
public func unexpected<S, U, A> (_ msg: String) -> Parser<S, U, A> {
  return Parser<S,U,A> { state in
    return ParserResult.empty(Reply.error(ParserError.init(newErrorWith: Message.unexpect(msg), pos: state.statePos)))
  }
}

//parserFail :: String -> ParsecT s u m a
//parserFail msg
//= ParsecT $ \s _ _ _ eerr ->
//eerr $ newErrorMessage (Message msg) (statePos s)

public func parserFail<S, U, A>(msg: String) -> Parser<S, U, A> {
  return Parser{ state in
    .empty(.error( ParserError(newErrorWith: Message.message(msg), pos: state.statePos) ))
  }
}

//parserZero :: ParsecT s u m a
//parserZero
//= ParsecT $ \s _ _ _ eerr ->
//eerr $ unknownError s

public func parserZero<S, U, A> () -> Parser<S, U, A> {
  return Parser{ state in
    .empty(.error( ParserError(unknownErrorWith: state.statePos) ))
  }
}

//parserReturn :: a -> ParsecT s u m a
//parserReturn x
//= ParsecT $ \s _ _ eok _ ->
//eok x s (unknownError s)
public func parserReturn<S, U, A>(_ a: A) -> Parser<S, U, A> {
  return pure(a)
}

//parserPlus :: ParsecT s u m a -> ParsecT s u m a -> ParsecT s u m a
//{-# INLINE parserPlus #-}
//parserPlus m n
//  = ParsecT $ \s cok cerr eok eerr ->
//let
//meerr err =
//let
//neok y s' err' = eok y s' (mergeError err err')
//neerr err' = eerr $ mergeError err err'
//in unParser n s cok cerr neok neerr
//in unParser m s cok cerr eok meerr

//public func parserPlus <S, U, A>
//  (m: Parser<S, U, A>, n: Parser<S, U, A>)
//  -> Parser<S, U, A> {
//    return Parser<S, U, A> { state in
//      let r1 = n.unParser(state)
//      let r2 = m.unParser(state)
//
//
//
//      return r2
//    }
//}

//labels :: ParsecT s u m a -> [String] -> ParsecT s u m a
//labels p msgs =
//ParsecT $ \s cok cerr eok eerr ->
//let eok' x s' error = eok x s' $ if errorIsUnknown error
//then error
//else setExpectErrors error msgs
//eerr' err = eerr $ setExpectErrors err msgs
//
//in unParser p s cok cerr eok' eerr'
//
//where
//setExpectErrors err []         = setErrorMessage (Expect "") err
//setExpectErrors err [msg]      = setErrorMessage (Expect msg) err
//setExpectErrors err (msg:msgs)
//= foldr (\msg' err' -> addErrorMessage (Expect msg') err')
//(setErrorMessage (Expect msg) err) msgs



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

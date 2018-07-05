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
public func parserFail<S, U, A>(_ msg: String) -> LazyParser<S, U, A> {
  return {Parser<S, U, A> { state in
    return ParserResult.empty(Reply.error(ParserError(newErrorWith: Message.message(msg), pos: state.statePos)))
    }}
}

public func parserFail<S, U, A>(_ msg: String) -> Parser<S, U, A> {
  return parserFail(msg)()
}

//unexpected :: (Stream s m t) => String -> ParsecT s u m a
//unexpected msg
//= ParsecT $ \s _ _ _ eerr ->
//eerr $ newErrorMessage (UnExpect msg) (statePos s)
public func unexpected<S, U, A> (_ msg: String) -> LazyParser<S, U, A> {
  return {Parser<S,U,A> { state in
    return ParserResult.empty(Reply.error(ParserError.init(newErrorWith: Message.unexpect(msg), pos: state.statePos)))
  }}
}

public func unexpected<S, U, A> (_ msg: String) -> Parser<S, U, A> {
  return unexpected(msg)()
}



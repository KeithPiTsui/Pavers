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

//newtype ParsecT s u m a
//  = ParsecT {unParser :: forall b .
//    State s u
//    -> (a -> State s u -> ParseError -> m b) -- consumed ok
//    -> (ParseError -> m b)                   -- consumed err
//    -> (a -> State s u -> ParseError -> m b) -- empty ok
//    -> (ParseError -> m b)                   -- empty err
//    -> m b
//}


public struct ParsecT<S, U, M, A, B> where M: Monad {
  public let unParser: (ParserState<S, U>)
    -> ((A) -> (ParserState<S, U>) -> (ParserError) -> HKT_TypeParameter_Binder<M, B>)
    -> ((ParserError) -> HKT_TypeParameter_Binder<M, B>)
    -> ((A) -> (ParserState<S, U>) -> (ParserError) -> HKT_TypeParameter_Binder<M, B>)
    -> ((ParserError) -> HKT_TypeParameter_Binder<M, B>)
    -> HKT_TypeParameter_Binder<M, B>
}

//runParsecT :: Monad m => ParsecT s u m a -> State s u -> m (Consumed (m (Reply s u a)))
//runParsecT p s = parse s cok cerr eok eerr
//where
//parse = unParser p
//cok a s' err = return . Consumed . return $ Ok a s' err
//cerr err = return . Consumed . return $ Error err
//eok a s' err = return . Empty . return $ Ok a s' err
//eerr err = return . Empty . return $ Error err

//public func runParsecT <S, U, M, A, B> (_ p: ParsecT<S, U, M, A, B>, _ s: ParserState<S, U>)
//  -> TypeApplication<M, ParserResult<TypeApplication<M, Reply<S, U, A>>>> where M: Monad {
//    
//}



//public typealias Parsec<S, U, A, B: ValueKeeper> = ParsecT<S, U, Identity<B>, A, B>

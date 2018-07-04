//
//  Parser+Many.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/28.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP
public func many1<S,U,A> (_ a: Parser<S,U,A>) -> Parser<S,U,[A]> {
  return a >>- { x in many(a) >>- {xs in pure([x] + xs)} }
}

public func many1<S, U, A> (_ a: @escaping () -> Parser<S, U, A>) -> () -> Parser<S, U, [A]> {
  return { () -> Parser<S, U, [A]> in
    a() >>- {(x:A) -> Parser<S, U, [A]> in
      (many1(a)() <|> (pure([]) as Parser<S, U, [A]>)) >>- {
        (xs: [A]) -> Parser<S, U, [A]> in
        pure([x] + xs)
      }
    }
  }
}


//
//manyAccum :: (a -> [a] -> [a])
//-> ParsecT s u m a
//-> ParsecT s u m [a]
//manyAccum acc p =
//ParsecT $ \s cok cerr eok _eerr ->
//  [a] -> a -> State s u -> ParseError -> m b
//let walk xs x s' _err =
//unParser p s'
//(seq xs $ walk $ acc x xs)  -- consumed-ok
//cerr                        -- consumed-err
//manyErr                     -- empty-ok
//(\e -> cok (acc x xs) s' e) -- empty-err
//  in unParser p s (walk []) cerr manyErr (\e -> eok [] s e)
//
//manyErr :: a
//manyErr = error "Text.ParserCombinators.Parsec.Prim.many: combinator 'many' is applied to a parser that accepts an empty string."

public func manyAccum<S, U, A>(acc: @escaping ([A], A) -> [A], p : Parser<S, U, A>) -> Parser<S, U, [A]> {
  return p >>- { x in (manyAccum(acc: acc, p: p) <|> pure([])) >>- {xs in pure(acc(xs, x))} }
}

public func many<S,U,A> (_ a: Parser<S,U,A>) -> Parser<S,U,[A]> {
  return manyAccum(acc: { $0 + [$1]}, p: a)
}

//skipMany :: ParsecT s u m a -> ParsecT s u m ()
//skipMany p
//= do _ <- manyAccum (\_ _ -> []) p
//return ()
public func skipMany<S,U,A>(_ p: Parser<S, U, A>) -> Parser<S, U, ()> {
  return many(p).fmap{_ in ()}
}
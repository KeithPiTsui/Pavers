//
//  Parser+Combinator.swift
//  ParsecMock
//
//  Created by Keith on 2018/7/2.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

//choice :: (Stream s m t) => [ParsecT s u m a] -> ParsecT s u m a
//choice ps           = foldr (<|>) mzero ps

public func choice<S, U, A>(_ ps: [Parser<S, U, A>]) -> Parser<S, U, A> {
  return ps.reduce(parserZero(), (<|>))
}


//option :: (Stream s m t) => a -> ParsecT s u m a -> ParsecT s u m a
//option x p          = p <|> return x
public func option<S, U, A> (_ x: A, _ p: Parser<S, U, A>) -> Parser<S, U, A> {
  return p <|> pure(x)
}

//optionMaybe :: (Stream s m t) => ParsecT s u m a -> ParsecT s u m (Maybe a)
//optionMaybe p       = option Nothing (liftM Just p)
public func optionMaybe<S, U, A> (_ p: Parser<S, U, A>) -> Parser<S, U, A?> {
  return option(nil, p.fmap{$0})
}

//optional :: (Stream s m t) => ParsecT s u m a -> ParsecT s u m ()
//optional p          = do{ _ <- p; return ()} <|> return ()
public func optional<S, U, A> (_ p: Parser<S, U, A>) -> Parser<S, U, ()> {
  return p >>- {_ in pure(())}
}

//between :: (Stream s m t) => ParsecT s u m open -> ParsecT s u m close
//-> ParsecT s u m a -> ParsecT s u m a
//between open close p
//= do{ _ <- open; x <- p; _ <- close; return x }
public func between<S, U, A, O, C> (_ open: Parser<S, U, O>, _ close: Parser<S, U, C>, _ p: Parser<S, U, A>)
  -> Parser<S, U, A> {
    return open >>- {_ in  p >>- {a in close >>- {_ in pure(a) } } }
}

//skipMany1 :: (Stream s m t) => ParsecT s u m a -> ParsecT s u m ()
//skipMany1 p         = do{ _ <- p; skipMany p }
public func skipMany1<S, U, A> (_ p: Parser<S, U, A>) -> Parser<S, U, ()> {
  return p >>- {_ in skipMany(p)}
}

//sepBy :: (Stream s m t) => ParsecT s u m a -> ParsecT s u m sep -> ParsecT s u m [a]
//sepBy p sep         = sepBy1 p sep <|> return []

public func sepBy<S, U, A, SEP> (_ p: Parser<S, U, A>, _ sep: Parser<S, U, SEP>) -> Parser<S, U, [A]> {
  return sepBy1(p, sep) <|> pure([])
}


//sepBy1 :: (Stream s m t) => ParsecT s u m a -> ParsecT s u m sep -> ParsecT s u m [a]
//sepBy1 p sep        = do{ x <- p
//  ; xs <- many (sep >> p)
//  ; return (x:xs)
//}
public func sepBy1<S, U, A, SEP> (_ p: Parser<S, U, A>, _ sep: Parser<S, U, SEP>) -> Parser<S, U, [A]> {
  return p >>- {x in many(sep >>- p) >>- {xs in pure([x]+xs)}}
}


//sepEndBy1 :: (Stream s m t) => ParsecT s u m a -> ParsecT s u m sep -> ParsecT s u m [a]
//sepEndBy1 p sep     = do{ x <- p
//  ; do{ _ <- sep
//    ; xs <- sepEndBy p sep
//    ; return (x:xs)
//  }
//  <|> return [x]
//}

public func sepEndBy1<S, U, A, SEP> (_ p: Parser<S, U, A>, _ sep: Parser<S,U,SEP>) -> Parser<S, U, [A]> {
//  let xs: Parser<S, U, [A]> =
  return p >>- {x in (sep >>- {_ in sepEndBy(p, sep) >>- {xs in pure([x] + xs)}}) <|> pure([]) }
}

//
//sepEndBy :: (Stream s m t) => ParsecT s u m a -> ParsecT s u m sep -> ParsecT s u m [a]
//sepEndBy p sep      = sepEndBy1 p sep <|> return []
public func sepEndBy<S, U, A, SEP> (_ p: Parser<S, U, A>, _ sep: Parser<S,U,SEP>) -> Parser<S, U, [A]> {
  return sepEndBy1(p, sep) <|> pure([])
}

//endBy1 :: (Stream s m t) => ParsecT s u m a -> ParsecT s u m sep -> ParsecT s u m [a]
//endBy1 p sep        = many1 (do{ x <- p; _ <- sep; return x })
public func endBy1<S, U, A, SEP> (_ p: Parser<S, U, A>, _ sep: Parser<S,U,SEP>) -> Parser<S, U, [A]> {
  return many1(p >>- {a in sep >>- {_ in pure(a)}})
}

//endBy :: (Stream s m t) => ParsecT s u m a -> ParsecT s u m sep -> ParsecT s u m [a]
//endBy p sep         = many (do{ x <- p; _ <- sep; return x })
public func endBy<S, U, A, SEP> (_ p: Parser<S, U, A>, _ sep: Parser<S,U,SEP>) -> Parser<S, U, [A]> {
  return many(p >>- {a in sep >>- {_ in pure(a)}})
}

//count :: (Stream s m t) => Int -> ParsecT s u m a -> ParsecT s u m [a]
//count n p           | n <= 0    = return []
//  | otherwise = sequence (replicate n p)
//public func count<S, U, A> (_ n: Int, _ p: Parser<S, U, A>) -> Parser<S, U, [A]> {
//  guard n > 0 else { return pure([])}
//  
//}


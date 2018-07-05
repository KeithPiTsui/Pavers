//
//  Parser+Applicative.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/28.
//  Copyright © 2018 Keith. All rights reserved.
//

public func pure<S, U, A> (_ a: A) -> LazyParser<S, U, A>{
  return parserReturn(a)
}

public func pure<S, U, A> (_ a: A) -> Parser<S, U, A> {
  return pure(a)()
}



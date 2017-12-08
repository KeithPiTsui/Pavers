//
//  Parser+Monad.swift
//  PaversParsec
//
//  Created by Keith on 06/12/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversFRP
/**
 flatMap a function over an parser value (left associative)
 
 - If the value cannot parse `input`, the function will not be evaluated and this will
 return `nil`
 - If the value can parse `input`, the function will be applied to the parsed result
 
 - parameter f: A transformation function from type `T` to type `Parser<U>`
 - parameter a: A value of type `Parser<T>`
 
 - returns: A value of type `Parser<U>`
 */
public func >>- <T, U>(a: @escaping () -> Parser<T>,
                       f: @escaping (T) -> Parser<U>)
  -> () -> Parser<U> {
    return {Parser<U> {
      guard case .success(let result) = a().run($0)
        else {return .failure(ParserError.init(code: 0, message: ""))}
      return f(result.result).run(ParserInput.init(source: $0.source, cursor: result.outputCursor))
      }}
}

/**
 flatMap a function over an optional value (right associative)
 
 - If the value cannot parse `input`, the function will not be evaluated and this will
 return `nil`
 - If the value can parse `input`, the function will be applied to the parsed result
 
 - parameter a: A value of type `Parser<T>`
 - parameter f: A transformation function from type `T` to type `Parser<U>`
 
 - returns: A value of type `Parser<U>`
 */
public func -<< <T, U>(f: @escaping (T) -> Parser<U>,
                       a: @escaping () -> Parser<T>)
  -> () -> Parser<U> {
  return a >>- f
}

/**
 compose two functions that produce Parser values, from left to right
 
 - If the result of the first function is `nil`, the second function will
 not be inoked and this will return `nil`
 - If the result of the first function is `not nil`, the value is unwrapped and
 passed to the second function which may return `nil`
 
 - parameter f: A transformation function from type `T` to type `Parser<U>`
 - parameter g: A transformation function from type `U` to type `Parser<V>`
 
 - returns: A function from type `T` to type `Parser<V>`
 */
public func >>> <T, U, V>(f: @escaping (T) -> Parser<U>,
                          g: @escaping (U) -> Parser<V>)
  -> (T) -> Parser<V> {
    return { x in ({f(x)} >>- g)() }
}

/**
 compose two functions that produce optional values, from right to left
 
 - If the result of the first function is `.none`, the second function will
 not be inoked and this will return `.none`
 - If the result of the first function is `.some`, the value is unwrapped and
 passed to the second function which may return `.none`
 
 - parameter f: A transformation function from type `U` to type `Parser<V>`
 - parameter g: A transformation function from type `T` to type `Parser<U>`
 
 - returns: A function from type `T` to type `Parser<V>`
 */
public func <<< <T, U, V>(f: @escaping (U) -> Parser<V>,
                          g: @escaping (T) -> Parser<U>)
  -> (T) -> Parser<V> {
  return g >>> f
}

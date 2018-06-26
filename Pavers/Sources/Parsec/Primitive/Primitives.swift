//
//  Primitives.swift
//  Parsec
//
//  Created by Keith on 2018/6/25.
//  Copyright © 2018 QW. All rights reserved.
//
import PaversFRP

internal struct Parser<A> {
  let getParser: (String) -> Consumed<A>
}

internal enum Replay<A> {
  case Ok (A, String)
  case Error
}

internal enum Consumed<A> {
  case Consumed (Replay<A>)
  case Empty (Replay<A>)
}


internal func pure<A> (_ a: @escaping @autoclosure () -> A) -> Parser<A> {
  return Parser{ .Empty(.Ok(a(), $0))}
}

internal func satisfy(_ test: @escaping (Character) -> Bool) -> Parser<Character> {
  return Parser{
    guard let first = $0.first, test(first) else {return .Empty(.Error)}
    return .Consumed(.Ok(first, String($0.dropFirst())))
  }
}

internal let char = {satisfy(curry(==)($0))}
internal let letter = satisfy(CharacterSet.alphanumerics.contains)
internal let digit = satisfy(CharacterSet.decimalDigits.contains)


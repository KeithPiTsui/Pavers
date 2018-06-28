//
//  Parser+Satisfy.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/28.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public enum List<T> {
  indirect case cons(T, List<T>)
  case none
}

extension String {
  public var list: List<Character> {
    return self.reduce(List<Character>.none) { List<Character>.cons($1, $0)}
  }
}

extension List: IteratorProtocol {
  public mutating func next() -> T? {
    switch self {
    case let .cons(x, xs): self = xs;return x
    case .none: return nil
    }
  }
}

extension List: Sequence{}

extension List: Collection {
  public typealias Index = Int
  public func index(after i: Int) -> Int {
    return i + 1
  }
  
  public subscript(position: Int) -> T {
    var l = self
    for _ in 0 ..< position {
      _ = l.next()
    }
    guard let x = l.next() else {fatalError("out of range")}
    return x
  }
  
  public var startIndex: Int {
    return 0
  }
  
  public var endIndex: Int {
    var c = 0
    for _ in self {
      c += 1
    }
    return c
  }
}


public func satisfy<U>(_ test: @escaping (Character) -> Bool)
  -> Parser<String, U, Character> {
    return Parser{
      let input = $0.stateInput
      let pos = $0.statePos
      guard let first = input.first else {
        return .empty(.error(
          ParserError(newErrorWith: Message.message("end of input"), pos: pos)))
      }
      guard test(first) else {
        return .empty(.error(
          ParserError(newErrorWith: Message.message("\(first)"), pos: pos)))
      }
      let newPos = pos.update(PosBy: first)
      let newState = ParserState(stateInput: String(input.dropFirst()), statePos: newPos, stateUser: $0.stateUser)
      return ParserResult<Reply<String, U, Character>>
        .consumed(Reply<String, U, Character>
          .ok(first, newState, ParserError(newErrorWith: Message.message(""), pos: pos)))
    }
}

public func satisfy<S,U,A>(_ test: @escaping (A) -> Bool)
  -> Parser<S, U, A> where S: ParserStream, S.Element == A {
    return Parser{
      let input = $0.stateInput
      let pos = $0.statePos

      guard let first = input.first() else {
        return .empty(.error(
          ParserError(newErrorWith: Message.message("end of input"), pos: pos)))
      }
      guard test(first) else {
        return .empty(.error(
          ParserError(newErrorWith: Message.message("\(first)"), pos: pos)))
      }
      let newPos = pos.incPos()
      let newState = ParserState(stateInput: input.droppingFirst(),
                                 statePos: newPos,
                                 stateUser: $0.stateUser)
      return ParserResult<Reply<S, U, A>>
        .consumed(Reply<S, U, A>
          .ok(first, newState, ParserError(newErrorWith: Message.message(""), pos: pos)))
    }
}

public func char<U>(_ c: Character) -> Parser<String, U, Character> {
  return satisfy(curry(==)(c))
}

public func string<S: StringProtocol, U>(_ s: S) -> Parser<String, U, String> {
  guard let c = s.first else {return pure("")}
  return char(c) >>- { c in string(s.dropFirst()) >>- { cs in pure([c] + cs) } }
}

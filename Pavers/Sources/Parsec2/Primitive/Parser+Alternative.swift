//
//  Parser+Alternative.swift
//  PaversParsec2
//
//  Created by Keith on 2018/6/26.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public func <|> <A> (_ a: Parser<A>, _ b: Parser<A>) -> Parser<A> {
  return Parser {
    switch a.parse($0) {
    case .consumed(let r): return .consumed(r)
    case .empty(.error(let msg1)):
      switch b.parse($0) {
      case .consumed(let r): return .consumed(r)
      case .empty(.error(let msg2)): return mergeError(msg1, msg2)
      case .empty(let .okay(x, input, msg2)): return mergeOk(x, input, msg1, msg2)
      }
    case .empty(let .okay(x, input, msg1)):
      switch b.parse($0) {
      case .consumed(let r): return .consumed(r)
      case .empty(.error(let msg2)):
        return mergeOk(x, input, msg1, msg2)
      case .empty(let .okay(_, _, msg2)):
        return mergeOk(x, input, msg1, msg2)
      }
    }
  }
}

public func <|> <A> (_ a: Parser<A>, _ b: @escaping () -> Parser<A>) -> () -> Parser<A> {
  return {
    Parser {
      switch a.parse($0) {
      case .consumed(let r): return .consumed(r)
      case .empty(.error(let msg1)):
        switch b().parse($0) {
        case .consumed(let r): return .consumed(r)
        case .empty(.error(let msg2)): return mergeError(msg1, msg2)
        case .empty(let .okay(x, input, msg2)): return mergeOk(x, input, msg1, msg2)
        }
      case .empty(let .okay(x, input, msg1)):
        switch b().parse($0) {
        case .consumed(let r): return .consumed(r)
        case .empty(.error(let msg2)):
          return mergeOk(x, input, msg1, msg2)
        case .empty(let .okay(_, _, msg2)):
          return mergeOk(x, input, msg1, msg2)
        }
      }
    }
  }
}

public func <|> <A> (_ a: @escaping () -> Parser<A>, _ b: Parser<A>) -> () -> Parser<A> {
  return {
    Parser {
      switch a().parse($0) {
      case .consumed(let r): return .consumed(r)
      case .empty(.error(let msg1)):
        switch b.parse($0) {
        case .consumed(let r): return .consumed(r)
        case .empty(.error(let msg2)): return mergeError(msg1, msg2)
        case .empty(let .okay(x, input, msg2)): return mergeOk(x, input, msg1, msg2)
        }
      case .empty(let .okay(x, input, msg1)):
        switch b.parse($0) {
        case .consumed(let r): return .consumed(r)
        case .empty(.error(let msg2)):
          return mergeOk(x, input, msg1, msg2)
        case .empty(let .okay(_, _, msg2)):
          return mergeOk(x, input, msg1, msg2)
        }
      }
    }
  }
}

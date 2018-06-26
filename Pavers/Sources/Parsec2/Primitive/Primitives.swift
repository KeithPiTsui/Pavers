//
//  Primitives.swift
//  Parsec
//
//  Created by Keith on 2018/6/25.
//  Copyright © 2018 QW. All rights reserved.
//
import PaversFRP



//public typealias ParserState = String

public struct ParserState {
  let content: String
  let position: Int
}

public struct Message {
  let position: Int
  let message: String
  let grammarProductions: [String]
}

public struct Parser<A> {
  let parse: (ParserState) -> ParseResult<A>
}

public enum Reply<A> {
  case okay (A, ParserState, Message)
  case error (Message)
}

public enum ParseResult<A> {
  case consumed (Reply<A>)
  case empty (Reply<A>)
}


public func pure<A> (_ a: A) -> Parser<A> {
  return Parser{ .empty(.okay(a, $0,
                              Message(position: $0.position, message: "", grammarProductions: [])))}
}

public func satisfy(_ test: @escaping (Character) -> Bool) -> Parser<Character> {
  return Parser{
    let input = $0.content
    let pos = $0.position
    guard let first = input.first else {
      return .empty(.error(
        Message(position: pos, message: "end of input", grammarProductions: [])))
    }
    guard test(first) else {
      return .empty(.error(
        Message(position: pos, message: "\(first)", grammarProductions: [])))
    }
    let newPos = pos + 1
    let newState = ParserState.init(content: String(input.dropFirst()), position: newPos)
    return .consumed(.okay(first,
                           newState,
                           Message(position: pos, message: "", grammarProductions: [])))
  }
}

public func >>- <A, B> (_ a: Parser<A>, _ f: @escaping (A) -> Parser<B>) -> Parser<B> {
  return Parser{
    switch a.parse($0) {
    case .consumed (let reply):
      switch reply {
      case .error(let e): return .consumed(.error(e))
      case let .okay(x, input, _):
        switch f(x).parse(input) {
        case .consumed(let r): return .consumed(r)
        case .empty(let r): return .consumed(r)
        }
      }
    case .empty(let reply):
      switch reply {
      case .error(let e): return .empty(.error(e))
      case let .okay(x, input, _): return f(x).parse(input)
      }
    }
  }
}

public func tryp <A> (_ a: Parser<A>) -> Parser<A> {
  return Parser {
    switch a.parse($0) {
    case .consumed(.error(let e)):
      return .empty(.error(e))
    case let otherwise:
      return otherwise
    }
  }
}

private func mergeOk<A>(_ x: A,
                        _ input: ParserState,
                        _ msg1: Message,
                        _ msg2: Message) -> ParseResult<A> {
  return .empty(.okay(x, input, merge(msg1, msg2)))
}

private func mergeError<A>(_ msg1: Message, _ msg2: Message) -> ParseResult<A> {
  return ParseResult.empty(Reply.error( merge(msg1, msg2) ))
}


private func merge (_ a: Message, _ b: Message) -> Message {
  return Message(position: a.position,
                 message: a.message,
                 grammarProductions: a.grammarProductions + b.grammarProductions)
}

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

public func <?> <A> (_ a: Parser<A>, _ label: String) -> Parser<A> {
  return Parser {
    switch a.parse($0) {
    case .empty(.error(let msg)):
      return .empty(.error(expect(msg, label)))
    case .empty(let .okay(x, state, msg)):
      return .empty(.okay(x, state, expect(msg, label)))
    case let otherwise: return otherwise
    }
  }
}

private func expect (_ msg: Message, _ exp: String) -> Message {
  return Message(position: msg.position, message: msg.message, grammarProductions: [exp])
}

//
//  Message.swift
//  PaversParsec2
//
//  Created by Keith on 2018/6/26.
//  Copyright © 2018 Keith. All rights reserved.
//

public struct ParserMessage {
  let position: Int
  let message: String
  let grammarProductions: [String]
}


internal func mergeOk<A>(_ x: A,
                        _ input: ParserState,
                        _ msg1: ParserMessage,
                        _ msg2: ParserMessage) -> ParseResult<A> {
  return .empty(.okay(x, input, merge(msg1, msg2)))
}

internal func mergeError<A>(_ msg1: ParserMessage, _ msg2: ParserMessage) -> ParseResult<A> {
  return ParseResult.empty(Reply.error( merge(msg1, msg2) ))
}


internal func merge (_ a: ParserMessage, _ b: ParserMessage) -> ParserMessage {
  return ParserMessage(position: a.position,
                 message: a.message,
                 grammarProductions: a.grammarProductions + b.grammarProductions)
}




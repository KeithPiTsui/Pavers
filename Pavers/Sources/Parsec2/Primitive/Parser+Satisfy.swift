//
//  Parser+Satisfy.swift
//  PaversParsec2
//
//  Created by Keith on 2018/6/26.
//  Copyright © 2018 Keith. All rights reserved.
//


public func satisfy(_ test: @escaping (Character) -> Bool) -> Parser<Character> {
  return Parser{
    let input = $0.content
    let pos = $0.position
    guard let first = input.first else {
      return .empty(.error(
        ParserMessage(position: pos, message: "end of input", grammarProductions: [])))
    }
    guard test(first) else {
      return .empty(.error(
        ParserMessage(position: pos, message: "\(first)", grammarProductions: [])))
    }
    let newPos = pos + 1
    let newState = ParserState.init(content: String(input.dropFirst()), position: newPos)
    return .consumed(.okay(first,
                           newState,
                           ParserMessage(position: pos, message: "", grammarProductions: [])))
  }
}

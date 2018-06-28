//
//  Parser+Satisfy.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/28.
//  Copyright © 2018 Keith. All rights reserved.
//

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

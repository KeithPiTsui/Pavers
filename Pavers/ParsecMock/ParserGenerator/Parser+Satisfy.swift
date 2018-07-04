//
//  Parser+Satisfy.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/28.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP


//satisfy :: (Stream s m Char) => (Char -> Bool) -> ParsecT s u m Char
//satisfy f           = tokenPrim (\c -> show [c])
//(\pos c _cs -> updatePosChar pos c)
//(\c -> if f c then Just c else Nothing)

public func satisfy<S,U>(_ test: @escaping (Character) -> Bool)
  -> Parser<S, U, Character> where S: ParserStream, S.Element == Character {
    
    func showToken(_ c: Character) -> String {
      return "\(c)"
    }
    func nextPos(_ pos: SourcePos, _ c: Character, _ s: S) -> SourcePos {
      return pos.update(PosBy: c)
    }
    
    return tokenPrim(showToken: showToken,
                     nextPos: curry(nextPos),
                     test: { (test($0) ? $0 : nil) })
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
      let newState = ParserState(stateInput: input.tail(),
                                 statePos: newPos,
                                 stateUser: $0.stateUser)
      return ParserResult<Reply<S, U, A>>
        .consumed(Reply<S, U, A>
          .ok(first, newState, ParserError(newErrorWith: Message.message(""), pos: pos)))
    }
}




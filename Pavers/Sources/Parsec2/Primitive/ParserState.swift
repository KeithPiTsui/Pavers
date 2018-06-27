//
//  ParserState.swift
//  PaversParsec2
//
//  Created by Keith on 2018/6/26.
//  Copyright © 2018 Keith. All rights reserved.
//

//public struct ParserState {
//  public let content: String
//  public let position: Int
//}
//
//extension ParserState: ExpressibleByStringLiteral {
//  public init(stringLiteral value: String) {
//    self.content = value
//    self.position = 0
//  }
//}


public struct ParserState<S, U> {
  public let stateInput: S
  public let statePos: SourcePos
  public let stateUser: U
}

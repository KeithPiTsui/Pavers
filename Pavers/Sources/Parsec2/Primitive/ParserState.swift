//
//  ParserState.swift
//  PaversParsec2
//
//  Created by Keith on 2018/6/26.
//  Copyright © 2018 Keith. All rights reserved.
//

public struct ParserState {
  let content: String
  let position: Int
}

extension ParserState: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.content = value
    self.position = 0
  }
}

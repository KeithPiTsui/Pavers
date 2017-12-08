//
//  ParserResult.swift
//  PaversParsec
//
//  Created by Keith on 08/12/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

public struct ParserResult<Result> {
  public let result: Result
  public let source: String
  public let inputCursor: Int
  public let outputCursor: Int
}

extension ParserResult {
  public var remainder: ParserInput {
    return ParserInput.init(source: self.source, cursor: self.outputCursor)
  }
}

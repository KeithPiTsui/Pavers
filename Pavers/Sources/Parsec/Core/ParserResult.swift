//
//  ParserResult.swift
//  PaversParsec
//
//  Created by Keith on 08/12/2017.
//  Copyright © 2017 Keith. All rights reserved.
//
import PaversFRP

public struct ParserResult<Source: Collection, Result> {
  public let result: Result
  public let source: Source
  public let inputCursor: Source.Index
  public let outputCursor: Source.Index
}

extension ParserResult {
  public var remainder: ParserInput<Source> {
    return ParserInput.init(source: self.source, cursor: self.outputCursor)
  }
}

extension ParserResult {
  public func map<A>(_ f: (Result) -> A ) -> ParserResult<Source, A> {
    return ParserResult<Source, A>.init(result: f(self.result),
                                source: self.source,
                                inputCursor: self.inputCursor,
                                outputCursor: self.outputCursor)
  }
}


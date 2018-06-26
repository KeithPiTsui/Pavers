//
//  Parser.swift
//  PaversParsec2
//
//  Created by Keith on 2018/6/26.
//  Copyright © 2018 Keith. All rights reserved.
//

public struct Parser<A> {
  let parse: (ParserState) -> ParseResult<A>
}

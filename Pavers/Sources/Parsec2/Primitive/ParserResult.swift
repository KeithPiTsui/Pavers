//
//  ParserResult.swift
//  PaversParsec2
//
//  Created by Keith on 2018/6/26.
//  Copyright © 2018 Keith. All rights reserved.
//

public enum Reply<A> {
  case okay (A, ParserState, ParserMessage)
  case error (ParserMessage)
}

public enum ParseResult<A> {
  case consumed (Reply<A>)
  case empty (Reply<A>)
}

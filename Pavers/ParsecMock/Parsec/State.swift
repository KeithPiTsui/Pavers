//
//  State.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/27.
//  Copyright © 2018 Keith. All rights reserved.
//


public struct ParserState<S, U> {
  public let stateInput: S
  public let statePos: SourcePos
  public let stateUser: U
}

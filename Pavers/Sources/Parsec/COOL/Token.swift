//
//  Token.swift
//  PaversCOOL
//
//  Created by Keith on 11/12/2017.
//  Copyright © 2017 Keith. All rights reserved.
//


public enum Token {
  case identifier(symbolID: UInt)
  case `operator`
  case keyword(value: Keyword)
}

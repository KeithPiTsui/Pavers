//
//  File.swift
//  PaversParsec
//
//  Created by Keith on 08/12/2017.
//  Copyright © 2017 Keith. All rights reserved.
//


public struct ParserInput<Source: Collection> {
  public let source: Source
  public let cursor: Source.Index
}

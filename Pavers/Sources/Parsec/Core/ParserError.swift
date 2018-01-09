//
//  ParserError.swift
//  PaversParsec
//
//  Created by Keith on 08/12/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

public struct ParserError: Error {
  public let code: Int
  public let message: String
  
  public static let empty: ParserError = ParserError.init(code: -1, message: "It is an empty parser")
}

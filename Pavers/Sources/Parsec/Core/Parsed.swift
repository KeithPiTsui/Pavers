//
//  Parsed.swift
//  PaversParsec
//
//  Created by Keith on 08/12/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

public enum Parsed<Result> {
  case success(ParserResult<Result>)
  case failure(ParserError)
}

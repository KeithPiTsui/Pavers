//
//  Keywords.swift
//  PaversCOOL
//
//  Created by Keith on 11/12/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversFRP

public struct Keyword {
  public let name: String
  public let lexicalExpression: () -> Parser<String, String>
}

public let `if`: Keyword
  = Keyword(name: "if",
            lexicalExpression: string("if"))


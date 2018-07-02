//
//  Parser+String.swift
//  ParsecMock
//
//  Created by Keith on 2018/7/2.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public typealias ParserS<A> = Parser<String, (), A>


public func string<S, U>(_ s: S) -> Parser<S, U, String>
  where S: ParserStream, S.Element == Character {
    guard let c = s.first() else {return pure("")}
    return char(c) >>- { c in string(s.droppingFirst()) >>- { cs in pure([c] + cs) } }
}

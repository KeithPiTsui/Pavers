//
//  Parser+String.swift
//  ParsecMock
//
//  Created by Keith on 2018/7/2.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public typealias ParserS<A> = Parser<String, (), A>

public func string<S, U>(_ s: String) -> Parser<S, U, String>
  where S: ParserStream, S.Element == Character {
    return tokens({"\($0)"},
                  {pos in {cs in pos.update(PosBy: String(cs))}},
                  s.chars)
      .fmap{String($0)}
}

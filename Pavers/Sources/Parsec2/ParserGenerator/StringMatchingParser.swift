//
//  StringMatchingParser.swift
//  PaversParsec2
//
//  Created by Keith on 2018/6/26.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

//public func char(_ c: Character) -> Parser<Character> {
//  return satisfy(curry(==)(c))
//}
//
//public func string<S: StringProtocol>(_ s: S) -> Parser<String> {
//  guard let c = s.first else {return pure("")}
//  return char(c) >>- { c in string(s.dropFirst()) >>- { cs in pure([c] + cs) } }
//}

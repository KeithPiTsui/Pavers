//
//  CommonUseParsers.swift
//  PaversParsec2
//
//  Created by Keith on 2018/6/25.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public func >>- <A, B> (_ a: Parser<A>, _ b: Parser<B>) -> Parser<B> {
  return a >>- {_ in b}
}


internal let char =
  {satisfy(curry(==)($0)) <?> "\($0)" }
internal let letter =
  satisfy(CharacterSet.alphanumerics.contains)
  <?> "letter"
internal let digit =
  satisfy(CharacterSet.decimalDigits.contains)
  <?> "digit"
internal let whitespace = satisfy(CharacterSet.whitespacesAndNewlines.contains)
internal let whitespaces = many1(whitespace)


internal func string<S: StringProtocol>(_ s: S) -> Parser<()> {
  guard let c = s.first else {return pure(())}
  return char(c) >>- { _ in string(s.dropFirst()) }
}


internal let identifier =
  many1(letter <|> digit <|> char("_"))
  <?> "identifier"

internal let letExpr = string("let_expression")

internal let expr = (string("let") >>- whitespaces >>- letExpr) <|> (identifier >>- letExpr)

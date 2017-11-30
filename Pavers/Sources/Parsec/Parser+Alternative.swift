import PaversFRP

extension Parser {
  public func or(_ other: Parser<Result>) -> Parser<Result> {
    return Parser<Result> { input in
      return self.run(input) ?? other.run(input)
    }
  }
}

public func <|> <A> (lhs: Parser<A>, rhs: Parser<A
  >) -> Parser<A> {
  return lhs.or(rhs)
}

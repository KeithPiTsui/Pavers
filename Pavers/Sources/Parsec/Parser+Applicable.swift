import PaversFRP

extension Parser {
  
  public static func apply <A, B> (_ lhs: Parser<(A)->B>, _ rhs: Parser<A>) -> Parser<B> {
    return lhs <*> rhs
  }
}

public func <*> <A, B> (_ lhs: Parser<(A)->B>, _ rhs: Parser<A>) -> Parser<B> {
  return {f, x in f(x)} <^> (lhs >>> rhs)
}

public func *> <A, B> (lhs: Parser<A>, rhs: Parser<B>)
  -> Parser<B> {
  return (curry({_, y in y}) <^> lhs <*> rhs)!
}

public func <* <A, B> (lhs: Parser<A>, rhs: Parser<B>)
  -> Parser<A> {
    return (curry({x, _ in x}) <^> lhs <*> rhs)!
}


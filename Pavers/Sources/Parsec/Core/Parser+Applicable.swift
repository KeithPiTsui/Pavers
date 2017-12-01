import PaversFRP

public func <*> <A, B> (_ lhs: @escaping () -> Parser<(A)->B>,
                        _ rhs:@escaping () -> Parser<A>)
  -> () -> Parser<B> {
    return {f, x in f(x)} <^> (lhs >>> rhs)
}

public func *> <A, B> (lhs: @escaping () -> Parser<A>,
                       rhs: @escaping () -> Parser<B>)
  -> () -> Parser<B> {
    return (curry({_, y in y}) <^> lhs) <*> rhs
}

public func <* <A, B> (lhs: @escaping () -> Parser<A>,
                       rhs: @escaping () -> Parser<B>)
  -> () -> Parser<A> {
    return curry({x, _ in x}) <^> lhs <*> rhs
}


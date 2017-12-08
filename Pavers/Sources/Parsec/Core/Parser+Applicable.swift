import PaversFRP

/// Applicable
public func <*> <C, A, B> (_ lhs: @escaping () -> Parser<C, (A)->B>,
                        _ rhs:@escaping () -> Parser<C, A>)
  -> () -> Parser<C, B> {
    return {({f, x in f(x)} <^> (lhs >>> rhs))() }
}

public func *> <C, A, B> (lhs: @escaping () -> Parser<C, A>,
                       rhs: @escaping () -> Parser<C, B>)
  -> () -> Parser<C, B> {
    return {(curry({_, y in y}) <^> lhs <*> rhs) ()}
}

public func <* <C, A, B> (lhs: @escaping () -> Parser<C, A>,
                       rhs: @escaping () -> Parser<C, B>)
  -> () -> Parser<C, A> {
    return {(curry({x, _ in x}) <^> lhs <*> rhs)()}
}


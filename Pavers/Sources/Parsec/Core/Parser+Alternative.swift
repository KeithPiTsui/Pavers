import PaversFRP

public func .?? <A> (lhs: @escaping () -> Parser<A>, rhs: @escaping () -> Parser<A>)
 -> () -> Parser<A> {
  return {Parser<A> {
    switch lhs().run($0) {
    case .success(let result): return .success(result)
    case .failure(_): return rhs().run($0)
    }
    }
  }
}

public func .|. <A> (lhs: @escaping () -> Parser<A>, rhs: @escaping () -> Parser<A>)
  -> () -> Parser<A> {
    return lhs .?? rhs
}

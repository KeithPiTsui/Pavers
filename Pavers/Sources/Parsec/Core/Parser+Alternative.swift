import PaversFRP

public func .?? <C, A> (lhs: @escaping () -> Parser<C, A>, rhs: @escaping () -> Parser<C, A>)
 -> () -> Parser<C, A> {
  return {Parser<C, A> {
    switch lhs().run($0) {
    case .success(let result): return .success(result)
    case .failure(_): return rhs().run($0) }
    }
  }
}

public func .|. <C, A> (lhs: @escaping () -> Parser<C, A>, rhs: @escaping () -> Parser<C, A>)
  -> () -> Parser<C, A> {
    return lhs .?? rhs
}

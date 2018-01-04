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

public func .?? <C, A, B> (lhs: @escaping () -> Parser<C, A>,
                           rhs: @escaping () -> Parser<C, B>)
  -> () -> Parser<C, Any> {
    return {Parser<C, Any> {
      switch lhs().run($0) {
      case .success(let result):
        return .success(result.erase())
      case .failure(_):
        return rhs().run($0).map{$0.erase()}
      }
      }
    }
}

public func .|. <C, A> (lhs: @escaping () -> Parser<C, A>, rhs: @escaping () -> Parser<C, A>)
  -> () -> Parser<C, A> {
    return lhs .?? rhs
}

public func .|. <C, A, B> (lhs: @escaping () -> Parser<C, A>, rhs: @escaping () -> Parser<C, B>)
  -> () -> Parser<C, Any> {
    return lhs .?? rhs
}

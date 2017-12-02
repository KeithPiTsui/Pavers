import PaversFRP

public func >>> <A, B> (lhs: @escaping () -> Parser<A>,
                        rhs: @escaping () -> Parser<B>)
  -> () -> Parser<(A, B)> {
  return {
    Parser<(A, B)> {
      print("\(#function)\($0)")
      guard let (result, remainder) = lhs().run($0) else { return nil }
      print("\(#function)\((result, remainder))")
      guard let (resultA, remainderA) = rhs().run(remainder) else { return nil }
      print("\(#function)\((resultA, remainderA))")
      return ((result, resultA), remainderA)
    }
  }
}

public func <^> <A, B> (_ transform: @escaping (A) -> B,
                        _ rhs: @escaping () -> Parser<A>)
  -> () -> Parser<B> {
    return {
      Parser<B> {
        guard let (result, remainder) = rhs().run($0) else { return nil }
        return (transform(result), remainder)
      }
    }
}

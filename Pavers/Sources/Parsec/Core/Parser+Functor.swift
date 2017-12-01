import PaversFRP

extension Parser {
  func map <T> (_ transform: @escaping (Result) -> T)
    -> () -> Parser<T> {
      return {
        Parser<T> {
          guard let (result, remainder) = self.run($0) else { return nil }
          return (transform(result), remainder)
        }
      }
  }
}

public func >>> <A, B> (lhs: @escaping () -> Parser<A>, rhs: @escaping () -> Parser<B>) -> () -> Parser<(A, B)> {
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

public func <^> <A, B> (_ transform: @escaping (A) -> B, _ rhs: @escaping () -> Parser<A>)
  -> () -> Parser<B> {
    return {
      Parser<B> {
        guard let (result, remainder) = rhs().run($0) else { return nil }
        return (transform(result), remainder)
      }
    }
}

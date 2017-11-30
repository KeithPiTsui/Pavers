import PaversFRP

extension Parser {
  public func followed<A>(by other: Parser<A>) -> Parser<(Result, A)> {
    return Parser<(Result, A)> {  input in
      guard let (result, remainder) = self.run(input) else { return nil }
      guard let (resultA, remainderA) = other.run(remainder) else { return nil }
      return ((result, resultA), remainderA)
    }
  }
}
public func >>> <A, B> (lhs: Parser<A>, rhs: Parser<B>) -> Parser<(A, B)> {
  return lhs.followed(by: rhs)
}

extension Parser {
  
  /// The reason why don't use optional T in transform closure
  /// is because a new parser does base on the correct result passed from the prerequisite parser.
  /// In other words, if the input stream hasn't fulfill the requirements of parser,
  /// it will be discover in the prerequisite parse.
  /// T must not be optional
  public func map<T>(_ transform: @escaping (Result) -> T )
    -> Parser<T> {
      return Parser<T> { input in
        guard let (result, remainder) = self.run(input) else { return nil }
        return (transform(result), remainder)
      }
  }
  
  public static func lift <A, B> (_ lhs: @escaping (A) -> B, _ rhs: Parser<A>)
    -> Parser<B> {
      return rhs.map(lhs)
  }
}

public func <^> <A, B> (_ lhs: @escaping (A) -> B, _ rhs: Parser<A>)
  -> Parser<B> {
    return rhs.map(lhs)
}

import PaversFRP

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

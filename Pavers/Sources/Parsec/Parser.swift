public struct Parser<Result> {
  public typealias Stream = String
  internal let parse: (Stream) -> (Result, Stream)?
}

extension Parser {
  /// parse input character, then return some resulting value
  /// and the remaining input string.
  /// Or if the input character is not matching the requirements of the parser,
  /// then it will return nil to signal an error occured.
  public func run(_ string: String) -> (Result, String)? {
  guard let (result, remainder) = parse(string) else { return nil }
  return (result, remainder)
  }
}

extension Parser {
  /// a parser which will match input string in specific times
  public func times(_ c: Int) -> Parser<[Result]> {
    return Parser<[Result]> { input in
      var result: [Result] = []
      var remainder = input
      var successes = 0
      while let (element, newRemainder) = self.run(remainder),
        successes < c {
        result.append(element)
        remainder = newRemainder
        successes += 1
      }
      guard successes == c else { return nil }
      return (result, remainder)
    }
  }
  
  /// a parser which will match input string in zero or one or more than one times.
  public var zeroOrMany: Parser<[Result]> {
    return Parser<[Result]> { input in
      var result: [Result] = []
      var remainder = input
      while let (element, newRemainder) = self.run(remainder) {
        result.append(element)
        remainder = newRemainder
      }
      return (result, remainder)
    }
  }
  
  /// a parser which will match input string in one or more than one times.
  public var many: Parser<[Result]> {
    return Parser<[Result]> { input in
      guard let (result, remainder) = self.zeroOrMany.run(input),
        result.isEmpty == false else { return nil }
      return (result, remainder)
    }
  }
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
}

extension Parser {
  public func followed<A>(by other: Parser<A>) -> Parser<(Result, A)> {
    return Parser<(Result, A)> {  input in
      guard let (result, remainder) = self.run(input) else { return nil }
      guard let (resultA, remainderA) = other.run(remainder) else { return nil }
      return ((result, resultA), remainderA)
    }
  }
}


public func curry<A, B, C>(_ f: @escaping (A, B) -> C)
  -> (A) -> (B) -> C {
    return { a in
      return { b in
        f(a, b)
      }
    }
}

public func curry<A, B, C, D>(_ f: @escaping (A, B, C) -> D)
  -> (A) -> (B) -> (C) -> D {
    return { a in
      return { b in
        return { c in
          f(a, b, c)
        }
      }
    }
}
















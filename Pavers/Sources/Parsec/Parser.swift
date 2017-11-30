import PaversFRP

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
    return curry({x, manyx in [x] + manyx}) <^> self <*> self.zeroOrMany
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
public func >>> <A, B> (lhs: Parser<A>, rhs: Parser<B>) -> Parser<(A, B)> {
  return lhs.followed(by: rhs)
}

















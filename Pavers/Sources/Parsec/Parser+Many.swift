import PaversFRP
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
    return curry({[$0] + $1}) <^> self <*> self.zeroOrMany
  }
}
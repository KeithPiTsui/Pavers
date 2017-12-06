import PaversFRP

extension Parser {
  /// a parser which will match input string in specific times
    public static func times(_ c: Int, of parser: @escaping () -> Parser<Result>)
        -> () -> Parser<[Result]> {
    return {Parser<[Result]> { input in
      var result: [Result] = []
      var remainder = input
      var successes = 0
      while let (element, newRemainder) = parser().run(remainder),
        successes < c {
          result.append(element)
          remainder = newRemainder
          successes += 1
      }
      guard successes == c else { return nil }
      return (result, remainder)
      }
    }
  }
}



/// a parser which will match input string in zero or one or more than one times.
postfix func .* <A> (_ a: @escaping () -> Parser<A>)
  -> () -> Parser<[A]> {
    return {Parser<[A]> {
      var result: [A] = []
      var remainder = $0
      while let (element, newRemainder) = a().run(remainder) {
        result.append(element)
        remainder = newRemainder
      }
      return (result, remainder)
      }
    }
}


/// a parser which will match input string in one or more than one times.
postfix func .+ <A> (_ a: @escaping () -> Parser<A>)
  -> () -> Parser<[A]> {
    return {(curry({[$0] + $1}) <^> a <*> a.*)()}
}







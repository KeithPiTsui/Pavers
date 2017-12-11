import PaversFRP

extension Parser {
  /// a parser which will match input string in specific times
    public func times(_ c: Int)
        -> () -> Parser<Source, [Value]> {
    return self.times(c, c)
  }
  
  public func times(_ min: Int, _ max: Int)
    -> () -> Parser<Source, [Value]> {
      return {Parser<Source, [Value]> { input in
        var result: [Value] = []
        var remainder = input
        var outputCursor = input.cursor
        var counter = 0
        while case let .success(element)  = self.run(remainder) {
          counter += 1
          outputCursor = element.outputCursor
          result.append(element.result)
          remainder = ParserInput.init(source: element.source, cursor: element.outputCursor)
        }
        if counter >= min && counter <= max {
          return .success(ParserResult<Source, [Value]>.init(result: result,
                                                             source: input.source,
                                                             inputCursor: input.cursor,
                                                             outputCursor: outputCursor))}
        else {
          return .failure(ParserError.init(code: 0, message: ""))
        }
        }
      }
  }
}



/// a parser which will match input string in zero or one or more than one times.
postfix func .* <C, A> (_ a: @escaping () -> Parser<C, A>)
  -> () -> Parser<C, [A]> {
    return {Parser<C, [A]> {
      var result: [A] = []
      var remainder = $0
      var outputCursor = $0.cursor
      while case let .success(element)  = a().run(remainder) {
        outputCursor = element.outputCursor
        result.append(element.result)
        remainder = ParserInput.init(source: element.source, cursor: element.outputCursor)
      }
      return .success(ParserResult<C, [A]>.init(result: result,
                                           source: $0.source,
                                           inputCursor: $0.cursor,
                                           outputCursor: outputCursor))
      }
    }
}


/// a parser which will match input string in one or more than one times.
postfix func .+ <C, A> (_ a: @escaping () -> Parser<C, A>)
  -> () -> Parser<C, [A]> {
    return {(curry({[$0] + $1}) <^> a <*> a.*)()}
}







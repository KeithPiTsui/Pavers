import PaversFRP

extension Parser {
  
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
  
  public func times(_ c: Int)
    -> () -> Parser<Source, [Value]> {
      return self.times(c, c)
  }
}



/// a parser which will match input string in zero or one or more than one times.
postfix func .* <C, A> (_ a: @escaping () -> Parser<C, A>)
  -> () -> Parser<C, [A]> {
    return a().times(0, Int.max)
}


/// a parser which will match input string in one or more than one times.
postfix func .+ <C, A> (_ a: @escaping () -> Parser<C, A>)
  -> () -> Parser<C, [A]> {
    return {(curry({[$0] + $1}) <^> a <*> a.*)()}
}







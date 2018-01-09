import PaversFRP

public struct Parser<Source: Collection, Value> {
  public let parse: (ParserInput<Source>) -> Result<ParserResult<Source, Value>, ParserError>
}

extension Parser {
  public func run(_ input: ParserInput<Source>) -> Result<ParserResult<Source, Value>, ParserError> {
    return self.parse(input)
  }
}

extension Parser where Value : Monoid {
  public static func null() -> Parser<Source, Value> {
    return Parser<Source, Value>(parse: { (input) in
      return .success(ParserResult<Source, Value>.init(result: Value.identity(),
                                                       source: input.source,
                                                       inputCursor: input.cursor,
                                                       outputCursor: input.cursor))
      
    })
  }
}

extension Parser {
  public static func empty() -> Parser<Source, Value> {
    return Parser<Source, Value>(parse: { (input) in
      return .failure(ParserError.empty)
    })
  }
}

extension Parser where Value == () {
  public func unit() -> Parser<Source, Value> {
    return Parser<Source, Value>(parse: { (input) in
      return .success(ParserResult<Source, Value>.init(result: (),
                                                    source: input.source,
                                                    inputCursor: input.cursor,
                                                    outputCursor: input.cursor))
    })
  }
}














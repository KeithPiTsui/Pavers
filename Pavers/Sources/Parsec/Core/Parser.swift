import PaversFRP

public struct Parser<Source: Collection, Value> {
  public let parse: (ParserInput<Source>) -> Result<ParserResult<Source, Value>, ParserError>
}

extension Parser {
  public func run(_ input: ParserInput<Source>) -> Result<ParserResult<Source, Value>, ParserError> {
    return self.parse(input)
  }
}

















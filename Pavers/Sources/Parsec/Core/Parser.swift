import PaversFRP

public struct Parser<Value> {
  public let parse: (ParserInput) -> Result<ParserResult<Value>, ParserError>
}

extension Parser {
  public func run(_ input: ParserInput) -> Result<ParserResult<Value>, ParserError> {
    return self.parse(input)
  }
}

















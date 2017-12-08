import PaversFRP

public struct Parser<Result> {
  public let parse: (ParserInput) -> Parsed<Result>
}

extension Parser {
  public func run(_ input: ParserInput) -> Parsed<Result> {
    return self.parse(input)
  }
}























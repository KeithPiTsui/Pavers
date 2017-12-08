import PaversFRP

public struct Parser<Result> {
//  public typealias Stream = String
//  internal let parse: (Stream) -> (Result, Stream)?
  public let parse: (ParserInput) -> Parsed<Result>
}

extension Parser {
  /// parse input character, then return some resulting value
  /// and the remaining input string.
  /// Or if the input character is not matching the requirements of the parser,
  /// then it will return nil to signal an error occured.
  public func run(_ input: ParserInput) -> Parsed<Result> {
    return self.parse(input)
    
//  guard let (result, remainder) = parse(string) else { return nil }
//  return (result, remainder)
  }
}

public struct ParserInput {
  public let source: String
  public let cursor: Int
}

public struct ParserError: Error {
  public let code: Int
  public let message: String
}

public struct ParserResult<Result> {
  public let result: Result
  public let source: String
  public let inputCursor: Int
  public let outputCursor: Int
}

extension ParserResult {
  public var remainder: ParserInput {
    return ParserInput.init(source: self.source, cursor: self.outputCursor)
  }
}


public enum Parsed<Result> {
  case success(ParserResult<Result>)
  case failure(ParserError)
}















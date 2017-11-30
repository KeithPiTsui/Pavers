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

















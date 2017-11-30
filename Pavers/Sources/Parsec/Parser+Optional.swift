extension Parser {
  public var optional: Parser<Result?> {
    return Parser<Result?> { input in
      guard let (result, remainder) = self.run(input) else {return (nil, input)}
      return  (result, remainder)
    }
  }
}

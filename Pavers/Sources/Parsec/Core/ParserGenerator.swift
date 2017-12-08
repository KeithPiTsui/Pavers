
public func character(_ matching: @escaping (Character) -> Bool)
  -> () -> Parser<Character> {
    return { Parser<Character>(parse: { (input) in
      
      let start = input.source.startIndex
      let location = input.source.index(start, offsetBy: input.cursor)
      guard location < input.source.endIndex
        && location >= input.source.startIndex
        else {
          return .failure(ParserError.init(code: 0, message: ""))
      }
      let char = input.source[location]
      guard matching(char) else {
        return .failure(ParserError.init(code: 0, message: ""))
      }
      return .success(ParserResult<Character>.init(result: char,
                                                   source: input.source,
                                                   inputCursor: input.cursor,
                                                   outputCursor: input.source.index(after: location).encodedOffset))
      
    })
    }
}

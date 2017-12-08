
public func character(_ matching: @escaping (Character) -> Bool)
  -> () -> Parser<String, Character> {
    return { Parser<String, Character>(parse: { (input) in
      
      let location = input.cursor
      guard location < input.source.endIndex
        && location >= input.source.startIndex
        else {
          return .failure(ParserError.init(code: 0, message: ""))
      }
      let char = input.source[location]
      guard matching(char) else {
        return .failure(ParserError.init(code: 0, message: ""))
      }
      return .success(ParserResult<String, Character>.init(result: char,
                                                   source: input.source,
                                                   inputCursor: input.cursor,
                                                   outputCursor: input.source.index(after: location)))
      
    })
    }
}

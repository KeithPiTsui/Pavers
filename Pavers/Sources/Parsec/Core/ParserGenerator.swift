
import PaversFRP

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

public func string(_ matching: String)
  -> () -> Parser<String, String> {
    
    let f: (Character) -> () -> Parser<String, [Character]>
      = { c in {Array.init(arrayLiteral: $0)} <^> character{$0 == c}}
    return {String.init($0)}
      <^> matching
        .map(f)
        .reduce({Parser<String, [Character]>.null()}, >>>)
}


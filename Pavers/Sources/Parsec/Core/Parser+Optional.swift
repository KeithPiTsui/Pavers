import PaversFRP

postfix func .? <A> (_ a: @escaping () -> Parser<A>)
  -> () -> Parser<A?> {
    return {Parser<A?> {
      
      guard case .success(let result) = a().run($0)
        else {return .success(ParserResult<A?>.init(result: nil,
                                                    source: $0.source,
                                                    inputCursor: $0.cursor,
                                                    outputCursor: $0.cursor))}
      return .success(ParserResult<A?>.init(result: result.result,
                                            source: $0.source,
                                            inputCursor: $0.cursor,
                                            outputCursor: result.outputCursor))
      }
    }
}

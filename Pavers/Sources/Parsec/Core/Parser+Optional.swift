import PaversFRP

postfix func .? <C, A> (_ a: @escaping () -> Parser<C, A>)
  -> () -> Parser<C, A?> {
    return {Parser<C, A?> {
      
      guard case .success(let result) = a().run($0)
        else {return .success(ParserResult<C, A?>.init(result: nil,
                                                    source: $0.source,
                                                    inputCursor: $0.cursor,
                                                    outputCursor: $0.cursor))}
      return .success(ParserResult<C, A?>.init(result: result.result,
                                            source: $0.source,
                                            inputCursor: $0.cursor,
                                            outputCursor: result.outputCursor))
      }
    }
}

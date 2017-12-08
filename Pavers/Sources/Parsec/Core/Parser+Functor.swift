import PaversFRP

public func >>> <A, B> (lhs: @escaping () -> Parser<A>,
                        rhs: @escaping () -> Parser<B>)
  -> () -> Parser<(A, B)> {
  return {
    Parser<(A, B)> {
      guard case .success(let resultA) = lhs().run($0)
        else {return .failure(ParserError.init(code: 0, message: ""))}
      guard case .success(let resultB) = rhs().run(resultA.remainder)
        else {return .failure(ParserError.init(code: 0, message: ""))}
      return .success(ParserResult<(A, B)>.init(result: (resultA.result, resultB.result),
                                                source: $0.source,
                                                inputCursor: $0.cursor,
                                                outputCursor: resultB.outputCursor))
    }
  }
}

public func <^> <A, B> (_ transform: @escaping (A) -> B,
                        _ rhs: @escaping () -> Parser<A>)
  -> () -> Parser<B> {
    return {
      Parser<B> {
        guard case .success(let result) = rhs().run($0)
          else {return .failure(ParserError.init(code: 0, message: ""))}
        return .success(result.map(transform))
      }
    }
}

import PaversFRP

public func >>> <C, A, B> (lhs: @escaping () -> Parser<C, A>,
                        rhs: @escaping () -> Parser<C, B>)
  -> () -> Parser<C, (A, B)> {
  return {
    Parser<C, (A, B)> {
      guard case .success(let resultA) = lhs().run($0)
        else {return .failure(ParserError.init(code: 0, message: ""))}
      guard case .success(let resultB) = rhs().run(resultA.remainder)
        else {return .failure(ParserError.init(code: 0, message: ""))}
      return .success(ParserResult<C, (A, B)>.init(result: (resultA.result, resultB.result),
                                                source: $0.source,
                                                inputCursor: $0.cursor,
                                                outputCursor: resultB.outputCursor))
    }
  }
}

public func >>> <C, A> (lhs: @escaping () -> Parser<C, A>,
                           rhs: @escaping () -> Parser<C, A>)
  -> () -> Parser<C, [A]> {
    return {
      Parser<C, [A]> {
        guard case .success(let resultA) = lhs().run($0)
          else {return .failure(ParserError.init(code: 0, message: ""))}
        guard case .success(let resultB) = rhs().run(resultA.remainder)
          else {return .failure(ParserError.init(code: 0, message: ""))}
        return .success(ParserResult<C, [A]>.init(result: [resultA.result, resultB.result],
                                                     source: $0.source,
                                                     inputCursor: $0.cursor,
                                                     outputCursor: resultB.outputCursor))
      }
    }
}

public func >>> <C, A> (lhs: @escaping () -> Parser<C, [A]>,
                        rhs: @escaping () -> Parser<C, [A]>)
  -> () -> Parser<C, [A]> {
    return {
      Parser<C, [A]> {
        guard case .success(let resultA) = lhs().run($0)
          else {return .failure(ParserError.init(code: 0, message: ""))}
        guard case .success(let resultB) = rhs().run(resultA.remainder)
          else {return .failure(ParserError.init(code: 0, message: ""))}
        return .success(ParserResult<C, [A]>.init(result: resultA.result + resultB.result,
                                                  source: $0.source,
                                                  inputCursor: $0.cursor,
                                                  outputCursor: resultB.outputCursor))
      }
    }
}

public func <^> <C, A, B> (_ transform: @escaping (A) -> B,
                        _ rhs: @escaping () -> Parser<C, A>)
  -> () -> Parser<C, B> {
    return {
      Parser<C, B> {
        guard case .success(let result) = rhs().run($0)
          else {return .failure(ParserError.init(code: 0, message: ""))}
        return .success(result.map(transform))
      }
    }
}

extension Parser {
  public var optional: () -> Parser<Result?> {
    return {Parser<Result?> { input in
      guard let (result, remainder) = self.run(input) else {return (nil, input)}
      return  (result, remainder)
      }
    }
  }
}

postfix operator .?

postfix func .? <A> (_ a: @escaping () -> Parser<A>)
  -> () -> Parser<A?> {
    return {Parser<A?> { input in
      guard let (result, remainder) = a().run(input) else {return (nil, input)}
      return  (result, remainder)
      }
    }
}

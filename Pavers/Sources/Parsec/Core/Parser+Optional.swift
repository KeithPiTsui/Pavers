import PaversFRP

postfix func .? <A> (_ a: @escaping () -> Parser<A>)
  -> () -> Parser<A?> {
    return {Parser<A?> { input in
      guard let (result, remainder) = a().run(input) else {return (nil, input)}
      return  (result, remainder)
      }
    }
}

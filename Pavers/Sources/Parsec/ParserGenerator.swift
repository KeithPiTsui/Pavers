public func character(matching condition: @escaping (Character) -> Bool)
  -> Parser<Character> {
    return Parser<Character>(parse: { (input) in
      guard let char = input.first, condition(char) else { return nil}
      return (char, String(input.dropFirst()))
    })
}

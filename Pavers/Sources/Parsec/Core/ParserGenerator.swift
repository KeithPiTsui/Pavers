public func character(_ matching: @escaping (Character) -> Bool)
    -> () -> Parser<Character> {
        return { Parser<Character>(parse: { (input) in
            guard let char = input.first, matching(char) else { return nil}
            return (char, String(input.dropFirst()))
        })
        }
}

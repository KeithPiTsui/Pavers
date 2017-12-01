extension CharacterSet {
  public func contains(_ c: Character) -> Bool {
    guard let scalar = c.unicodeScalars.first else { return false}
    return contains(scalar)
  }
}

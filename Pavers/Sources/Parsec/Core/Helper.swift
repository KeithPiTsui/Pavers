extension CharacterSet {
  public func contains(_ c: Character) -> Bool {
    let cs = CharacterSet.init(charactersIn: "\(c)")
    return self.isSuperset(of: cs)
  }
}

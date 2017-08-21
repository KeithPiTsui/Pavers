/// A `NumericType` instance is something that acts numeric-like, i.e. can be added, subtracted
/// and multiplied with other numeric types.
public protocol NumericType {
  static func + (lhs: Self, rhs: Self) -> Self
  static func - (lhs: Self, rhs: Self) -> Self
  static func * (lhs: Self, rhs: Self) -> Self
  func negate() -> Self
  static func zero() -> Self
  static func one() -> Self
  init(_ v: Int)
}

extension NumericType {
  public func negate() -> Self {
    return Self.zero() - self
  }
}

extension NumericType where Self: Comparable {
  public func abs() -> Self {
    if self < Self.zero() {
      return self.negate()
    }
    return self
  }
}

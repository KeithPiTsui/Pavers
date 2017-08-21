extension CGFloat : VectorType {
  public typealias Scalar = CGFloat

  public func scale(_ c: CGFloat) -> CGFloat {
    return self * c
  }

  public func add(_ v: CGFloat) -> CGFloat {
    return self + v
  }
}

extension CGPoint : VectorType {
  public typealias Scalar = CGFloat

  public func scale(_ c: CGFloat) -> CGPoint {
    return CGPoint(x: self.x * c, y: self.y * c)
  }

  public func add(_ v: CGPoint) -> CGPoint {
    return CGPoint(x: self.x + v.x, y: self.y + v.y)
  }

  public static func zero() -> CGPoint {
    return CGPoint.zero
  }
}

extension CGRect : VectorType {
  public typealias Scalar = CGFloat

  public func scale(_ c: Scalar) -> CGRect {
    return CGRect(
      x: self.origin.x * c,
      y: self.origin.y * c,
      width: self.size.width * c,
      height: self.size.height * c
    )
  }

  public func add(_ v: CGRect) -> CGRect {
    return CGRect(
      x: self.origin.x + v.origin.x,
      y: self.origin.y + v.origin.y,
      width: self.size.width + v.size.width,
      height: self.size.height + v.size.height
    )
  }

  public static func zero() -> CGRect {
    return CGRect.zero
  }
}

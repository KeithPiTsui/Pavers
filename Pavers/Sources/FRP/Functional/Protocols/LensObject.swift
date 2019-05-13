public protocol LensObject {}

public extension LensObject {
  static var lens: LensHolder<Self> {
    return LensHolder()
  }
}

import UIKit

public protocol UIDeviceType {
  var identifierForVendor: UUID? { get }
  var modelCode: String { get }
  var systemName: String { get }
  var systemVersion: String { get }
  var userInterfaceIdiom: UIUserInterfaceIdiom { get }
}

extension UIDevice: UIDeviceType {
  public var modelCode: String {
    var size: Int = 0
    sysctlbyname("hw.machine", nil, &size, nil, 0)
    var machine = [CChar](repeating: 0, count: size)
    sysctlbyname("hw.machine", &machine, &size, nil, 0)
    return String(cString: machine)
  }
}

public extension UIDevice {
  static let isPhone = UIDevice().userInterfaceIdiom == .phone
  static let isPad = UIDevice().userInterfaceIdiom == .pad
  static let isSimulator = Simulator.isRunning
}

#if os(OSX)
  import Cocoa
#else
  import UIKit
#endif

public protocol NSBundleType {
  static func create(path: String) -> NSBundleType?
  var infoDictionary: [String : Any]? { get }
  var bundleIdentifier: String? { get }
  func path(forResource name: String?, ofType ext: String?) -> String?
  func localizedString(forKey key: String, value: String?, table tableName: String?) -> String
}

extension NSBundleType {
  public func getString(_ keys: String ...) -> String {
    for key in keys {
      if let value = self.infoDictionary?[key] as? String {
        return value
      }
    }
    return "Unknown"
  }
  
  public var identifier: String {
    return self.getString("CFBundleIdentifier")
  }
  
  public var name: String {
    return self.getString("CFBundleDisplayName", "CFBundleName")
  }
  
  public var shortVersionString: String {
    return self.getString("CFBundleShortVersionString")
  }
  
  public var version: String {
    return self.getString("CFBundleVersion")
  }
  
  public var build: String {
    return self.getString("CFBundleVersion")
  }
  
  public var executable: String {
    return self.getString("CFBundleExecutable")
  }
  
  public var schemes: [String] {
    guard let urlTypes = self.infoDictionary?["CFBundleURLTypes"] as? [AnyObject],
      let urlType = urlTypes.first as? [String : AnyObject],
      let urlSchemes = urlType["CFBundleURLSchemes"] as? [String]
      else { return [] }
    
    return urlSchemes
  }
  
  public var mainScheme: String? {
    return self.schemes.first
  }
}

extension Bundle: NSBundleType {
  public static func create(path: String) -> NSBundleType? {
    return Bundle(path: path)
  }
}


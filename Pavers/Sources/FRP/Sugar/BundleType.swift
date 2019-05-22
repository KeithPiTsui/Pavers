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
  public func get<Type>(_ keys: [String]) -> Type? {
    for key in keys {
      if let value = self.infoDictionary?[key] as? Type {
        return value
      }
    }
    return nil
  }
  
  public func get<Type> (_ keys: String ...) -> Type? {
    return self.get(keys)
  }
  
  public var identifier: String? {
    return self.get("CFBundleIdentifier")
  }
  
  public var name: String? {
    return self.get("CFBundleDisplayName", "CFBundleName")
  }
  
  public var shortVersionString: String? {
    return self.get("CFBundleShortVersionString")
  }
  
  public var version: String? {
    return self.get("CFBundleVersion")
  }
  
  public var build: String? {
    return self.get("CFBundleVersion")
  }
  
  public var executable: String? {
    return self.get("CFBundleExecutable")
  }
  
  public var urlTypes: [[String: AnyObject]]? {
    return self.infoDictionary?["CFBundleURLTypes"] as? [[String: AnyObject]]
  }
  
  public func urlType(named: String) -> [String: AnyObject]? {
    guard let urlType = self.urlTypes?.findFirst({ ($0["CFBundleURLName"] as? String) == named })
      else { return nil }
    return urlType
  }
  
  public var schemes: [String]? {
    guard let urlTypes = self.urlTypes,
      let urlType = urlTypes.first,
      let urlSchemes = urlType["CFBundleURLSchemes"] as? [String]
      else { return nil }
    
    return urlSchemes
  }
  
  public var mainScheme: String? {
    return self.schemes?.first
  }
}

extension Bundle: NSBundleType {
  public static func create(path: String) -> NSBundleType? {
    return Bundle(path: path)
  }
}


import PaversFRP

#if os(macOS)
import AppKit
public typealias ViewClass = NSView
#else
import UIKit
public typealias ViewClass = UIView
#endif

extension Reactive where Base: NSLayoutConstraint {

	/// Sets the constant.
	public var constant: BindingTarget<CGFloat> {
		return makeBindingTarget { $0.constant = $1 }
	}

}


extension NSLayoutConstraint {
  public convenience init(_ item: ViewClass,
                          _ attribute: NSLayoutAttribute,
                          relatedBy r: NSLayoutRelation = .equal,
                          toItem secondItem: ViewClass? = nil,
                          attribute secondAttribute: NSLayoutAttribute = .notAnAttribute,
                          multiplier m: CGFloat = 1,
                          constant c: CGFloat = 0) {
    self.init(item: item,
              attribute: attribute,
              relatedBy: r,
              toItem: secondItem,
              attribute: secondAttribute,
              multiplier: m,
              constant: c)
  }
}


extension NSLayoutConstraint {
  public func preconstraint(view: ViewClass) {
    view.translatesAutoresizingMaskIntoConstraints = false
  }

  public func preconstraint(views: [ViewClass]) {
    views.forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
  }

}

extension NSLayoutConstraint {
  public var fisrtView: ViewClass {
    return self.firstItem as! ViewClass
  }
  public var secondView: ViewClass? {
    return self.secondItem.flatMap { $0 as? ViewClass }
  }

  public var isUnary: Bool {
    return self.secondItem == nil
  }
}

extension NSLayoutConstraint {
  public var stringValue: String {

    let fstViewName = self.fisrtView.description
    let fstAttr = self.firstAttribute.stringValue
    let fstStr = "\(fstViewName).\(fstAttr)"

    let relStr = self.relation.stringValue

    guard let sndView = self.secondView else { return "\(fstStr) \(relStr) \(self.constant)" }

    let sndViewName = sndView.description
    let sndAttr = self.secondAttribute
    let sndStr = "\(sndViewName).\(sndAttr)"

    let rhsVariablePart = self.multiplier == 1
      ? sndStr
      : "\(sndStr) * \(self.multiplier)"

    let constantString = "\(self.constant.sign) \(self.constant.abs())"

    let rhs = self.constant == 0 ? rhsVariablePart : "\(rhsVariablePart) \(constantString)"

    return "\(fstStr) \(relStr) \(rhs)"
  }
}



extension NSLayoutAttribute {
  public var stringValue: String {
    return "\(self)"
  }
}

extension NSLayoutRelation {
  public var stringValue: String {
    switch self {
    case .lessThanOrEqual: return "<="
    case .equal: return "=="
    case .greaterThanOrEqual: return ">="
    }
  }
}


// MARK: - Name tag

extension NSObject {

  private static let nametagKey = AssociationKey<String>("nametag" as StaticString)

  public var nametag: String {
    get {
      return self.associations.value(forKey: NSObject.nametagKey)
    }
    set {
      self.associations.setValue(newValue, forKey: NSObject.nametagKey)
    }
  }

  public var objectIdentifier: String {
    var xxx = self
    return withUnsafePointer(to: &xxx) { "\(type(of: self).description):\($0)" }
  }
}

















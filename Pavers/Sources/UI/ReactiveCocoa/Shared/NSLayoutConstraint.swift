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
  public var equation: String {

    let fstViewName = self.fisrtView.objectID
    let fstAttr = self.firstAttribute.stringValue
    let fstStr = "\(fstViewName).\(fstAttr)"

    let relStr = self.relation.stringValue

    guard let sndView = self.secondView else { return "\(fstStr) \(relStr) \(self.constant)" }

    let sndViewName = sndView.objectID
    let sndAttr = self.secondAttribute.stringValue
    let sndStr = "\(sndViewName).\(sndAttr)"

    let rhsVariablePart = self.multiplier == 1
      ? sndStr
      : "\(sndStr) * \(self.multiplier)"

    let constantString = "\((self.constant.sign as NumericSign).symbol) \(self.constant.abs())"

    let rhs = self.constant == 0 ? rhsVariablePart : "\(rhsVariablePart) \(constantString)"

    return "\(fstStr) \(relStr) \(rhs)"
  }

  open override var description: String {
    let active = self.isActive ? "Active" : "Inactive"
    return "<\(self.objectID) \(self.equation) (\(active))>"
  }

}



extension NSLayoutAttribute {
  public var stringValue: String {
    switch self {
    case .left: return "left"
    case .right: return "right"
    case .top: return "top"
    case .bottom: return "bottom"
    case .leading: return "leading"
    case .trailing: return "trailing"
    case .width: return "width"
    case .height: return "height"
    case .centerX: return "centerX"
    case .centerY: return "centerY"
    case .lastBaseline: return "lastBaseline"
    case .firstBaseline: return "firstBaseline"
    case .leftMargin: return "leftMargin"
    case .rightMargin: return "rightMargin"
    case .topMargin: return "topMargin"
    case .bottomMargin: return "bottomMargin"
    case .leadingMargin: return "leadingMargin"
    case .trailingMargin: return "trailingMargin"
    case .centerXWithinMargins: return "centerXWithinMargins"
    case .centerYWithinMargins: return "centerYWithinMargins"
    case .notAnAttribute: return "notAnAttribute"
    }
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

  private static let nametagKey = "nametag" as StaticString

  public var nametag: String {
    get {
      let defaultName = type(of: self).description()
      let key = AssociationKey<String>(NSObject.nametagKey, default: defaultName)
      return self.associations.value(forKey: key)
    }
    set {
      self.associations.setValue(newValue, forKey: AssociationKey<String>(NSObject.nametagKey))
    }
  }

  public var memoryAddress: UInt {
    return unsafeBitCast(self, to: UInt.self)
  }

  public var memoryAddressStr: String {
    return String(format: "%p", self.memoryAddress)
  }

  public var objectID: String {
    return "\(self.nametag):\(self.memoryAddressStr)"
  }
}

















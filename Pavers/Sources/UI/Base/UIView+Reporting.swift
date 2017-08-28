//
//  UIView+Constraint.swift
//  Pavers
//
//  Created by Pi on 28/08/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import UIKit

extension UIView {
  public func constraints(named: String = NSLayoutConstraint.className, matching view: UIView) -> [NSLayoutConstraint] {
    return self.constraints.filter {
      $0.instanceName == named
        && ($0.firstItem === view || $0.secondItem === view)}
  }
}

// MARK: - Layout Report
extension UIView {

  public var layoutReport: String {
    var report = ""


    return report
  }

}

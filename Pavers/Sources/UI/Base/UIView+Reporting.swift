//
//  UIView+Constraint.swift
//  Pavers
//
//  Created by Pi on 28/08/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import UIKit
import PaversFRP

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

    // Specify view address, class, and superclass
    report += "<\(self.identification)> \(self.className): \(self.superclassName ?? "")\n"

    // Test for autoresizing and ambiguous layout
    if self.translatesAutoresizingMaskIntoConstraints {
      report += "[AutoResizing]\n"
    }
    if self.hasAmbiguousLayout {
      report += "[Caution: Ambiguous Layout!]\n"
    }

    // Show description for AutoResizing views
    if self.translatesAutoresizingMaskIntoConstraints && self.autoresizingMask != [] {
      report += "\(self.autoresizingMask)"
    }

    // Frame and Content Size
    report += "Frame: ....... \(self.frame)\n"
    report += "ContentSize .. \(self.intrinsicContentSize)\n"

    #if os(iOS)
      if self.intrinsicContentSize.width > 0 || self.intrinsicContentSize.height > 0 {
        report += "[Content Mode: \(self.contentMode)]\n"
      }
    #endif

    let hhLens = UIView.lens.contentHuggingPriorityForAxis(.horizontal).view
    let hvLens = UIView.lens.contentHuggingPriorityForAxis(.vertical).view
    let chLens = UIView.lens.contentCompressionResistancePriorityForAxis(.horizontal).view
    let cvLens = UIView.lens.contentCompressionResistancePriorityForAxis(.vertical).view

    let hhP = self |> hhLens
    let hvP = self |> hvLens
    let chP = self |> chLens
    let cvP = self |> cvLens
    // Content Hugging
    report += "Hugging .... [H \(hhP)] [V \(hvP)]\n"
    // Compression Resistance
    report += "Compression Resistance .... [H \(chP)] [V \(cvP)]\n"
    // Constraint listings
    for (idx, constraint) in self.constraints.enumerated() {
      let isLayoutConstraint = type(of: constraint) == NSLayoutConstraint.self

      // Numbering each constraint
      report += "\(idx + 1). "

      // Display priority only for layout constraints
      if isLayoutConstraint {
        report += "@\(constraint.priority) "
      }

      // Show constraint
      report += "\(constraint.description)"

      if !isLayoutConstraint {
        report += " (\(constraint.className))"
      }

      report += "\n"
      
    }

    return report
  }

}

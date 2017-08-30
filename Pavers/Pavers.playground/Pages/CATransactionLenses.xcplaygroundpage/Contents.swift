import PaversFRP
import PaversUI
import UIKit
import PlaygroundSupport

//let str = "Hello"
//
//let transactionConf =
//  CATransaction.classLens.animationDuration .~ 5
//  >>> CATransaction.classLens.value(forKey: "myName") .~ "Keith"


let view = UIView()
let c = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 12, constant: 21)
view.addConstraint(c)


print(view.layoutReport)

//let hhLens = UIView.lens.contentHuggingPriorityForAxis(.horizontal).view
//let hvLens = UIView.lens.contentHuggingPriorityForAxis(.vertical).view
//let chLens = UIView.lens.contentCompressionResistancePriorityForAxis(.horizontal).view
//let cvLens = UIView.lens.contentCompressionResistancePriorityForAxis(.vertical).view
//
//let hhP = view |> hhLens
























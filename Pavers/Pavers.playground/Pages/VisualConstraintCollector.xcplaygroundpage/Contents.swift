//: [Previous](@previous)

import PaversFRP
import PaversUI
import UIKit
import PlaygroundSupport




let sv = UIView()
let view = UIView()
sv.addSubview(view)
sv.instanceName = "superview"
view.instanceName = "subview"

let views = ["view": view]

let h = visualConstraintGenerator("H:|-[view(20)]-|")
let v = visualConstraintGenerator("V:|-[view(20)]-|")

let fcc = VisualConstraintCollector(views: ["view": view]) |> h >>> v

fcc.apply()

print(sv.layoutReport)
print(view.layoutReport)












//: [Next](@next)

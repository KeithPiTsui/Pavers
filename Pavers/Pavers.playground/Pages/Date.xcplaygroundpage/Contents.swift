//: [Previous](@previous)

import Foundation
import PaversFRP


let date = Date().addingTimeInterval(-TimeInterval.day * 2)
let format = "yyyyMMdd"
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = format
dateFormatter.string(from: date)


//: [Next](@next)

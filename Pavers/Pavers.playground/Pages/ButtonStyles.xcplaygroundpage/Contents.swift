//: Playground - noun: a place where people can play

import PaversFRP
import PaversUI
import UIKit
import PlaygroundSupport
import Foundation

let bgView = UIView() |> containerViewBackgroundStyle

// Set the device type and orientation.
let (parent, _)
  = playgroundControllers(device: .phone5_5inch,
                          orientation: .portrait)

//let btn1 = UIButton() |> baseButtonStyle
//  >>> UIButton.lens.title(forState: .normal) .~ "btn1"
//let btn2 = UIButton() |> blackButtonStyle
//  >>> UIButton.lens.title(forState: .normal) .~ "btn2"
//let btn3 = UIButton() |> borderButtonStyle
//  >>> UIButton.lens.title(forState: .normal) .~ "btn3"
//let btn4 = UIButton() |> greenBorderButtonStyle
//  >>> UIButton.lens.title(forState: .normal) .~ "btn4"
//let btn5 = UIButton() |> neutralButtonStyle
//  >>> UIButton.lens.title(forState: .normal) .~ "btn5"
//
//let btn6 = UIButton() |> greenButtonStyle
//  >>> UIButton.lens.title(forState: .normal) .~ "btn6"

let qwBtn = UIButton() |> orangeRedButtonStyle
  >>> UIButton.lens.title(forState: .normal) .~ "进入游戏"
  >>> roundedStyle(cornerRadius: 4)
  >>> UIButton.lens.frame.origin.x .~ 10
  >>> UIButton.lens.frame.origin.y .~ 10
  >>> UIButton.lens.frame.size.width .~ 259.5
  >>> UIButton.lens.frame.size.height .~ 31.5

//let btn7 = UIButton() |> lightNavyButtonStyle
//  >>> UIButton.lens.title(forState: .normal) .~ "btn7"
//let btn8 = UIButton() |> navyButtonStyle
//  >>> UIButton.lens.title(forState: .normal) .~ "btn8"
//let btn9 = UIButton() |> textOnlyButtonStyle
//  >>> UIButton.lens.title(forState: .normal) .~ "btn9"
//let btn10 = UIButton() |> whiteBorderButtonStyle
//  >>> UIButton.lens.title(forState: .normal) .~ "btn10"

//bgView.addSubview(btn1)
//bgView.addSubview(btn2)
//bgView.addSubview(btn3)
//bgView.addSubview(btn4)
//bgView.addSubview(btn5)
//bgView.addSubview(btn6)
bgView.addSubview(qwBtn)
//bgView.addSubview(btn7)
//bgView.addSubview(btn8)
//bgView.addSubview(btn9)
//bgView.addSubview(btn10)

//let views: [String: Any] = ["btn1": btn1,
//                            "btn2": btn2,
//                            "btn3": btn3,
//                            "btn4": btn4,
//                            "btn5": btn5,
//                            "btn6": btn6,
//                            "qwBtn": qwBtn,
//                            "btn7": btn7,
//                            "btn8": btn8,
//                            "btn9": btn9,
//                            "btn10": btn10]
//
//let v = visualConstraintGenerator(
//  "V:|-[btn1]-[btn2]-[btn3]-[btn4]-[btn5]-[btn6]-[qwBtn(==63)]-[btn7]-[btn8]-[btn9]-[btn10]",
//  [.alignAllLeading]
//)
//let h = visualConstraintGenerator("H:[qwBtn(==519)]")
//let cons = VisualConstraintCollector(views: views) |> v
//cons.apply()



// Render the screen.
let frame = parent.view.frame
bgView.frame = frame

PlaygroundPage.current.liveView = bgView



//: Playground - noun: a place where people can play

import Pavers
import PaversUI
import UIKit
import PlaygroundSupport

final class UIGradientView: UIView {

  var gradientLayer: CAGradientLayer {return self.layer as! CAGradientLayer}

  override class var layerClass: Swift.AnyClass {
    return CAGradientLayer.self
  }
}

protocol UIGradientViewProtocol: UIViewProtocol {
  var gradientLayer: CAGradientLayer { get }
}

extension UIGradientView: UIGradientViewProtocol {}

extension LensHolder where Object: UIGradientViewProtocol {
  var gradientLayer: Lens<Object, CAGradientLayer> {
    return Lens(
      view: { $0.gradientLayer },
      set: { $1 }
    )
  }
}

extension Lens where Whole: UIGradientViewProtocol, Part == CAGradientLayer {
  var colors: Lens<Whole, [Any]?> {
    return Whole.lens.gradientLayer>>>CAGradientLayer.lens.colors
  }

  var locations: Lens<Whole, [NSNumber]?> {
    return Whole.lens.gradientLayer >>> CAGradientLayer.lens.locations
  }

  var startPoint: Lens<Whole, CGPoint> {
    return Whole.lens.gradientLayer >>> CAGradientLayer.lens.startPoint
  }

  var endPoint: Lens<Whole, CGPoint> {
    return Whole.lens.gradientLayer >>> CAGradientLayer.lens.endPoint
  }
}


let colors = [UIColor.red.cgColor, UIColor.blue.cgColor, UIColor.yellow.cgColor]
let locations = [NSNumber(value: 0),NSNumber(value: 0.25),NSNumber(value: 0.5)]
let sp = CGPoint(x: 0, y: 0)
let ep = CGPoint(x: 1, y: 1)

let gView = UIGradientView()

let gViewStyle =
   UIGradientView.lens.gradientLayer.colors .~ colors
  >>> UIGradientView.lens.gradientLayer.locations .~ locations
  >>> UIGradientView.lens.gradientLayer.startPoint .~ sp
  >>> UIGradientView.lens.gradientLayer.endPoint .~ ep
  >>> UIGradientView.lens.frame .~ CGRect(x: 0, y: 0, width: 200, height: 200)

gView |> gViewStyle

PlaygroundPage.current.liveView = gView

















//: Playground - noun: a place where people can play

import Pavers
import PaversUI
import UIKit
import PlaygroundSupport
import Foundation

final class UIGradientView: UIView {

  var gradientLayer: CAGradientLayer {return self.layer as! CAGradientLayer}

  override class var layerClass: Swift.AnyClass {
    return CAGradientLayer.self
  }

  override func action(for layer: CALayer, forKey event: String) -> CAAction? {
    if event == "colors" {
      print("Hit colors")
      if let acts = layer.actions, let act = acts[event]  {
        print("Hit colors with act in actions")
        return act
      }
      if let style = layer.style, let act = style[event] {
        print("Hit colors with act in style")
        return act as? CAAction
      }
      return CAGradientLayer.defaultAction(forKey:event)
    }
    return super.action(for: layer, forKey: event)
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



let colors = [UIColor.random.cgColor, UIColor.random.cgColor, UIColor.random.cgColor]
let locations = [NSNumber(value: 0),NSNumber(value: 0.25),NSNumber(value: 0.5)]
let sp = CGPoint(x: 0, y: 0)
let ep = CGPoint(x: 1, y: 1)

let gView = UIGradientView()



//PlaygroundPage.current.liveView = gView
// Set the device type and orientation.
let (parent, _) = playgroundControllers(device: .phone5_5inch, orientation: .portrait)

// Render the screen.
let frame = parent.view.frame

let gViewStyle =
  UIGradientView.lens.gradientLayer.colors .~ colors
    >>> UIGradientView.lens.gradientLayer.locations .~ locations
    >>> UIGradientView.lens.gradientLayer.startPoint .~ sp
    >>> UIGradientView.lens.gradientLayer.endPoint .~ ep
    >>> UIGradientView.lens.frame .~ frame

gView |> gViewStyle


PlaygroundPage.current.liveView = gView


Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
  let colors = [UIColor.random.cgColor, UIColor.random.cgColor, UIColor.random.cgColor]
  UIView.animate(withDuration: 2){
    gView |> UIGradientView.lens.gradientLayer.colors .~ colors
  }

}













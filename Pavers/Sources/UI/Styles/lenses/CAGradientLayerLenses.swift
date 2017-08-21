import Pavers
import UIKit

public protocol CAGradientLayerProtocol: CALayerProtocol {
  /* The array of CGColorRef objects defining the color of each gradient
   * stop. Defaults to nil. Animatable. */

  var colors: [Any]? {get set}


  /* An optional array of NSNumber objects defining the location of each
   * gradient stop as a value in the range [0,1]. The values must be
   * monotonically increasing. If a nil array is given, the stops are
   * assumed to spread uniformly across the [0,1] range. When rendered,
   * the colors are mapped to the output colorspace before being
   * interpolated. Defaults to nil. Animatable. */

  var locations: [NSNumber]? {get set}


  /* The start and end points of the gradient when drawn into the layer's
   * coordinate space. The start point corresponds to the first gradient
   * stop, the end point to the last gradient stop. Both points are
   * defined in a unit coordinate space that is then mapped to the
   * layer's bounds rectangle when drawn. (I.e. [0,0] is the bottom-left
   * corner of the layer, [1,1] is the top-right corner.) The default values
   * are [.5,0] and [.5,1] respectively. Both are animatable. */

  var startPoint: CGPoint {get set}

  var endPoint: CGPoint {get set}
}

extension CAGradientLayer: CAGradientLayerProtocol {}

extension LensHolder where Object: CAGradientLayerProtocol {
  public var colors: Lens<Object, [Any]?> {
    return Lens(
      view: { $0.colors },
      set: { $1.colors = $0; return $1 }
    )
  }

  public var locations: Lens<Object, [NSNumber]?> {
    return Lens(
      view: { $0.locations },
      set: { $1.locations = $0; return $1 }
    )
  }

  public var startPoint: Lens<Object, CGPoint> {
    return Lens(
      view: { $0.startPoint },
      set: { $1.startPoint = $0; return $1 }
    )
  }

  public var endPoint: Lens<Object, CGPoint> {
    return Lens(
      view: { $0.endPoint },
      set: { $1.endPoint = $0; return $1 }
    )
  }
}


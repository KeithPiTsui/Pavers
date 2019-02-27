import PaversFRP
import UIKit

public let baseBarButtonItemStyle =
  UIBarButtonItem.lens.tintColor .~ .ksr_navy_700

public let plainBarButtonItemStyle = baseBarButtonItemStyle
  >>> UIBarButtonItem.lens.style .~ .plain
  >>> UIBarButtonItem.lens.titleTextAttributes(for: .normal) .~ [
    NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont.ksr_subhead(size: 15)
]

public let iconBarButtonItemStyle = baseBarButtonItemStyle
  >>> UIBarButtonItem.lens.title .~ nil

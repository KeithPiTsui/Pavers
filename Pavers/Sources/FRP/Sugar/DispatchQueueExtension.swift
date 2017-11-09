//
//  DispatchQueueExtension.swift
//  PaversFRP
//
//  Created by Keith on 06/11/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation

public extension DispatchQueue {
  private static var onceTokens = [UInt]()
  private static var internalQueue = DispatchQueue(label: "dispatchqueue.once")

  private static var token: UInt = 0
  public static var uniqueToken: UInt {
    return internalQueue.sync{
      token += 1
      return token
    }
  }
  
  /// token must be unqiue
  public static func once(token: UInt, closure: ()->Void) {
    internalQueue.sync {
      guard onceTokens.contains(token) == false else { return }
      onceTokens.append(token)
      closure()
    }
  }
}

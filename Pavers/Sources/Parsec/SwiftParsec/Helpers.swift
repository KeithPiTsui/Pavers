//
//  Helpers.swift
//  Parsec
//
//  Created by Keith on 06/12/2017.
//

import Foundation

extension String {
  
  internal func uncontains(_ element: Character) -> Bool {
    return self.contains(element)
  }
}

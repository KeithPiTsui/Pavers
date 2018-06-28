//
//  State.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/27.
//  Copyright © 2018 Keith. All rights reserved.
//


public struct ParserState<S, U> {
  public let stateInput: S
  public let statePos: SourcePos
  public let stateUser: U
}


public protocol ParserStream {
  associatedtype Element
  func first() -> Element?
  func droppingFirst() -> Self
}


extension String: ParserStream {
  public func first() -> Character? {
    return self.first
  }
  
  public func droppingFirst() -> String {
    return String(self.dropFirst())
  }
  
  
}

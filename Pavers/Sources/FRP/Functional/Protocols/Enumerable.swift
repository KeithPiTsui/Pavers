//
//  Enumerable.swift
//  PaversFRP
//
//  Created by Keith on 2018/7/10.
//  Copyright © 2018 Keith. All rights reserved.
//

//class Enum a where
//succ :: a -> a
//pred :: a -> a
//toEnum :: Int -> a
//fromEnum :: a -> Int
//enumFrom :: a -> [a]
//enumFromThen :: a -> a -> [a]
//enumFromTo :: a -> a -> [a]
//enumFromThenTo :: a -> a -> a -> [a]
//{-# MINIMAL toEnum, fromEnum #-}
public protocol Enumerable {
  func succ(_ a: Self) -> Self
  func pred(_ a: Self) -> Self
  
  func toEnum(_ n: Int) -> Self
  func fromEnum(_ a: Self) -> Int
  
  func enumFrom(_ a: Self) -> [Self]
  func enumFrom(_ a: Self, then b: Self) -> [Self]
  func enumFrom(_ a: Self, to b: Self) -> [Self]
  func enumFrom(_ a: Self, then b: Self, to c: Self) -> [Self]
}

extension Enumerable {
  func succ(_ a: Self) -> Self {
    return toEnum(fromEnum(a) + 1)
  }
  
  func pred(_ a: Self) -> Self {
    return toEnum(fromEnum(a) - 1)
  }
}

//
//  NFAExample.swift
//  ParsecMock
//
//  Created by Keith on 2018/7/12.
//  Copyright © 2018 Keith. All rights reserved.
//

public enum BinaryDigit: CaseIterable {
  case zero
  case one
}


public func endedWith01() -> NFA<Int, BinaryDigit> {
  let state1 = 0

  let inputSymbols: Set<BinaryDigit> = Set(BinaryDigit.allCases)
  let transitionMap: [Dictionary<BinaryDigit, Set<Int>>] = [
    [.zero: [0, 1], .one: [0]],
    [.zero: [], .one: [2]],
    [.zero: [], .one: []],
  ]
  let transition: (Int, BinaryDigit) -> Set<Int> = { state, input in
    transitionMap[state][input]!
  }
  let initialState = state1
  let finalStates: Set<Int> = [2]
  return NFA(alphabet: inputSymbols,
             transition: transition,
             initial: initialState,
             finals: finalStates)
}

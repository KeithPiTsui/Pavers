//
//  DFA2RE.swift
//  ParsecMock
//
//  Created by Keith on 2018/7/17.
//  Copyright © 2018 Keith. All rights reserved.
//

public func regularExpression<State, Symbol>(of dfa: DFA<State, Symbol>)
  -> RegularExpression<Symbol> {
    let renamedDFA: DFA<Int, Symbol> = renamedStates(of: dfa, start: 1)
    return regularExpression(of: renamedDFA)
}


public func regularExpression<Symbol>(of dfa: DFA<Int, Symbol>)
  -> RegularExpression<Symbol> {
    let transitionMap: [Int : [Symbol : Int]] = dfa.transitionMap()
    let states = dfa.accessibleStates
    let finals = dfa.finals
    return finals.reduce(RegularExpression<Symbol>.empty) { (acc, finalState) in
      acc + regularExpression(of: transitionMap, i: 1, j: finalState, k: states.count)
    }
}


public func regularExpression<Symbol>(of transitionMap: [Int : [Symbol : Int]],
                                      i: Int, j: Int, k: Int)
  -> RegularExpression<Symbol> {
    /// basic part
    if k == 0 {
      if i != j {
        let r = Array(transitionMap[i]!.filter{$0.value == j}.keys)
        if r.isEmpty {
          return RegularExpression.empty
        } else if r.count == 1 {
          return RegularExpression.primitives(r[0])
        } else {
          return r.reduce(RegularExpression.empty) { (acc, s) -> RegularExpression<Symbol> in
            acc + RegularExpression.primitives(s)
          }
        }
      } else {
        let r = Array(transitionMap[i]!.filter{$0.value == i}.keys)
        if r.isEmpty {
          return RegularExpression.epsilon
        } else if r.count == 1 {
          return RegularExpression.primitives(r[0]) + RegularExpression.epsilon
        } else {
          return r.reduce(RegularExpression.epsilon) { (acc, s) -> RegularExpression<Symbol> in
            acc + RegularExpression.primitives(s)
          }
        }
      }
    }
      /// Inductive part
    else {
      let first = regularExpression(of: transitionMap, i: i, j: j, k: k - 1)
      let second = regularExpression(of: transitionMap, i: i, j: k, k: k - 1)
      let three = regularExpression(of: transitionMap, i: k, j: k, k: k - 1)
      let four = regularExpression(of: transitionMap, i: k, j: j, k: k - 1)
      return first + (second * (three.*) * four)
    }
}

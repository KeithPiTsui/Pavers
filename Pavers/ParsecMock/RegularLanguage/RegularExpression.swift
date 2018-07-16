//
//  RegularExpression.swift
//  ParsecMock
//
//  Created by Keith on 2018/7/16.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public enum RegularExpression<Symbol> {
  /// empty string of symbol
  case epsilon
  /// empty language that contain no string of symbol
  case empty
  /// one symbol
  case primitives(Symbol)
  indirect case union(RegularExpression<Symbol>, RegularExpression<Symbol>)
  indirect case concatenation(RegularExpression<Symbol>, RegularExpression<Symbol>)
  indirect case kleeneClosure(RegularExpression<Symbol>)
  indirect case parenthesis(RegularExpression<Symbol>)
}

extension RegularExpression {
  public static func + (_ lhs: RegularExpression, _ rhs: RegularExpression)
    -> RegularExpression {
      return .union(lhs, rhs)
  }
  
  public static func * (_ lhs: RegularExpression, _ rhs: RegularExpression)
    -> RegularExpression {
      return .concatenation(lhs, rhs)
  }
  
  public static postfix func .* (_ re: RegularExpression)
    -> RegularExpression {
      return .kleeneClosure(re)
  }
}


public func renamedStates<State, Symbol>(of dfa: DFA<State, Symbol>, start: Int) -> DFA<Int, Symbol> {
  let states = dfa.accessibleStates
  let initialMap = [dfa.initial : 1]
  let restStates = states.subtracting([dfa.initial])
  let restMap = Dictionary.init(uniqueKeysWithValues: restStates.enumerated().map{(i, e) -> (State, Int) in (e, i + 2)})
  let stateMap = initialMap.withAllValuesFrom(restMap)
  let transition: (Int, Symbol) -> Int = { (stateInt, sym) in
    let s = stateMap.findFirst{(_, v) in v == stateInt}!.key
    let s_ = dfa.transition(s, sym)
    return stateMap[s_]!
  }
  let initialState = 1
  let finalStates: Set<Int> = Set(dfa.finals.map{stateMap[$0]!})
  return DFA(
    alphabet: dfa.alphabet,
    transition: transition,
    initial: initialState,
    finals: finalStates)
}

public func renamedStates<State, Symbol>(of enfa: ENFA<State, Symbol>, start: Int) -> ENFA<Int, Symbol> {
  let states = enfa.accessibleStates
  let initialState = start
  let initialMap = [enfa.initial : initialState]
  let restStates = states.subtracting([enfa.initial])
  let restMap = Dictionary.init(uniqueKeysWithValues: restStates.enumerated().map{(i, e) -> (State, Int) in (e, i + 1 + initialState)})
  
  let stateMap = initialMap.withAllValuesFrom(restMap)
  print(stateMap)
  
  let transition: (Int, Symbol?) -> Set<Int> = { (stateInt, sym) in
    let s = stateMap.findFirst{(_, v) in v == stateInt}?.key
    guard let ss = s else {
      print("stateInt:\(stateInt)")
      return []
    }
    let s_ = enfa.transition(ss, sym).map{stateMap[$0]!}
    return Set(s_)
  }
  
  let finalStates: Set<Int> = Set(enfa.finals.map{stateMap[$0]!})
  return ENFA(
    alphabet: enfa.alphabet,
    transition: transition,
    initial: initialState,
    finals: finalStates)
}

public func regularExpression<Int, Symbol>(of dfa: DFA<Int, Symbol>,
                                           i: Int, j: Int, k: Int)
  -> RegularExpression<Symbol> {
    fatalError("Not implemented yet")
}


public func transform<Symbol>(re: RegularExpression<Symbol>) -> ENFA<Int, Symbol> {
  switch re {
  case .epsilon:
    let transition: (Int, Symbol?) -> Set<Int> = { state, input in
      if state == 1 && input == nil {
        return [2]
      } else {
        return [state]
      }
    }
    return ENFA<Int, Symbol>(alphabet: [],
                             transition: transition,
                             initial: 1,
                             finals: [2])
  case .empty:
    let transition: (Int, Symbol?) -> Set<Int> = { state, input in
      [state]
    }
    return ENFA<Int, Symbol>(alphabet: [],
                             transition: transition,
                             initial: 1,
                             finals: [2])
  case .primitives(let a):
    let transition: (Int, Symbol?) -> Set<Int> = { state, input in
      if state == 1 && input == a {
        return [2]
      } else {
        return [state]
      }
    }
    return ENFA<Int, Symbol>(alphabet: [a],
                             transition: transition,
                             initial: 1,
                             finals: [2])
    
  case .union(let lhs, let rhs):
    let lhsENFA = transform(re: lhs)
    
    let lhsStateCount = lhsENFA.accessibleStates.count
    let renamedLHSENFA = renamedStates(of: lhsENFA, start: 2)
    let lhsStates = renamedLHSENFA.accessibleStates
    print(lhsStates)
    
    let rhsENFA = transform(re: rhs)
    let rhsStateCount = rhsENFA.accessibleStates.count
    let renamedRHSENFA = renamedStates(of: rhsENFA, start: lhsStateCount + 2)
    let rhsStates = renamedRHSENFA.accessibleStates
    print(rhsStates)
    
    let finals: Set<Int> = [1 + rhsStateCount + lhsStateCount + 1]
    
    let transition: (Int, Symbol?) -> Set<Int> = { state, input in
      if state == 1 && input == nil {
        return [renamedLHSENFA.initial, renamedRHSENFA.initial]
      } else if (renamedLHSENFA.finals <> renamedRHSENFA.finals).contains(state) && input == nil {
        return finals
      } else if lhsStates.contains(state) {
        return renamedLHSENFA.transition(state,input)
      } else if rhsStates.contains(state) {
        return renamedRHSENFA.transition(state,input)
      } else {
        return []
      }
    }
    let enfa = ENFA<Int, Symbol>(alphabet: lhsENFA.alphabet <> rhsENFA.alphabet,
                                 transition: transition,
                                 initial: 1,
                                 finals: finals)
    print(enfa.accessibleStates)
    
    return enfa
    
  case .concatenation(let lhs, let rhs):
    
    let lhsENFA = transform(re: lhs)
    let lhsStateCount = lhsENFA.accessibleStates.count
    let renamedLHSENFA = lhsENFA
    let lhsStates = renamedLHSENFA.accessibleStates
    print("concatenation lhsStates:\(lhsStates)")
    
    let rhsENFA = transform(re: rhs)
    let renamedRHSENFA = renamedStates(of: rhsENFA, start: lhsStateCount + 1)
    let rhsStates = renamedRHSENFA.accessibleStates
    print("concatenation rhsStates:\(rhsStates)")
    
    
    let finals: Set<Int> = renamedRHSENFA.finals
    
    let transition: (Int, Symbol?) -> Set<Int> = { state, input in
      if renamedLHSENFA.finals.contains(state) {
        return [renamedRHSENFA.initial]
      } else if lhsStates.contains(state) {
        return renamedLHSENFA.transition(state,input)
      } else if rhsStates.contains(state) {
        return renamedRHSENFA.transition(state,input)
      } else {
        return []
      }
    }
    return ENFA<Int, Symbol>(alphabet: lhsENFA.alphabet <> rhsENFA.alphabet,
                             transition: transition,
                             initial: 1,
                             finals: finals)
    
  case .kleeneClosure(let re):
    let enfa = transform(re: re)
    let renamedENFA = renamedStates(of: enfa, start: 2)
    let renamedENFAStates = renamedENFA.accessibleStates
    print(renamedENFAStates)
    
    let finals: Set<Int> = [renamedENFAStates.count + 2]
    
    let transition: (Int, Symbol?) -> Set<Int> = { state, input in
      if state == 1 && input == nil {
        return [renamedENFA.initial] <> finals
      } else if renamedENFA.finals.contains(state) && input == nil {
        return [renamedENFA.initial] <> finals
      } else if renamedENFAStates.contains(state){
        return renamedENFA.transition(state, input)
      } else {
        return []
      }
    }
    
    let enfa_ = ENFA<Int, Symbol>(alphabet: renamedENFA.alphabet,
                                 transition: transition,
                                 initial: 1,
                                 finals: finals)
    
    print(enfa_.accessibleStates)
    
    return enfa_
    
  case .parenthesis(let re):
    return transform(re: re)
  }
}





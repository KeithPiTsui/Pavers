//
//  ENFA.swift
//  ParsecMock
//
//  Created by Keith on 2018/7/12.
//  Copyright © 2018 Keith. All rights reserved.
//

import Foundation


import PaversFRP

public struct ENFA<State, Sym>
where State: Hashable, Sym: Hashable {
  public let alphabet: Set<Sym>
  public let transition: (State, Sym?) -> Set<State>
  public let initial: State
  public let finals: Set<State>
}

extension ENFA {
  public func extendedTransition<C>(_ state: State, _ symbols: C) -> Set<State>
    where C: BidirectionalCollection, C.Element == Sym {
      // base case: when input is empty,
      // return the e-closure of the state
      guard let a = symbols.last else { return self.eclosure(of: state) }
      
      // inductive case: when input is not empty,
      // hence the input can be represented as w = xa,
      // where the a is last symbol of the input.
      // Given the extendedTransition of state and x,
      // we can get the extendedTransition of w,
      let ps = extendedTransition(state, symbols.dropLast())
      
      // by calculating the set of state that can be reached with
      // a transition on a
      let rs = ps.reduce([])
      {(acc, p) -> Set<State> in acc <> transition(p, a)}
      
      // lastly, calculate the e-closure of a-transited set.
      let ers = rs.reduce([])
      {(acc, p) -> Set<State> in acc <> self.eclosure(of: p)}
      
      return ers
  }
}


extension ENFA {
  public var accessibleStates : Set<State> {
    var preAccessibleStates: Set<State> = [initial]
    var currentAccessibleStates: Set<State> = [initial]
    repeat {
      preAccessibleStates = currentAccessibleStates
      currentAccessibleStates = nextAccessibleStates(of: currentAccessibleStates, with: transition, and: alphabet)
    } while currentAccessibleStates != preAccessibleStates
    return currentAccessibleStates
    
  }
}

extension ENFA {
  public func eTransition(from state: State) -> Set<State> {
    return self.transition(state, nil)
  }
  
  public func eclosure(of state: State) -> Set<State> {
    var preStates: Set<State> = [state]
    var curStates: Set<State> = [state]
    var newStates: Set<State> = [state]
    repeat {
      newStates = Set(newStates.flatMap(self.eTransition))
      preStates = curStates
      curStates = curStates <> newStates
    } while preStates != curStates
    return curStates
  }
}

public func nextAccessibleStates<State, Sym>
  (of states: Set<State>,
   with transition: (State, Sym?) -> Set<State>,
   and alphabet: Set<Sym>) -> Set<State> {
  return
    Set(states.flatMap { (state) in
      alphabet.flatMap{ (sym) in
        transition(state, sym)}
    })
}

public func process<State, Sym, C>(input: C,
                                   on enfa: ENFA<State, Sym>)
  -> Bool
  where C: BidirectionalCollection, C.Element == Sym {
    let state = enfa.extendedTransition(enfa.initial, input)
    return !enfa.finals.intersection(state).isEmpty
}




/**
 Transform
 NFA N = (Qn, Σ, 𝛅n, q0, Fn)
 to
 DFA D = (Qd, Σ, 𝛅d, {q0}, Fd)
 using subset construction.
 */
public func transform<State, Sym>(enfa: ENFA<State, Sym>) -> DFA<Set<State>, Sym> {
  let alphabet = enfa.alphabet
  
  let initial: Set<State> = enfa.eclosure(of: enfa.initial)
  
  
  var transitionMap: [Pair<Set<State>, Sym>: Set<State>] = [:]
  let transition: (Set<State>, Sym) -> Set<State> = { (states, a) in
    if let exists = transitionMap[Pair(states, a)] {
      return exists
    } else {
      
      let rs: Set<State> = states
        .reduce([]) { (acc, p) in
          acc <> enfa.transition(p, a)}
      
      let new = rs.reduce([])
      {(acc, p) -> Set<State> in acc <> enfa.eclosure(of: p)}
      
      transitionMap[Pair(states, a)] = new
      return new
      
    }
  }
  
  let states: Set<Set<State>> = {
    var preState: Set<Set<State>> = [initial]
    var currentStates: Set<Set<State>> = [initial]
    repeat {
      preState = currentStates
      currentStates = nextAccessibleStates(of: currentStates, with: transition, and: alphabet)
    } while currentStates != preState
    return currentStates
  }()
  
  let finals = states.filter{!$0.intersection(enfa.finals).isEmpty}
  
  
  return DFA(alphabet: alphabet,
             transition: transition,
             initial: initial,
             finals: finals)
}

public func nextAccessibleStates<State, Sym>
  (of states: Set<State>,
   with transition: (State, Sym?) -> State,
   and alphabet: Set<Sym>) -> Set<State> {
  return
    Set(states.flatMap { (state) in
      alphabet.map{ (sym) in
        transition(state, sym)}
    })
}

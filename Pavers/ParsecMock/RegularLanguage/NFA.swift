//
//  NFA.swift
//  ParsecMock
//
//  Created by Keith on 2018/7/12.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public struct NFA<State, Sym>
where State: Hashable, Sym: Hashable {
  public let alphabet: Set<Sym>
  public let transition: (State, Sym) -> Set<State>
  public let initial: State
  public let finals: Set<State>
}

extension NFA {
  public func extendedTransition<C>(_ state: State, _ symbols: C) -> Set<State>
    where C: BidirectionalCollection, C.Element == Sym {
      guard let a = symbols.last else { return [state] }
      return extendedTransition(state, symbols.dropLast())
        .reduce([])
        { (acc, ps) -> Set<State> in acc <> transition(ps, a) }
  }
}


extension NFA {
  public var accessibleStates : Set<State> {
    var preAccessibleStates: Set<State> = [initial]
    var currentAccessibleStates: Set<State> = [initial]
    var newAddedStates: Set<State> = [initial]
    repeat {
      preAccessibleStates = currentAccessibleStates
      newAddedStates = nextAccessibleStates(of: newAddedStates, with: transition, and: alphabet)
      currentAccessibleStates = newAddedStates <> currentAccessibleStates
    } while currentAccessibleStates != preAccessibleStates
    return currentAccessibleStates
  }
}

public func nextAccessibleStates<State, Sym>
  (of states: Set<State>,
   with transition: (State, Sym) -> Set<State>,
   and alphabet: Set<Sym>) -> Set<State> {
  return
    Set(states.flatMap { (state) in
      alphabet.flatMap{ (sym) in
        transition(state, sym)}
    })
}


public func process<State, Sym, C>(input: C,
                                   on nfa: NFA<State, Sym>)
  -> Bool
  where C: BidirectionalCollection, C.Element == Sym {
    let state = nfa.extendedTransition(nfa.initial, input)
    return !nfa.finals.intersection(state).isEmpty
}

/**
 Transform
 NFA N = (Qn, Σ, 𝛅n, q0, Fn)
 to
 DFA D = (Qd, Σ, 𝛅d, {q0}, Fd)
 using subset construction.
 */
public func transform<State, Sym>(nfa: NFA<State, Sym>) -> DFA<Set<State>, Sym> {
  let alphabet = nfa.alphabet
  let initial: Set<State> = [nfa.initial]
  var transitionMap: [Pair<Set<State>, Sym>: Set<State>] = [:]
  let transition: (Set<State>, Sym) -> Set<State> = { (states, a) in
    if let exists = transitionMap[Pair(states, a)] {
      return exists
    } else {
      let new: Set<State> = states
        .reduce([]) { (acc, p) in
          acc <> nfa.transition(p, a)}
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
  
  let finals = states.filter{!$0.intersection(nfa.finals).isEmpty}
  
  
  return DFA(alphabet: alphabet,
             transition: transition,
             initial: initial,
             finals: finals)
}

public func nextAccessibleStates<State, Sym>
  (of states: Set<State>,
   with transition: (State, Sym) -> State,
   and alphabet: Set<Sym>) -> Set<State> {
  return
    Set(states.flatMap { (state) in
      alphabet.map{ (sym) in
        transition(state, sym)}
    })
}



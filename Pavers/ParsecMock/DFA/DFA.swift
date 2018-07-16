//
//  DFA.swift
//  ParsecMock
//
//  Created by Keith on 2018/7/10.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

/**
 An `Alphabet` is a finite, nonempty set of symbols.
 
 Conventionally, we use the symbol Sigma (Σ) for an Alphabet.
 */
public typealias Alphabet<Symbol> = Set<Symbol> where Symbol: Hashable


public struct DFA<State, Sym>
where State: Hashable, Sym: Hashable {
  public let alphabet: Set<Sym>
  public let transition: (State, Sym) -> State
  public let initial: State
  public let finals: Set<State>
}

extension DFA {
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

extension DFA {
  public func extendedTransition<C>(_ state: State, _ symbols: C) -> State
    where C: BidirectionalCollection, C.Element == Sym {
      guard let a = symbols.last else { return state }
      return transition(extendedTransition(state, symbols.dropLast()), a)
  }
}


public func * <StateA, StateB, Sym>(_ lhs: DFA<StateA, Sym>,
                                    _ rhs: DFA<StateB, Sym>)
  -> DFA<Pair<StateA, StateB>, Sym> {
    let alphabet = lhs.alphabet <> rhs.alphabet
    let transition: (Pair<StateA, StateB>, Sym) -> Pair<StateA, StateB> = { (pairState, sym) in
      let s1 = lhs.transition(pairState.first, sym)
      let s2 = rhs.transition(pairState.second, sym)
      return Pair(s1, s2)
    }
    let initialState: Pair<StateA, StateB> = Pair(lhs.initial, rhs.initial)
    let finalStates = cartesian(lhs.finals, rhs.finals)
    return DFA(alphabet: alphabet,
               transition: transition,
               initial: initialState,
               finals: finalStates)
}

public func cartesian<A, B>(_ a: Set<A>, _ b: Set<B>) -> Set<Pair<A, B>>
  where A: Hashable, B: Hashable {
    return Set( a.flatMap{ a_ in b.map{b_ in Pair(a_, b_)}})
}


public func process<State, Sym, Seq>(input: Seq,
                                     on dfa: DFA<State, Sym>)
  -> Bool
  where Seq: Sequence, Seq.Element == Sym {
    var currentState = dfa.initial
    for e in input {
      currentState = dfa.transition(currentState, e)
    }
    return dfa.finals.contains(currentState)
}


public func transform<State, Sym>(dfa: DFA<State, Sym>) -> NFA<State, Sym> {
  let transition: (State, Sym) -> Set<State> = { state, input in
    [dfa.transition(state, input)]
  }
  return NFA(alphabet: dfa.alphabet,
             transition: transition,
             initial: dfa.initial,
             finals: dfa.finals)
}

public func transform<State, Sym>(dfa: DFA<State, Sym>) -> ENFA<State, Sym> {
  let transition: (State, Sym?) -> Set<State> = { state, input in
    if let sym = input {
      return [dfa.transition(state, sym)]
    } else {
      return []
    }
  }
  return ENFA(alphabet: dfa.alphabet,
             transition: transition,
             initial: dfa.initial,
             finals: dfa.finals)
}

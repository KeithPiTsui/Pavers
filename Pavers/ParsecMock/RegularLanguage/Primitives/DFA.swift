//
//  DFA.swift
//  ParsecMock
//
//  Created by Keith on 2018/7/10.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

public struct DFA<State, Sym>
where State: Hashable, Sym: Hashable {
  public let alphabet: Set<Sym>
  public let transition: (State, Sym) -> State
  public let initial: State
  public let finals: Set<State>
}

extension DFA {
  public func transitionMap() -> [State:[Sym: State]] {
    return Dictionary(uniqueKeysWithValues:
      self.accessibleStates.map { (state) -> (State, [Sym: State]) in
        (state,
         Dictionary(uniqueKeysWithValues:
          self.alphabet
            .map{ (sym) -> (Sym, State) in
              (sym,
               transition(state, sym)
              )
          }
          )
        )
      }
    )
  }
}

extension DFA {
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

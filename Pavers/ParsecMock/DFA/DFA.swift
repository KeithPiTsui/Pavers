//
//  DFA.swift
//  ParsecMock
//
//  Created by Keith on 2018/7/10.
//  Copyright © 2018 Keith. All rights reserved.
//

/**
 An `Alphabet` is a finite, nonempty set of symbols.

 Conventionally, we use the symbol Sigma (Σ) for an Alphabet.
 */
public typealias Alphabet<Symbol> = Set<Symbol> where Symbol: Hashable




public struct DFAState {
  public let id: UUID
}

public struct DFA<State, Sym>
where State: Hashable, Sym: Hashable {
  public let states: Set<State>
  public let inputSymbols: Set<Sym>
  public let transition: (State, Sym) -> State?
  public let initialState: State
  public let finalStates: Set<State>
}

public func process<State, Sym, Seq>(input: Seq,
                                     on dfa: DFA<State, Sym>)
  -> Bool
  where Seq: Sequence, Seq.Element == Sym {
    var currentState = dfa.initialState
    for e in input {
      if let nextState = dfa.transition(currentState, e) {
        currentState = nextState
      } else {
        return false
      }
    }
    return dfa.finalStates.contains(currentState)
}

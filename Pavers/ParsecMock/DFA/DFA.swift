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
  public let profile: String
}
extension DFAState: Hashable{}

public enum ElectronicMoneyEvents: CaseIterable {
  case pay
  case ship
  case cancel
  case redeem
  case transfer
}


public func customerDFA() -> DFA<Int, ElectronicMoneyEvents> {
  let state1 = 1
  let states: Set<Int> = [1]
  let inputSymbols: Set<ElectronicMoneyEvents> = Set(ElectronicMoneyEvents.allCases)
  let transition: (Int, ElectronicMoneyEvents) -> Int? = { _,_ in state1 }
  let initialState = state1
  let finalStates: Set<Int> = [state1]
  return DFA(states: states,
             inputSymbols: inputSymbols,
             transition: transition,
             initialState: initialState,
             finalStates: finalStates)
}

public func bankDFA() -> DFA<Int, ElectronicMoneyEvents> {
  let state1 = 1
  let states: Set<Int> = [1, 2, 3, 4]
  let inputSymbols: Set<ElectronicMoneyEvents> = Set(ElectronicMoneyEvents.allCases)
  let transitionMap: [Dictionary<ElectronicMoneyEvents, Int>] = [
    [.pay: 1, .ship: 1, .cancel: 2, .redeem: 3],
    [.pay: 2, .ship: 2],
    [.pay: 3, .ship: 3, .cancel: 3, .redeem: 3, .transfer: 4],
    [.pay: 3, .ship: 3, .cancel: 3, .redeem: 3]
  ]
  let transition: (Int, ElectronicMoneyEvents) -> Int? = { state, input in
    transitionMap[state - 1][input]
  }
  let initialState = state1
  let finalStates: Set<Int> = [2, 4]
  return DFA(states: states,
             inputSymbols: inputSymbols,
             transition: transition,
             initialState: initialState,
             finalStates: finalStates)
}

public func storeDFA() -> DFA<Int, ElectronicMoneyEvents> {
  let state1 = 1
  let states: Set<Int> = [1, 2, 3, 4, 5, 6, 7]
  let inputSymbols: Set<ElectronicMoneyEvents> = Set(ElectronicMoneyEvents.allCases)
  let transitionMap: [Dictionary<ElectronicMoneyEvents, Int>] = [
    [.pay: 2, .cancel: 1,],
    [.pay: 2, .cancel: 2, .ship: 3, .redeem: 4,],
    [.pay: 3, .cancel: 3, .redeem: 5, ],
    [.pay: 4, .ship: 5, .cancel: 4, .transfer: 6],
    [.pay: 5, .cancel: 5, .transfer: 7],
    [.pay: 6, .ship: 7, .cancel: 6,],
    [.pay: 7, .cancel: 7,],
  ]
  let transition: (Int, ElectronicMoneyEvents) -> Int? = { state, input in
    transitionMap[state - 1][input]
  }
  let initialState = state1
  let finalStates: Set<Int> = [7]
  return DFA(states: states,
             inputSymbols: inputSymbols,
             transition: transition,
             initialState: initialState,
             finalStates: finalStates)
}



public struct DFA<State, Sym>
where State: Hashable, Sym: Hashable {
  public let states: Set<State>
  public let inputSymbols: Set<Sym>
  public let transition: (State, Sym) -> State?
  public let initialState: State
  public let finalStates: Set<State>
}

public struct DFAPair<StateA, StateB> {
  public let first: StateA
  public let second: StateB
}
extension DFAPair: Equatable where StateA: Equatable, StateB: Equatable {}
extension DFAPair: Hashable where StateA: Hashable, StateB: Hashable {}

public func * <StateA, StateB, Sym>(_ lhs: DFA<StateA, Sym>,
                                    _ rhs: DFA<StateB, Sym>)
  -> DFA<DFAPair<StateA, StateB>, Sym> {
    let states = cartesian(lhs.states, rhs.states)
    let inputSymbols = lhs.inputSymbols.union(rhs.inputSymbols)
    let transition: (DFAPair<StateA, StateB>, Sym) -> DFAPair<StateA, StateB>? = { (pairState, sym) in
      guard let s1 = lhs.transition(pairState.first, sym),
        let s2 = rhs.transition(pairState.second, sym) else {return nil}
      return DFAPair(first: s1, second: s2)
    }
    let initialState: DFAPair<StateA, StateB> = DFAPair(first: lhs.initialState, second: rhs.initialState)
    let finalStates = cartesian(lhs.finalStates, rhs.finalStates)
    return DFA.init(states: states,
                    inputSymbols: inputSymbols,
                    transition: transition,
                    initialState: initialState,
                    finalStates: finalStates)
}

public func cartesian<A, B>(_ a: Set<A>, _ b: Set<B>) -> Set<DFAPair<A, B>> where A: Hashable, B: Hashable {
  return Set( a.flatMap{ a_ in
    b.map{b_ in DFAPair(first: a_, second: b_)}
  })
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

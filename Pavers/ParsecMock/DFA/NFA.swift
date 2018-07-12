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
  public let states: Set<State>
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
        { (acc, ps) -> Set<State> in acc.union(transition(ps, a))}
  }
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
  let states: Set<Set<State>> = powerSet(of: nfa.states)
  let finals = states.filter{!$0.intersection(nfa.finals).isEmpty}
  let transition: (Set<State>, Sym) -> Set<State> = { (states, a) in
    return states.reduce([]) { (acc, p) -> Set<State> in
      acc.union(nfa.transition(p, a))
    }
  }
  return DFA(states: states,
             alphabet: alphabet,
             transition: transition,
             initial: initial,
             finals: finals)
}

public func factorial(_ n: Int) -> Int {
  return (1...n).reduce(1, *)
}

public func permutation(_ m: Int, _ n: Int) -> Int {
  return (1...n).suffix(m).reduce(1, *)
}

public func combinator(_ m: Int, _ n: Int) -> Int {
  return permutation(m, n) / factorial(m)
}

public func powerSet<A>(of a: Set<A>) -> Set<Set<A>> {
  return Set(Array(a).powerSet.map(Set.init))
}

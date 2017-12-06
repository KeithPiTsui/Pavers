/*
    The primitive parser combinators.
*/

public typealias ParserX<Result, Input: Collection>
  = (State<Input, ()>) -> Consumed<Result, Input, ()>

public typealias ParserClosure<Result, Input: Collection>
  = () -> (State<Input, ()>) -> Consumed<Result, Input, ()>

public typealias UserParser<Result, Input: Collection, UserInfo>
  = (State<Input, UserInfo>) -> Consumed<Result, Input, UserInfo>

public typealias UserParserClosure<a, Input: Collection, UserInfo>
  = () -> (State<Input, UserInfo>) -> Consumed<a, Input, UserInfo>

public enum Consumed<Result, Input: Collection, UserInfo> {
  case consumed(Lazy<Reply<Result, Input, UserInfo>>)
  case empty(Reply<Result, Input, UserInfo>)

  func map<ResultB> (_ f: @escaping (Result) -> ResultB) -> Consumed<ResultB, Input, UserInfo> {
    switch self {
    case let .consumed(reply): return .consumed(Lazy{ reply.value.map(f) })
    case let .empty(reply): return .empty(reply.map(f))
    }
  }
}

public enum Reply<Result, Input: Collection, UserInfo> {
  case ok(Result, State<Input, UserInfo>, Lazy<ParseError>)
  case error(Lazy<ParseError>)

  func map<ResultB> (_ f: (Result) -> ResultB) -> Reply<ResultB, Input, UserInfo> {
    switch self {
    case let .ok(x, s, err): return .ok(f(x), s, err)
    case let .error(err): return .error(err)
    }
  }
}

public struct State<Input: Collection, UserInfo> {
  let input: Input
  let pos: SourcePos
  let user: UserInfo

  init (_ input: Input, _ pos: SourcePos, _ user: UserInfo) {
    self.input = input
    self.pos = pos
    self.user = user
  }
}

public class Lazy<x> {
  let closure: () -> x
  var val: x?

  init (_ c: @escaping () -> x) {
    closure = c
  }

  var value: x {
    self.val = self.val ?? self.closure()
    return self.val!
  }
}

public enum Either<l, r> {
  case left(l)
  case right(r)
}

public func create<Result, Input: Collection, UserInfo> (_ x: Result)
  -> UserParserClosure<Result, Input, UserInfo> {
  return parserReturn(x)
}

precedencegroup BindPrecedence {
  associativity: left
  higherThan: ChoicePrecedence
}

precedencegroup ChoicePrecedence {
  associativity: right
  higherThan: LabelPrecedence
}

precedencegroup LabelPrecedence {
}

infix operator >>- : BindPrecedence
public func >>- <ResultA, ResultB, Input, UserInfo>
  (p: @escaping UserParserClosure<ResultA, Input, UserInfo>,
   f: @escaping (ResultA) -> UserParserClosure<ResultB, Input, UserInfo>)
  -> UserParserClosure<ResultB, Input, UserInfo> {
  return parserBind(p, f)
}

infix operator >>> : BindPrecedence
public func >>> <ResultA, ResultB, Input, UserInfo>
  (p: @escaping UserParserClosure<ResultA, Input, UserInfo>,
   q: @escaping UserParserClosure<ResultB, Input, UserInfo>)
  -> UserParserClosure<ResultB, Input, UserInfo> {
  return p >>- { _ in q }
}

infix operator <<< : BindPrecedence
public func <<< <ResultA, ResultB, Input, UserInfo>
  (p: @escaping UserParserClosure<ResultA, Input, UserInfo>,
   q: @escaping UserParserClosure<ResultB, Input, UserInfo>)
  -> UserParserClosure<ResultA, Input, UserInfo> {
  return p >>- { x in q >>> create(x) }
}

/**
    The parser `unexpected(msg)` always fails with an unexpected error
    message `msg` without consuming any input.

    The parsers `fail`, `<?>` and `unexpected` are the three parsers
    used to generate error messages. Of these, only `<?>` is commonly
    used. For an example of the use of `unexpected`, see the definition
    of `notFollowedBy`.
*/
public func unexpected<Result, Input: Collection, UserInfo>
  (_ msg: String)
  -> UserParserClosure<Result, Input, UserInfo> {
  return {{ state in
    .empty(.error(Lazy{ ParseError(state.pos, [.unExpect(msg)]) }))
  }}
}

public func fail<Result, Input: Collection, UserInfo>
  (_ msg: String)
  -> UserParserClosure<Result, Input, UserInfo> {
  return parserFail(msg)
}

public func parserReturn<Result, Input: Collection, UserInfo>
  (_ x: Result)
  -> UserParserClosure<Result, Input, UserInfo> {
  return {{ state in .empty(.ok(x, state, Lazy{ unknownError(state) })) }}
}

public func parserBind<ResultA, ResultB, Input, UserInfo>
  (_ p: @escaping UserParserClosure<ResultA, Input, UserInfo>,
   _ f: @escaping (ResultA) -> UserParserClosure<ResultB, Input, UserInfo>)
  -> UserParserClosure<ResultB, Input, UserInfo> {
  return {{ state in
    switch p()(state) {

    case let .empty(reply1):
      switch reply1 {
      case let .error(msg1): return .empty(.error(msg1))
      case let .ok(x, inp, msg1):
        switch f(x)()(inp) {
        case let .empty(.error(msg2)): return .empty(.error(Lazy{ mergeError(msg1.value, msg2.value) }))
        case let .empty(.ok(y, _, msg2)): return .empty(.ok(y, inp, Lazy{ mergeError(msg1.value, msg2.value) }))
        case let .consumed(reply2):
          switch reply2.value {
          case let .error(msg2): return .consumed(Lazy{ .error(Lazy{ mergeError(msg1.value, msg2.value) }) })
          case let .ok(y, rest, msg2): return .consumed(Lazy{ .ok(y, rest, Lazy{ mergeError(msg1.value, msg2.value) }) })
          }
        }
      }

    case let .consumed(reply1):
      return .consumed(Lazy{
        switch reply1.value {
        case let .error(msg1): return .error(msg1)
        case let .ok(x, rest, msg1):
          switch f(x)()(rest) {
          case let .empty(.error(msg2)): return .error(Lazy{ mergeError(msg2.value,msg1.value) })
          case let .empty(.ok(y, inp, msg2)): return .ok(y, inp, Lazy{ mergeError(msg1.value, msg2.value) })
          case let .consumed(reply2): return reply2.value
          }
        }
      })
    }
  }}
}

public func parserFail<Result, Input: Collection, UserInfo>
  (_ msg: String)
  -> UserParserClosure<Result, Input, UserInfo> {
  return {{ state in
    .empty(.error(Lazy{ ParseError(state.pos, .message(msg)) }))
  }}
}

/**
    `parserZero` always fails without consuming any input.
*/
public func parserZero<Result, Input: Collection, UserInfo>
  ()
  -> UserParser<Result, Input, UserInfo> {
  return { state in .empty(.error(Lazy{ unknownError(state) }))}
}

public func parserPlus<Result, Input, UserInfo>
  (_ p: @escaping UserParserClosure<Result, Input, UserInfo>,
   _ q: @escaping UserParserClosure<Result, Input, UserInfo>)
  -> UserParserClosure<Result, Input, UserInfo> {
  return {{ state in
    switch p()(state) {
    case let .empty(.error(msg1)):
      switch q()(state) {
      case let .empty(.error(msg2)): return .empty(.error(Lazy{ mergeError(msg1.value, msg2.value) }))
      case let .empty(.ok(x, inp, msg2)): return .empty(.ok(x, inp, Lazy{ mergeError(msg1.value, msg2.value) }))
      case let consumed: return consumed
      }
    case let .empty(.ok(x, inp, msg1)):
      switch q()(state) {
      case let .empty(.error(msg2)): return .empty(.ok(x, inp, Lazy{ mergeError(msg1.value, msg2.value) }))
      case let .empty(.ok(_, _, msg2)): return .empty(.ok(x, inp, Lazy{ mergeError(msg1.value, msg2.value) }))
      case let consumed: return consumed
      }
    case let consumed: return consumed
    }
  }}
}

/**
    The parser `p <?> msg` behaves as parser `p`, but whenever the
    parser `p` fails *without consuming any input*, it replaces expect
    error messages with the expect error message `msg`.

    This is normally used at the end of a set alternatives where we want
    to return an error message in terms of a higher level construct
    rather than returning all possible characters.
*/
infix operator <?> : LabelPrecedence
public func <?> <Result, Input, UserInfo>
  (p: @escaping UserParserClosure<Result, Input, UserInfo>, msg: String)
  -> UserParserClosure<Result, Input, UserInfo> {
  return label(p, msg)
}

public func label<Result, Input, UserInfo>
  (_ p: @escaping UserParserClosure<Result, Input, UserInfo>, _ msg: String)
  -> UserParserClosure<Result, Input, UserInfo> {
  return labels(p, [msg])
}

public func labels<Result, Input, UserInfo>
  (_ p: @escaping UserParserClosure<Result, Input, UserInfo>,
   _ msgs: [String])
  -> UserParserClosure<Result, Input, UserInfo> {
  return {{ state in
    switch p()(state) {
    case let .empty(.error(err)): return .empty(.error(Lazy{ setExpectErrors(err.value, msgs) }))
    case let .empty(.ok(x, st, err)): return .empty(.ok(x, st, Lazy{ setExpectErrors(err.value, msgs) }))
    case let other: return other
    }
  }}
}

func setExpectErrors
  (_ err: ParseError,
   _ msgs: [String])
  -> ParseError {
    
  var error = err
  if let head = msgs.first {
    let tail = msgs.dropFirst()
    error.setMessage(.expect(head))
    tail.forEach { msg in error.addMessage(.expect(msg)) }
  } else {
    error.setMessage(.expect(""))
  }
  return error
}

/**
    This combinator implements choice. The parser `p <|> q` first
    applies `p`. If it succeeds, the value of `p` is returned. If `p`
    fails *without consuming any input*, parser `q` is tried.

    The parser is called *predictive* since `q` is only tried when
    parser `p` didn't consume any input (i.e.. the look ahead is 1).
    This non-backtracking behaviour allows for both an efficient
    implementation of the parser combinators and the generation of good
    error messages.
*/
infix operator <|> : ChoicePrecedence
public func <|> <Result, Input, UserInfo>
  (p: @escaping UserParserClosure<Result, Input, UserInfo>,
   q: @escaping UserParserClosure<Result, Input, UserInfo>)
  -> UserParserClosure<Result, Input, UserInfo> {
  return parserPlus(p, q)
}

/**
    The parser `attempt(p)` behaves like parser `p`, except that it
    pretends that it hasn't consumed any input when an error occurs.

    This combinator is used whenever arbitrary look ahead is needed.
    Since it pretends that it hasn't consumed any input when `p` fails,
    the `<|>` combinator will try its second alternative even when the
    first parser failed while consuming input.

    The `attempt` combinator can for example be used to distinguish
    identifiers and reserved words. Both reserved words and identifiers
    are a sequence of letters. Whenever we expect a certain reserved
    word where we can also expect an identifier we have to use the `attempt`
    combinator. Suppose we write:

        expr        = letExpr() <|> identifier() <?> "expression"

        func letExpr<a, c: Collection> () -> Parser<a, c> {
          return string("let") ...
        }
        func identifier<a, c: Collection> () -> Parser<a, c> {
          return many1(letter())
        }

    If the user writes "lexical", the parser fails with: `unexpected
    'x', expecting 't' in "let"`. Indeed, since the `<|>` combinator
    only tries alternatives when the first alternative hasn't consumed
    input, the `identifier` parser is never tried (because the prefix
    "le" of the `string "let"` parser is already consumed). The
    right behaviour can be obtained by adding the `attempt` combinator:

        expr        = letExpr() <|> identifier() <?> "expression"

        func letExpr<a, c: Collection> () -> Parser<a, c> {
          return attempt(string("let")) ...
        }
        func identifier<a, c: Collection> () -> Parser<a, c> {
          return many1(letter())
        }
*/
public func attempt<Result, Input, UserInfo>
  (_ p: @escaping UserParserClosure<Result, Input, UserInfo>)
  -> UserParserClosure<Result, Input, UserInfo> {
  return {{ state in
    switch p()(state) {
    case let .consumed(reply):
      switch reply.value {
      case let .error(msg): return .empty(.error(msg))
      default: return .consumed(reply)
      }
    case let other: return other
    }
  }}
}

/**
    `lookAhead(p)` parses `p` without consuming any input.

    If `p` fails and consumes some input, so does `lookAhead`. Combine with
    `attempt` if this is undesirable.
*/
public func lookAhead<Result, Input, UserInfo>
  (_ p: @escaping UserParserClosure<Result, Input, UserInfo>)
  -> UserParserClosure<Result, Input,UserInfo> {
  return {{ state in
    switch p()(state) {
    case let .consumed(reply):
      switch reply.value {
      case let .ok(x, _, _): return .empty(.ok(x, state, Lazy{ unknownError(state) }))
      default: return .consumed(reply)
      }
    case let .empty(reply):
      switch reply {
      case let .ok(x, _, _): return .empty(.ok(x, state, Lazy{ unknownError(state) }))
      default: return .empty(reply)
      }
    }
  }}
}

/**
    The parser `token(showTok, posFromTok, testTok)` accepts a token `t`
    with result `x` when the function `testTok(t)` returns `.some(x)`. The
    source position of the `t` should be returned by `posFromTok(t)` and
    the token can be shown using `showTok(t)`.

    This combinator is expressed in terms of `tokenPrim`.
    It is used to accept user defined token streams. For example,
    suppose that we have a stream of basic tokens tupled with source
    positions. We can then define a parser that accepts single tokens as:

        func myToken<a, c: Collection> (_ x: c.Iterator.Element) -> Parser<a, c> {
          let showToken = { (pos, t) in String(t) }
          let posFromTok = { (pos, t) in pos }
          let testTok = { (pos, t) in if x == t { return t } else { return nil } }
          return token(showTok, posFromTok, testTok)
        }
*/
public func token<Result, Input: Collection, UserInfo>
  (_ showToken: @escaping (Input.Iterator.Element) -> String,
   _ tokenPosition: @escaping (Input.Iterator.Element) -> SourcePos,
   _ test: @escaping (Input.Iterator.Element) -> Result?)
  -> UserParserClosure<Result, Input, UserInfo>
  where Input.SubSequence == Input {
    
  let nextPosition: (SourcePos, Input.Iterator.Element, Input) -> SourcePos = { _, current, remainder in
    return tokenPosition( remainder.first ?? current )
  }
  return tokenPrim(showToken, nextPosition, test)
}

public func tokens<Input: Collection, UserInfo>
  (_ showTokens: @escaping ([Input.Iterator.Element]) -> String,
   _ nextPosition: @escaping (SourcePos, [Input.Iterator.Element]) -> SourcePos,
   _ tts: [Input.Iterator.Element])
  -> UserParserClosure<[Input.Iterator.Element], Input, UserInfo>
  where Input.Iterator.Element: Equatable, Input.SubSequence == Input {
    
  if let tok = tts.first {
    let toks = tts.dropFirst()
    return {{ state in
      let errEof = ParseError(state.pos, [.sysUnExpect(""), .expect(showTokens(tts))])
      let errExpect = { x in ParseError(state.pos, [.sysUnExpect(showTokens([x])), .expect(showTokens(tts))]) }
      
      func walk (_ restToks: ArraySlice<Input.Iterator.Element>,
                 _ restInput: Input)
        -> Consumed<[Input.Iterator.Element], Input, UserInfo> {
        if let t = restToks.first {
          let ts = restToks.dropFirst()
          if let x = restInput.first {
            let xs = restInput.dropFirst()
            if t == x { return walk(ts, xs) }
            else { return .consumed(Lazy{ .error(Lazy{ errExpect(x) }) })}
          } else {
            return .consumed(Lazy{ .error(Lazy{ errEof }) })
          }
        } else {
          let newPos = nextPosition(state.pos, tts)
          let newState = State(restInput, newPos, state.user)
          return .consumed(Lazy{ .ok(tts, newState, Lazy{ unknownError(newState) }) })
        }
      }

      if let x = state.input.first {
        let xs = state.input.dropFirst()
        if tok == x { return walk(toks, xs) }
        else { return .empty(.error(Lazy{ errExpect(x) }))}
      } else {
        return .empty(.error(Lazy{ errEof }))
      }
    }}
  } else {
    return {{ state in .empty(.ok([], state, Lazy{ unknownError(state) })) }}
  }
}

/**
    The parser `tokenPrim(showTok, nextPos, testTok)` accepts a token `t`
    with result `x` when the function `testTok(t)` returns `.some(x)`. The
    token can be shown using `showTok(t)`. The position of the *next*
    token should be returned when `nextPos` is called with the current
    source position `pos`, the current token `t` and the rest of the
    tokens `toks`, `nextPos(pos, t, toks)`.

    This is the most primitive combinator for accepting tokens. For
    example, the `char` parser could be implemented as:

        func char<Character, c: Collection> (c: Character) -> Parser<Character, c>
          where c.Iterator.Element == Character
        {
          let showChar = { x: Character in "\"\(x)\"" }
          let testChar = { x: Character in if x == c { return x } else { return nil } }
          let nextPos = { pos: SourcePos, x: Character, xs: c in updatePos(pos, x) }
          return tokenPrim(showChar, nextPos, testChar)
        }
*/
public func tokenPrim<Result, Input: Collection, UserInfo>
  (_ showToken: @escaping (Input.Iterator.Element) -> String,
   _ nextPosition: @escaping (SourcePos, Input.Iterator.Element, Input) -> SourcePos,
   _ test: @escaping (Input.Iterator.Element) -> Result?)
  -> UserParserClosure<Result, Input, UserInfo>
  where Input.SubSequence == Input {
    
  return {{ state in
    if let head = state.input.first, let x = test(head) {
      let tail = state.input.dropFirst()
      let newPos = nextPosition(state.pos, head, tail)
      let newState = State(tail, newPos, state.user)
      return .consumed(Lazy{ .ok(x, newState, Lazy{ unknownError(newState) }) })
    } else if let head = state.input.first {
      return .empty(sysUnExpectError(showToken(head), state.pos))
    } else {
      return .empty(sysUnExpectError("", state.pos))
    }
  }}
}

/**
    `many(p)` applies the parser `p` *zero* or more times. Returns an
    array of the returned values of `p`.

        func identifier () -> StringParser<String> {
          return ( letter >>- { c in
            many(alphaNum <|> char("_")) >>- { cs in
              return create(String(c) + String(cs))
            }
          } )()
        }
*/
public func many<Result, Input, UserInfo>
  (_ p: @escaping UserParserClosure<Result, Input, UserInfo>)
  -> UserParserClosure<[Result], Input, UserInfo> {
  return manyAccum(append, p)
}

func append<Result> (_ next: Result, _ list: [Result]) -> [Result] {
  return list + [next]
}

/**
    `skipMany(p)` applies the parser `p` *zero* or more times, skipping
    its result.

        func spaces<c: Collection> () -> Parser<(), c> {
          return skipMany(space)()
        }
*/
public func skipMany<Result, Input, UserInfo>
  (_ p: @escaping UserParserClosure<Result, Input, UserInfo>)
  -> UserParserClosure<(), Input, UserInfo> {
  return manyAccum({ _, _ in [] }, p) >>> create(())
}

public func manyAccum<Result, Input, UserInfo>
  (_ acc: @escaping (Result, [Result]) -> [Result],
   _ p: @escaping UserParserClosure<Result, Input, UserInfo>)
  -> UserParserClosure<[Result], Input, UserInfo> {
    
  let msg = "Parsec many: combinator 'many' is applied to a parser that accepts an empty string."
  func walk (_ xs: [Result], _ x: Result, _ state: State<Input, UserInfo>) -> Consumed<[Result], Input, UserInfo> {
    switch p()(state) {
    case let .consumed(reply):
      switch reply.value {
      case let .error(err): return .consumed(Lazy{ .error(err) })
      case let .ok(y, st, _): return walk(acc(x, xs), y, st)
      }
    case let .empty(reply):
      switch reply {
      case let .error(err): return .consumed(Lazy{ .ok(acc(x, xs), state, err) })
      case .ok: fatalError(msg)
      }
    }
  }
  return {{ state in
    switch p()(state) {
    case let .consumed(reply):
      switch reply.value {
      case let .error(err): return .consumed(Lazy{ .error(err) })
      case let .ok(x, st, _): return walk([], x, st)
      }
    case let .empty(reply):
      switch reply {
      case let .error(err): return .empty(.ok([], state, err))
      case .ok: fatalError(msg)
      }
    }
  }}
}

public func runP<Result, Input, UserInfo>
  (_ p: UserParserClosure<Result, Input, UserInfo>,
   _ user: UserInfo,
   _ name: String,
   _ input: Input)
  -> Either<ParseError, Result> {
  switch p()(State(input, SourcePos(name), user)) {
  case let .consumed(reply):
    switch reply.value {
    case let .ok(x, _, _): return .right(x)
    case let .error(err): return .left(err.value)
    }
  case let .empty(reply):
    switch reply {
    case let .ok(x, _, _): return .right(x)
    case let .error(err): return .left(err.value)
    }
  }
}

/**
    The most general way to run a parser. `runParser(p, filePath, input)`
    runs parser `p` on the input list of tokens `input`,
    obtained from source `filePath`.
    The `filePath` is only used in error messages and may be the empty
    string. Returns either a 'ParseError' ('left') or a
    value of type `a` ('right').

        func parseFromFile<a, c: Collection> (_ p: Parser<a, c>, _ fileUrl: String) -> Either<ParseError, a> {
          let input = String(contentsOf: fileUrl)
          return runParser(p, fileUrl, input)
        }
*/
public func runParser<Result, Input, UserInfo>
  (_ p: UserParserClosure<Result, Input, UserInfo>,
   _ user: UserInfo,
   _ name: String,
   _ input: Input)
  -> Either<ParseError, Result> {
  return runP(p, user, name, input)
}

/**
    `parse(p, filePath, input)` runs a parser `p`.
    The `filePath` is only used in error messages and may be the
    empty string. Returns either a 'ParseError' ('left')
    or a value of type `a` ('right').

        func main () {
          switch parse(numbers, "", "11, 2, 43") {
          case let .left(err): print(err)
          case let .right(xs): print(xs.reduce(0, combine: +))
          }
        }

        func numbers<c: Collection> () -> Parser<[Int], c> {
          return commaSep(integer)()
        }
*/
public func parse<Result, Input, UserInfo>
  (_ p: UserParserClosure<Result, Input, UserInfo>,
   _ user: UserInfo,
   _ name: String,
   _ input: Input)
  -> Either<ParseError, Result> {
  return runP(p, user, name, input)
}

public func parse<Result, Input>
  (_ p: ParserClosure<Result, Input>,
   _ name: String,
   _ input: Input)
  -> Either<ParseError, Result> {
  return parse(p, (), name, input)
}

public func parseTest<Result, Input, UserInfo>
  (_ p: UserParserClosure<Result, Input, UserInfo>,
   _ user: UserInfo,
   _ input: Input) {
  switch parse(p, user, "", input) {
  case let .left(err): print(err)
  case let .right(x): print(x)
  }
}

public func parseTest<Result, Input>
  (_ p: ParserClosure<Result, Input>,
   _ input: Input) {
  return parseTest(p, (), input)
}

/**
    Returns the current source position. See also 'SourcePos'.
*/
public func getPosition<Input, UserInfo>
  ()
  -> UserParser<SourcePos, Input, UserInfo> {
  return (getParserState >>- { state in create(state.pos) })()
}

/**
    Returns the current input.
*/
public func getInput<Input: Collection, UserInfo>
  ()
  -> UserParser<Input, Input, UserInfo> {
  return (getParserState >>- { state in create(state.input) })()
}

/**
    `setPosition(pos)` sets the current source position to `pos`.
*/
public func setPosition<Input: Collection, UserInfo>
  (_ pos: SourcePos)
  -> UserParserClosure<(), Input, UserInfo> {
  return updateParserState { state in State(state.input, pos, state.user) } >>> create(())
}

/**
    `setInput(input)` continues parsing with `input`. The 'getInput' and
    `setInput` functions can for example be used to deal with #include
    files.
*/
public func setInput<Input: Collection, UserInfo>
  (_ input: Input)
  -> UserParserClosure<(), Input, UserInfo> {
  return updateParserState { state in State(input, state.pos, state.user) } >>> create(())
}

/**
    Returns the full parser state as a 'State' record.
*/
public func getParserState<Input: Collection, UserInfo>
  ()
  -> UserParser<State<Input, UserInfo>, Input, UserInfo> {
  return (updateParserState { state in state })()
}

/**
    `setParserState(state)` set the full parser state to `state`.
*/
public func setParserState<Input, UserInfo>
  (_ state: State<Input, UserInfo>)
  -> UserParserClosure<State<Input, UserInfo>, Input, UserInfo> {
  return updateParserState { _ in state }
}

/**
    `updateParserState(f)` applies function `f` to the parser state.
*/
public func updateParserState<Input, UserInfo>
  (_ f: @escaping (State<Input, UserInfo>) -> State<Input, UserInfo>)
  -> UserParserClosure<State<Input, UserInfo>, Input, UserInfo> {
  return {{ state in
    let newState = f(state)
    return .empty(.ok(newState, newState, Lazy{ unknownError(newState) }))
  }}
}

/**
    Returns the current user state.
*/
public func getState<Input: Collection, UserInfo>
  ()
  -> UserParser<UserInfo, Input, UserInfo> {
  return (getParserState >>- { state in create(state.user)})()
}

/**
    `putState(state)` set the user state to `state`.
*/
public func putState<Input:Collection, UserInfo>
  (_ user: UserInfo)
  -> UserParserClosure<(), Input, UserInfo> {
  return updateParserState { state in State(state.input, state.pos, user) } >>> create(())
}

/**
    `modifyState(f)` applies function `f` to the user state. Suppose
    that we want to count identifiers in a source, we could use the user
    state as:

        let expr = identifier >>- { x in
          modifyState { $0 + 1 }
          return create(x)
        }
*/
public func modifyState<Input: Collection, UserInfo>
  (_ f: @escaping (UserInfo) -> UserInfo)
  -> UserParserClosure<(), Input, UserInfo> {
  return updateParserState { state in State(state.input, state.pos, f(state.user)) } >>> create(())
}


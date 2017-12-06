/**
    `StringParser<a>` is an alias for `Parser<a, String.CharacterView>`.
*/
public typealias StringParser<Result, Str: StringProtocol>
  = (State<Str, ()>) -> Consumed<Result, Str, ()>

public typealias StringParserClosure<Result, Str: StringProtocol>
  = () -> (State<Str, ()>) -> Consumed<Result, Str, ()>

public typealias StringUserParser<Result, Str: StringProtocol, UserInfo>
  = (State<Str, UserInfo>) -> Consumed<Result, Str, UserInfo>

public typealias StringUserParserClosure<Result, Str: StringProtocol, UserInfo>
  = () -> (State<Str, UserInfo>) -> Consumed<Result, Str, UserInfo>

/**
    `parse(p, file: filePath)` runs a string parser `p` on the
    input read from `filePath` using 'String(contentsOfFile: filePath)'.
    Returns either a 'ParseError' ('left') or a value of type `a` ('right').

    func main () {
      let result = try! parse(numbers(), file: "digits.txt")
      switch result {
      case let .left(err): print(err)
      case let .right(xs): print(sum(xs))
      }
    }
*/
public func parse<Result, Input, UserInfo>
  (_ p: UserParserClosure<Result, Input, UserInfo>,
   _ user: UserInfo,
   contentsOfFile file: String) throws
  -> Either<ParseError, Result> {
  let contents = try String(contentsOfFile: file)
  return parse(p, user, file, contents as! Input)
}

public func parse<Result, Input>
  (_ p: ParserClosure<Result, Input>,
   contentsOfFile file: String) throws
  -> Either<ParseError, Result> {
  let contents = try String(contentsOfFile: file)
  return parse(p, file, contents as! Input)
}

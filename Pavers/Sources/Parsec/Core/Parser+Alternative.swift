import PaversFRP

extension Parser {
  public func or(_ other: Parser<Result>) -> () -> Parser<Result> {
    return {Parser<Result> { self.run($0) ?? other.run($0)}}
  }
}
infix operator .|. : RunesAlternativePrecedence
public func .|. <A> (lhs: @escaping () -> Parser<A>, rhs: @escaping () -> Parser<A>)
  -> () -> Parser<A> {
    return {Parser<A> { lhs().run($0) ?? rhs().run($0)}}
}

import PaversFRP
public func .|. <A> (lhs: @escaping () -> Parser<A>, rhs: @escaping () -> Parser<A>)
  -> () -> Parser<A> {
    return {Parser<A> { lhs().run($0) ?? rhs().run($0)}}
}

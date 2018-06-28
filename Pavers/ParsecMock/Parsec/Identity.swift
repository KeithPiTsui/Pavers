//
//  Identity.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/28.
//  Copyright © 2018 Keith. All rights reserved.
//

public struct Identity<A> {
  public let a: A
}

public struct IdentityTypeConstructor {
  fileprivate let a: Any
  init<A>(_ a: A) { self.a = a}
}

extension Identity: TypeConstructor {
  public typealias HighKindedType = IdentityTypeConstructor
  public var typeAbstraction: TypeAbstraction<HighKindedType, A> {
    return TypeAbstraction<HighKindedType, A>(typeContructor: HighKindedType(self))
  }
  public static func typeUnapply(_ typeApplication: TypeAbstraction<HighKindedType, A>) -> Identity {
    return typeApplication.typeContructor.a as! Identity<A>
  }
}

extension Identity: Functor {
  public static func fmap<B>(f: (A) -> B, fa: TypeAbstraction<HighKindedType, A>) -> TypeAbstraction<HighKindedType, B> {
    return Identity<B>(a: f(Identity<A>.typeUnapply(fa).a)).typeAbstraction
  }
}

extension Identity: Applicative {
  
  public static func pure(a: A) -> TypeAbstraction<HighKindedType, A> {
    return Identity<A>(a: a).typeAbstraction
  }
  
  public static func apply<B>(f: TypeAbstraction<HighKindedType, (A) -> B>, fa: TypeAbstraction<HighKindedType, A>)
    -> TypeAbstraction<HighKindedType, B> {
      let f_ = Identity<(A) -> B>.typeUnapply(f)
      let fa_ = Identity<A>.typeUnapply(fa)
      let fb_ = f_.a(fa_.a)
      return Identity<B>(a:fb_).typeAbstraction
      
  }
}

extension Identity: Monad {
  public static func bind<B>
    (ma: TypeAbstraction<HighKindedType, A>, f: (A) -> TypeAbstraction<HighKindedType, B>)
    -> TypeAbstraction<HighKindedType, B> {
      return f(Identity<A>.typeUnapply(ma).a)
  }
}

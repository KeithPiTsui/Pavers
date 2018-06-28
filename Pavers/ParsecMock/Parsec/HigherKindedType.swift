//
//  HigherKindedType.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/28.
//  Copyright © 2018 Keith. All rights reserved.
//

import PaversFRP

/// * -> *
public struct TypeAbstraction <HighKindedType, A> {
  let typeContructor: HighKindedType
}

/// A protocol all type constructors must conform to.
/// * -> *
public protocol TypeConstructor {
  /// The existential type that erases `Argument`.
  /// This should only be initializable with values of types created by the current constructor.
  associatedtype HighKindedType
  /// The argument that is currently applied to the type constructor in `Self`.
  associatedtype A
  
  var typeAbstraction: TypeAbstraction<HighKindedType, A> { get }
  static func typeUnapply(_ apply: TypeAbstraction<HighKindedType, A>) -> Self
}

/// fmap :: (a -> b) -> f a -> f b
public protocol Functor: TypeConstructor {
   static func fmap<B>(f: (A) -> B, fa: TypeAbstraction<HighKindedType, A>) -> TypeAbstraction<HighKindedType, B>
//  func fmap<B>(f: (A) -> B) -> TypeApplication<HighKindedType, B>
}

/// pure :: a -> f a
/// apply :: f (a -> b) -> f a -> f b
public protocol Applicative: Functor {
  static func pure(a: A) -> TypeAbstraction<HighKindedType, A>
  
  static func apply<B>(f: TypeAbstraction<HighKindedType, (A) -> B>, fa: TypeAbstraction<HighKindedType, A>)
    -> TypeAbstraction<HighKindedType, B>
}
/// return :: a -> m a
/// bind :: m a -> (a -> m b) -> m b
public protocol Monad: Applicative {
  static var `return`: (A) -> TypeAbstraction<HighKindedType, A> {get}
  static func bind<B>
    (ma: TypeAbstraction<HighKindedType, A>, f: (A) -> TypeAbstraction<HighKindedType, B>)
    -> TypeAbstraction<HighKindedType, B>
}

extension Monad {
  public static var `return`: (A) -> TypeAbstraction<HighKindedType, A> {return pure}
}

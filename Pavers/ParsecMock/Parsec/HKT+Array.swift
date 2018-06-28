//
//  HKT+Array.swift
//  ParsecMock
//
//  Created by Keith on 2018/6/28.
//  Copyright © 2018 Keith. All rights reserved.
//

public struct ArrayTypeConstructor {
  fileprivate let content: Any
  init<T>(_ array: [T]) { self.content = array}
}

extension Array: TypeConstructor {
  public typealias HighKindedType = ArrayTypeConstructor
  public var typeAbstraction: TypeAbstraction<HighKindedType, Element> {
    return TypeAbstraction<HighKindedType, Element>(typeContructor: ArrayTypeConstructor(self))
  }
  public static func typeUnapply(_ typeApplication: TypeAbstraction<HighKindedType, Element>) -> Array {
    return typeApplication.typeContructor.content as! Array<Element>
  }
}

extension Array: Functor {
  public static func fmap<B>(f: (Element) -> B, fa: TypeAbstraction<HighKindedType, Element>) -> TypeAbstraction<HighKindedType, B> {
    return typeUnapply(fa).map(f).typeAbstraction
  }
}

extension Array: Applicative {
  public static func pure(a: Element) -> TypeAbstraction<HighKindedType, Element> {
    return [a].typeAbstraction
  }
  
  public static func apply<B>(f: TypeAbstraction<ArrayTypeConstructor, (Element) -> B>, fa: TypeAbstraction<ArrayTypeConstructor, Element>)
    -> TypeAbstraction<ArrayTypeConstructor, B> {
      let fs = Array<(Element) -> B>.typeUnapply(f)
      let fas = Array<Element>.typeUnapply(fa)
      let fbs = fs.flatMap{ fas.map($0) }
      return fbs.typeAbstraction
  }
}

extension Array: Monad {
  public static func bind<B>
    (ma: TypeAbstraction<ArrayTypeConstructor, Element>, f: (Element) -> TypeAbstraction<ArrayTypeConstructor, B>)
    -> TypeAbstraction<ArrayTypeConstructor, B> {
      return typeUnapply(ma).map(f).flatMap{Array<B>.typeUnapply($0)}.typeAbstraction
  }
}

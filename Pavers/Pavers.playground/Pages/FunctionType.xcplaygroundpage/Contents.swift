//: [Previous](@previous)

//func fx() -> (Void) {print("xx")}
//func fx2() -> () {print("xx")}
//func fx3() {print("xx")}
//func fx4() -> Void {print("xx")}
//func fx5() -> (()) {print("xx")}
//func fx6() -> ((())) {print("xx")}
//
//fx()
//type(of: fx) == type(of: fx2)
//type(of: fx2) == type(of: fx3)
//type(of: fx3) == type(of: fx4)
//type(of: fx4) == type(of: fx5)
//type(of: fx5) == type(of: fx6)
//
//type(of: fx6)
//
//type(of: ()) == type(of: (()))
//type(of: ()) == Void.self
//type(of: (())) == Void.self
//type(of: Void.self)

struct Unit {}
extension Unit: Equatable{}
let unit = Unit()
let unit2 = Unit()
unit == unit2

func unitify<T>(_ f: @escaping () -> T) -> (Unit) -> T {
  return { _ in f()}
}
func fx () -> () { print("fx") }
func fx2 (_ i:Void) -> () { print("fx2") }
type(of: fx) == type(of: fx2)
type(of: f) == type(of: f2)
let f = unitify(fx)
let f2 = unitify(fx2)
f(unit)
f2(unit)


//: [Next](@next)

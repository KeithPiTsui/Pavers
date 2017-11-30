import PaversFRP
import PaversParsec

let digit = character { CharacterSet.decimalDigits.contains($0)}

let integer = digit.many.map {Int(String($0))!}

let multiplication1 = curry({$0 * ($1 ?? 1)})
  <^> integer
  <*> (character{$0 == "*"} *> integer).optional

multiplication1.run("2*12")

let multiplication = curry({$0 * ($1 ?? 1)})
  <^> integer
  <*> (character{$0 == "*"} *> integer).optional

let division = curry({ $0 / ($1 ?? 1) })
  <^> multiplication
  <*> (character{$0 == "/"} *> multiplication).optional

let addition = curry({ $0 + ($1 ?? 0) })
  <^> division
  <*> (character{$0 == "+"} *> division).optional

let minus = curry({ $0 - ($1 ?? 0) })
  <^> addition
  <*> (character{$0 == "-"} *> addition).optional

let expression = minus

expression.run("2*3+4*6/2-10")
multiplication.run("2")


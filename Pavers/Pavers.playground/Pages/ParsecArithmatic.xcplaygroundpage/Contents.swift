import PaversFRP
import PaversParsec

let digit = character { CharacterSet.decimalDigits.contains($0)}

let decimals = digit.many
let decimalPoint = character{$0 == "."}

let fp = (decimals >>> (decimalPoint >>> decimals).optional).map { (args) -> Double in
  let (first, second) = args
  var values: [Character] = first
  if let s = second {
    values += [s.0] + s.1
  }
  let str = String(values)
  return Double(str)!
}

let multiplication = curry({$0 * ($1 ?? 1)})
  <^> fp
  <*> (character{$0 == "*"} *> fp).optional

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

expression.run("2.4*2.1/3+1-10/2+5")


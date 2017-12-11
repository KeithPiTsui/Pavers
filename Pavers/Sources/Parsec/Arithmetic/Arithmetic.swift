import PaversFRP

//    Expression = ['-'] Term { ( '+' | '-' ) Term }.
//    Term = Subterm | { ( '*' | '/' ) Subterm }.
//    Subterm = Factor | { ( powerroot | power ) Factor | production | percentage }.
//    Factor = number | preanser | '(' Expression ')' | Function | variable .
//    Function = functionIdentifier [ '(' ParameterList ')' ].
//    ParameterList = Expression { ',' | Expression } | Null.

let div_mul = divs .|. muls
let add_min = adds .|. mins
let decimals = digit.+


func number()
    -> () -> Parser<String, Double> {
        return {(
            { (first, second) -> Double in
                var values: [Character] = first
                if let s = second { values += [s.0] + s.1 }
                return Double(String(values))!
                }
                <^> (decimals >>> (decimalPoint >>> decimals).?)
            )()}
}

func term()
  -> () -> Parser<String, Double> {
    return {(curry({ $1.reduce($0) { (acc, opNumber) in
    let op = opNumber.0
    let num = opNumber.1
    if op == "*" {return acc * num}
    else if op == "/" {return acc / num}
    else {fatalError("operator error within mul&div:\(op)")}}})
    <^> subterm()
        <*> (div_mul >>> subterm()).*)()}
}

func expression()
  -> () -> Parser<String, Double> {
    return {(curry({ $1.reduce($0) { (acc, opNumber) in
    let op = opNumber.0
    let num = opNumber.1
    if op == "+" {return acc + num}
    else if op == "-" {return acc - num}
    else {fatalError("operator error within mul&div:\(op)")}}})
    <^> term()
        <*> (add_min >>> term()).*)()}
}

func subExpression()
  -> () -> Parser<String, Double> {
    return {(leftParenthesis *> expression() <* rightParenthesis)()}
}

func percent() -> () -> Parser<String, Double> {
  return {({(n, _) in n / 100} <^> (factor() >>> pcts))()}
}

func factorial() -> () -> Parser<String, Double> {
  return {({(n, _) in Double(Int(n))} <^> (factor() >>> ftrs))()}
}

//    Subterm = Factor | { ( powerroot | power ) Factor | production | percentage }.
func subterm()
  -> () -> Parser<String, Double> {
    let x = factor() >>> (pcts .|. ftrs).?
    let f = {(n: Double, op: Character?) -> Double in
      if op == "%" {return n / 100}
      else if op == "!" {return Double(Int(n))}
      else {return n}
    }
    
    let y = factor() >>> ((pows .|. pwrs) >>> factor()).?
    let g = { (n: Double, opNum: (Character, Double)?) -> Double in
      if let (op, num) = opNum {
        if op == "^" {return pow(n, num)}
        else if op == "<" {return pow(num, 1/n)}
        else {fatalError("no corresponding symbol")}
      } else {
        return n
      }
    }
    return (g <^> y) .|. (f <^> x)
}

//    Factor = number | '(' Expression ')' | Function | variable | preanser.
func factor()
  -> () -> Parser<String, Double> {
    return {(subExpression() .|. number())()}
}

public let arithmetic = expression()
public let subexpression = subExpression()







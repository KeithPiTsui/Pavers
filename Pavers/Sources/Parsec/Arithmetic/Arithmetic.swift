import PaversFRP

//    Expression = ['-'] Term { ( '+' | '-' ) Term }.
//    Term = number | { ( '*' | '/' ) number }.
//    Term1 = Factor | { ( powerroot | power ) Factor | production | percentage }.
//    Factor = number | preanser | '(' Expression ')' | Function | variable .
//    Function = functionIdentifier [ '(' ParameterList ')' ].
//    ParameterList = Expression { ',' | Expression } | Null.

let muls = character{$0 == "*"}
let divs = character{$0 == "/"}
let adds = character{$0 == "+"}
let mins = character{$0 == "-"}
let leftParenthesis = character{$0 == "("}
let rightParenthesis = character{$0 == ")"}
let div_mul = divs .|. muls
let add_min = adds .|. mins

let digit = character(CharacterSet.decimalDigits.contains)

let decimals = digit.+
let decimalPoint = character{$0 == "."}

func number()
    -> () -> Parser<Double> {
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
  -> () -> Parser<Double> {
    return {(curry({ $1.reduce($0) { (acc, opNumber) in
    let op = opNumber.0
    let num = opNumber.1
    if op == "*" {return acc * num}
    else if op == "/" {return acc / num}
    else {fatalError("operator error within mul&div:\(op)")}}})
    <^> factor()
        <*> (div_mul >>> factor()).*)()}
}

func expression()
  -> () -> Parser<Double> {
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
  -> () -> Parser<Double> {
  print("\(#function)")
    return {(leftParenthesis *> expression() <* rightParenthesis)()}
}

func factor()
  -> () -> Parser<Double> {
  print("\(#function)")
    return {(number() .|. subExpression())()}
}

public let arithmetic = expression()
public let subexpression = subExpression()







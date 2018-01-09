//
//  PrimitiveParsers.swift
//  PaversParsec
//
//  Created by Keith on 11/12/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversFRP

let alphanumerics = character(CharacterSet.alphanumerics.contains)
let at = character{$0=="@"}
let period = character{$0=="."}
let pwrs = character{$0 == "<"}
let pows = character{$0 == "^"}
let ftrs = character{$0 == "!"}
let pcts = character{$0 == "%"}
let muls = character{$0 == "*"}
let divs = character{$0 == "/"}
let adds = character{$0 == "+"}
let mins = character{$0 == "-"}
let leftParenthesis = character{$0 == "("}
let rightParenthesis = character{$0 == ")"}
let digit = character(CharacterSet.decimalDigits.contains)
let digitOne = character{$0 == "1"}
let decimalPoint = character{$0 == "."}

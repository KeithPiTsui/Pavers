//
//  CommonRegularExpression.swift
//  PaversParsec
//
//  Created by Keith on 11/12/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import PaversFRP

let name = alphanumerics.+
public let email = name >>> at >>> name >>> (period >>> name).+
public let phoneNumber = digitOne >>> digit().times(10)

let exps = character{$0=="E"}

let digits = digit.+
let optFraction = (period >>> digits).?
let optExponent = (exps >>> (adds .|. mins).? >>> digits).?
public let num = digits >>> optFraction >>> optExponent

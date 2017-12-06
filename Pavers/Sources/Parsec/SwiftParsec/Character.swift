/*
    Commonly used character parsers.
*/

/**
    `oneOf(s)` succeeds if the current character is in the supplied
    string `s`. Returns the parsed character. See also
    'satisfy'.

        func vowel () -> StringParser<Character> {
          return oneOf("aeiou")()
        }
*/
public func oneOf<Input: Collection, UserInfo>
  (_ s: String)
  -> UserParserClosure<Character, Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
  return character(s.contains)
}

/**
    As the dual of 'oneOf', `noneOf(s)` succeeds if the current
    character is *not* in the supplied string `s`. Returns the
    parsed character.

        func consonant () -> StringParser<Character> {
          return noneOf("aeiou")()
        }
*/
public func noneOf<Input: Collection, UserInfo>
  (_ s: String)
  -> UserParserClosure<Character, Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
  return character(s.uncontains)
}

/**
    Skips *zero* or more white space characters. See also 'skipMany'.
*/
public func spaces<Input: Collection, UserInfo>
  ()
  -> UserParser<(), Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
  return (skipMany(space) <?> "white space")()
}

/**
    Parses a white space character (any character which satisfies 'isSpace').
    Returns the parsed character.
*/
public func space<Input: Collection, UserInfo>
  ()
  -> UserParser<Character, Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
    return (character{$0.isSpace} <?> "space")()
}

/**
    Parses a newline character ('\n'). Returns a newline character.
*/
public func newline<Input: Collection, UserInfo>
  () -> UserParser<Character, Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
  return (char("\n") <?> "lf new-line")()
}

/**
    Parses a carriage return character ('\r') followed by a newline character ('\n').
    Returns a newline character.
*/
public func crlf<Input: Collection, UserInfo>
  ()
  -> UserParser<Character, Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
  return (char("\r\n") >>> create("\n") <?> "crlf new-line")()
}

/**
    Parses a CRLF (see 'crlf') or LF (see 'newline') end-of-line.
    Returns a newline character ('\n').
*/
public func endOfLine<Input: Collection, UserInfo>
  ()
  -> UserParser<Character, Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
  return (newline <|> crlf <?> "new-line")()
}

/**
    Parses a tab character ('\t'). Returns a tab character.
*/
public func tab<Input: Collection, UserInfo>
  ()
  -> UserParser<Character, Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
  return (char("\t") <?> "tab")()
}

/**
    Parses an upper case letter (a character between 'A' and 'Z').
    Returns the parsed character.
*/
public func upper<Input: Collection, UserInfo>
  ()
  -> UserParser<Character, Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
  return (character{$0.isUpper} <?> "uppercase letter")()
}

/**
    Parses a lower case character (a character between 'a' and 'z').
    Returns the parsed character.
*/
public func lower<Input: Collection, UserInfo>
  ()
  -> UserParser<Character, Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
  return (character{$0.isLower} <?> "lowercase letter")()
}

/**
    Parses a letter or digit (a character between '0' and '9').
    Returns the parsed character.
*/
public func alphaNum<Input: Collection, UserInfo>
  ()
  -> UserParser<Character, Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
  return (character{$0.isAlphaNum} <?> "letter or digit")()
}

/**
    Parses a letter (an upper case or lower case character). Returns the
    parsed character.
*/
public func letter<Input: Collection, UserInfo>
  ()
  -> UserParser<Character, Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
  return (character{$0.isLetter} <?> "letter")()
}

/**
    Parses a digit. Returns the parsed character.
*/
public func decimalDigit<Input: Collection, UserInfo>
  ()
  -> UserParser<Character, Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
  return (character{$0.isDigit} <?> "digit")()
}

/**
    Parses a hexadecimal digit (a digit or a letter between 'a' and
    'f' or 'A' and 'F'). Returns the parsed character.
*/
public func hexDigit<Input: Collection, UserInfo>
  ()
  -> UserParser<Character, Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
  return (character{$0.isHexDigit} <?> "hexadecimal digit")()
}

/**
    Parses an octal digit (a character between '0' and '7'). Returns
    the parsed character.
*/
public func octDigit<Input: Collection, UserInfo>
  ()
  -> UserParser<Character, Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
    return (character{$0.isOctDigit} <?> "octal digit")()
}

/**
    `char(c)` parses a single character `c`. Returns the parsed
    character (i.e. `c`).

        func semiColon () -> StringParser<Character> {
          return char(";")()
        }
*/
public func char<Input: Collection, UserInfo>
  (_ c: Character)
  -> UserParserClosure<Character, Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
  return character { $0 == c } <?> String(c)
}

/**
    This parser succeeds for any character. Returns the parsed character.
*/
public func anyChar<Input: Collection, UserInfo>
  ()
  -> UserParser<Character, Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
  return (character { _ in true })()
}

/**
    The parser `satisfy(f)` succeeds for any character for which the
    supplied function `f` returns 'true'. Returns the character that is
    actually parsed.

        func digit () -> StringParser<Character> {
          return satisfy(isDigit)()
        }
*/
public func character<Input: Collection, UserInfo>
  (_ f: @escaping (Character) -> Bool)
  -> UserParserClosure<Character, Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
    let next = { (_ pos: SourcePos, _ c: Character, _ cs: Input) in pos.updating(by: c) }
    return tokenPrim(String.init, next, {f($0) ? $0 : nil})
}

/**
    `string(s)` parses a string given by `s`. Returns
    the parsed string (i.e. `s`).

        func divOrMod () -> StringParser<String> {
          return ( string("div") <|> string("mod") )()
        }
*/
public func string<Input: Collection, UserInfo>
  (_ s: String)
  -> UserParserClosure<String, Input, UserInfo>
  where Input.SubSequence == Input, Input.Iterator.Element == Character {
    let show = {(_ cs: [Character]) -> String in String(cs)}
    let next = {(_ pos: SourcePos, _ cs: [Character]) -> SourcePos in pos.updating(by: cs)}
    return tokens(show, next, Array(s)) >>- {create(String($0))}
}

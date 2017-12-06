import Foundation

extension Character {

  var isSpace: Bool {
    guard let c = self.unicodeScalars.first else { return false }
    return CharacterSet.whitespacesAndNewlines.contains(c)
  }

  var isUpper: Bool {
    guard let c = self.unicodeScalars.first else { return false }
    return CharacterSet.uppercaseLetters.contains(c)
  }

  var isLower: Bool {
    guard let c = self.unicodeScalars.first else { return false }
    return CharacterSet.lowercaseLetters.contains(c)
  }

  var isAlphaNum: Bool {
    guard let c = self.unicodeScalars.first else { return false }
    return CharacterSet.alphanumerics.contains(c)
  }

  var isLetter: Bool {
    guard let c = self.unicodeScalars.first else { return false }
    return CharacterSet.letters.contains(c)
  }

  var isDigit: Bool {
    guard let c = self.unicodeScalars.first else { return false }
    return CharacterSet.decimalDigits.contains(c)
  }

  var isHexDigit: Bool {
    guard let c = self.unicodeScalars.first else { return false }
    return CharacterSet(charactersIn: "0123456789aAbBcCdDeEfF").contains(c)
  }

  var isOctDigit: Bool {
    guard let c = self.unicodeScalars.first else { return false }
    return CharacterSet(charactersIn: "01234567").contains(c)
  }
}

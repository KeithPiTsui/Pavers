/**
    Textual source positions.
    Source positions: a file name, a line and a column
    upper left is (1,1)
*/
public struct SourcePos: CustomStringConvertible, Comparable {
  public var name: String
  public var line: Int
  public var column: Int
}

extension SourcePos {
  public init (_ name: String = "", _ line: Int = 1, _ column: Int = 1) {
    self.name = name
    self.line = line
    self.column = column
  }
  
  func lineIncreasing(by n: Int = 1) -> SourcePos {
    return SourcePos.init(self.name, self.line + 1, self.column)
  }
  
  func columnIncreasing(by n: Int = 1) -> SourcePos {
    return SourcePos.init(self.name, self.line, self.column + 1)
  }

  /**
      Updates the source position by calling `update` on every character.
  */
  func updating(by s: String) -> SourcePos {
    return s.reduce(self) { (sp, c) -> SourcePos in return sp.updating(by: c) }
  }
  
  func updating(by cs: [Character]) -> SourcePos {
    return self.updating(by: String(cs))
  }

  /**
      Update a source position given a character. If the character is a
      newline (`\n`) the line number is incremented by 1. If the character
      is a tab (`\t`) the column number is incremented to the nearest 8'th
      column. In all other cases, the column is incremented by 1.
  */
  func updating(by c: Character) -> SourcePos {
    let sp: SourcePos
    switch c {
    case "\n": sp = self.lineIncreasing()
    case "\t": sp = SourcePos.init(self.name, self.line, column + 8 - ((column - 1) % 8))
    default: sp = self.columnIncreasing()
    }
    return sp
  }

  public var description: String {
    var result = ""
    if !name.isEmpty {
      result = "\"\(name)\" "
    }
    result += "(line \(line), column \(column))"
    return result
  }
}

public func == (lhs: SourcePos, rhs: SourcePos) -> Bool {
  return lhs.line == rhs.line && lhs.column == rhs.column
}

public func < (lhs: SourcePos, rhs: SourcePos) -> Bool {
  return lhs.line < rhs.line || lhs.line == rhs.line && lhs.column < rhs.column
}

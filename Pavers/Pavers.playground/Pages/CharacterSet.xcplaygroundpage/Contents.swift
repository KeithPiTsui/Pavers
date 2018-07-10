//: [Previous](@previous)

import PaversFRP

extension NSCharacterSet {
  var characters:[String] {
    var chars = [String]()
    for plane:UInt8 in 0...16 {
      if self.hasMemberInPlane(plane) {
        let p0 = UInt32(plane) << 16
        let p1 = (UInt32(plane) + 1) << 16
        for c:UTF32Char in p0..<p1 {
          if self.longCharacterIsMember(c) {
            var c1 = c.littleEndian
            let s = NSString(bytes: &c1, length: 4, encoding: String.Encoding.utf32LittleEndian.rawValue)!
            chars.append(String(s))
          }
        }
      }
    }
    return chars
  }
}

let x = CharacterSet.alphanumerics
print(( x as NSCharacterSet).characters)
//print(UnicodeScalar.init("0")?.value)

//let ascii = CharacterSet.ascii

//: [Next](@next)

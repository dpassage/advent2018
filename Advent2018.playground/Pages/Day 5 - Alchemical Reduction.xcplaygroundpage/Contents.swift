//: [Previous](@previous)

import Foundation

// A Char represents an ASCII character.
// Useful when Unicode just pisses you off.
struct Char {
    var num: UInt8
}

extension Char: Comparable {
    static func < (lhs: Char, rhs: Char) -> Bool {
        return lhs.num < rhs.num
    }
}

extension Char: Hashable {}



let foo = "asdf".utf8

let chars = foo.map(Char.init)

//: [Next](@next)

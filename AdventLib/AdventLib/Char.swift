//
//  Char.swift
//  AdventLib
//
//  Created by David Paschich on 12/6/18.
//  Copyright © 2018 David Paschich. All rights reserved.
//

import Foundation

// A Char represents an ASCII character.
// Useful when Unicode just pisses you off.
public struct Char {
    public var num: UInt8
}

extension Char: Comparable {
    public static func < (lhs: Char, rhs: Char) -> Bool {
        return lhs.num < rhs.num
    }
}

extension Char: Hashable {}

extension Char {
    public var unicodeScalar: UnicodeScalar {
        return UnicodeScalar(num)
    }

    public var character: Character {
        return Character(unicodeScalar)
    }
}

extension Char: CustomStringConvertible {
    public var description: String {
        return "\(character)"
    }
}

extension Char {
    public var lowerCase: Char {
        if isLower {
            return Char(num: num + 32)
        } else {
            return self
        }
    }

    public var isLower: Bool {
        return (65...90).contains(num)
    }

    public var upperCase: Char {
        if isUpper {
            return Char(num: num - 32)
        } else {
            return self
        }
    }

    public var isUpper: Bool {
        return (97...122).contains(num)
    }

    public func equalsCaseInsensitive(_ other: Char) -> Bool {
        return self.upperCase == other.upperCase
    }

    public static func ~= (lhs: Char, rhs: Char) -> Bool {
        return lhs.equalsCaseInsensitive(rhs)
    }
}

extension Char: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: Character) {
        if let num = value.unicodeScalars.first.map(UInt8.init) {
            self.num = num
        } else {
            self.num = 0
        }
    }

    public typealias UnicodeScalarLiteralType = Character
}

extension Char: Strideable {
    public func distance(to other: Char) -> Int {
        return Int(other.num) - Int(self.num)
    }

    public func advanced(by n: Int) -> Char {
        return Char(num: UInt8(Int(self.num) + n))
    }

    public typealias Stride = Int
}

extension String {
    public var chars: [Char] {
        return utf8.map(Char.init)
    }

    public init(_ chars: [Char]) {
        let scalars = chars.map { $0.character }
        self.init(scalars)
    }
}

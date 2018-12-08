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

extension String {
    public var chars: [Char] {
        return utf8.map(Char.init)
    }

    public init(_ chars: [Char]) {
        let scalars = chars.map { $0.character }
        self.init(scalars)
    }
}

//
//  Array+Comparable.swift
//  AdventLib
//
//  Created by David Paschich on 12/30/18.
//  Copyright © 2018 David Paschich. All rights reserved.
//

import Foundation

extension Array: Comparable where Element: Comparable {
    public static func < (lhs: Array<Element>, rhs: Array<Element>) -> Bool {
        for (left, right) in zip(lhs, rhs) {
            if left != right { return left < right }
        }
        return lhs.count < rhs.count
    }
}

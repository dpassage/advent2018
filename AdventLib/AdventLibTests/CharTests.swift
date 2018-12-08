//
//  CharTests.swift
//  AdventLibTests
//
//  Created by David Paschich on 12/7/18.
//  Copyright © 2018 David Paschich. All rights reserved.
//

import XCTest
import AdventLib

class CharTests: XCTestCase {

    func testStrideable() {
        let letterA: Char = "A"
        let letterM: Char = "M"
        let distance = letterA.distance(to: letterM)
        let result = letterA.advanced(by: distance)
        XCTAssertEqual(result, letterM)

        let range: ClosedRange<Char> = "a" ... "z"
        XCTAssertEqual(range.count, 26)
    }
}

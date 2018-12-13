//
//  TwoWayArrayTests.swift
//  AdventLibTests
//
//  Created by David Paschich on 12/12/18.
//  Copyright © 2018 David Paschich. All rights reserved.
//

import XCTest
import AdventLib

class TwoWayArrayTests: XCTestCase {

    func testOffsetIndices() {
        let array = TwoWayArray(repeating: 0, count: 5, firstIndex: -1)
        XCTAssertEqual(array.count, 5)
        XCTAssertEqual(array.startIndex, -1)
        XCTAssertEqual(array.endIndex, 4)
        XCTAssertEqual(array[-1], 0)
    }

}

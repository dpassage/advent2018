//
//  Point.swift
//  AdventLib
//
//  Created by David Paschich on 12/23/18.
//  Copyright © 2018 David Paschich. All rights reserved.
//

import Foundation

public struct Point: CustomStringConvertible {
    public var x: Int
    public var y: Int

    public init(x: Int, y: Int) { self.x = x; self.y = y }
    public var description: String {
        return "(\(x), \(y))"
    }
}

extension Point: Hashable {}

extension Point: Comparable {
    public static func < (lhs: Point, rhs: Point) -> Bool {
        if lhs.y == rhs.y {
            return lhs.x < rhs.x
        }
        return lhs.y < rhs.y
    }
}

extension Point {
    public func adjacents() -> [Point] {
        return [
            Point(x: x - 1, y: y),
            Point(x: x + 1, y: y),
            Point(x: x, y: y + 1),
            Point(x: x, y: y - 1)
        ]
    }

    public func distance(from: Point) -> Int {
        return abs(from.x - x) + abs(from.y - y)
    }

    public static func + (lhs: Point, rhs: Point) -> Point {
        return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func - (lhs: Point, rhs: Point) -> Point {
        return Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}



extension Rect {
    public subscript(point: Point) -> Element {
        get { return self[point.x, point.y] }
        set { self[point.x, point.y] = newValue }
    }

    public func isValidIndex(_ point: Point) -> Bool {
        return (0..<width).contains(point.x) && (0..<height).contains(point.y)
    }
}

import Foundation
import AdventLib

public struct Nanobot {
    public var x: Int
    public var y: Int
    public var z: Int
    public var radius: Int

    public func distance(from other: Nanobot) -> Int {
        let xDist: Int = abs(x - other.x)
        let yDist: Int = abs(y - other.y)
        let zDist: Int = abs(z - other.z)
        return xDist + yDist + zDist
    }

    static let regex = try! Regex(pattern: "pos=<(-?\\d+),(-?\\d+),(-?\\d+)>, r=(\\d+)")

    public init?(line: String) {
        guard let matches = Nanobot.regex.match(input: line),
            matches.count >= 4,
            let x = Int(matches[0]),
            let y = Int(matches[1]),
            let z = Int(matches[2]),
            let radius = Int(matches[3]) else { return nil }
        self.x = x
        self.y = y
        self.z = z
        self.radius = radius
    }
}

public struct Coord: Hashable, CustomStringConvertible {
    public var x: Int
    public var y: Int
    public var z: Int

    public init(x: Int, y: Int, z: Int) {
        self.x = x; self.y = y; self.z = z
    }
    
    public var description: String {
        return "(\(x), \(y), \(z))"
    }
    
    public func distance(from other: Coord) -> Int {
        let first = abs(x - other.x)
        let second = abs(y - other.y)
        let third = abs(z - other.z)
        return first + second + third
    }

    public static let origin = Coord(x: 0, y: 0, z: 0)
}

extension Range where Bound == Int {
    public var middle: Int { return (lowerBound + upperBound) / 2 }
    public var lowerHalf: Range<Int> { return lowerBound..<middle }
    public var upperHalf: Range<Int> { return middle..<upperBound }
}

let billion = 1_000_000_000

public struct Cube {
    public var xRange: Range<Int>
    public var yRange: Range<Int>
    public var zRange: Range<Int> // positive z is towards the viewer

    public init(xRange: Range<Int>, yRange: Range<Int>, zRange: Range<Int>) {
        self.xRange = xRange; self.yRange = yRange; self.zRange = zRange
    }
    public static let maximal: Cube = Cube(xRange: -billion..<billion, yRange: -billion..<billion, zRange: -billion..<billion)

    public var size: Int { return max(max(xRange.count, yRange.count), zRange.count) }

    var frontRightTop: Cube { return Cube(xRange: xRange.upperHalf, yRange: yRange.upperHalf, zRange: zRange.upperHalf) }
    var frontLeftTop: Cube { return Cube(xRange: xRange.lowerHalf, yRange: yRange.upperHalf, zRange: zRange.upperHalf) }
    var backRightTop: Cube { return Cube(xRange: xRange.upperHalf, yRange: yRange.upperHalf, zRange: zRange.lowerHalf) }
    var backLeftTop: Cube { return Cube(xRange: xRange.lowerHalf, yRange: yRange.upperHalf, zRange: zRange.lowerHalf) }
    var frontRightBottom: Cube { return Cube(xRange: xRange.upperHalf, yRange: yRange.lowerHalf, zRange: zRange.upperHalf) }
    var frontLeftBottom: Cube { return Cube(xRange: xRange.lowerHalf, yRange: yRange.lowerHalf, zRange: zRange.upperHalf) }
    var backRightBottom: Cube { return Cube(xRange: xRange.upperHalf, yRange: yRange.lowerHalf, zRange: zRange.lowerHalf) }
    var backLeftBottom: Cube { return Cube(xRange: xRange.lowerHalf, yRange: yRange.lowerHalf, zRange: zRange.lowerHalf) }

    public func partition() -> [Cube] {
        return [frontRightTop, frontLeftTop,
                backRightTop, backLeftTop,
                frontRightBottom, frontLeftBottom,
                backRightBottom, backLeftBottom]
    }

    public func corners() -> [Coord] {
        guard size > 0 else { return [] }
        let frontRightTop = Coord(x: xRange.upperBound - 1, y: yRange.upperBound - 1, z: zRange.upperBound - 1)
        let frontLeftTop = Coord(x: xRange.lowerBound, y: yRange.upperBound - 1, z: zRange.upperBound - 1)
        let backRightTop = Coord(x: xRange.upperBound - 1, y: yRange.upperBound - 1, z: zRange.lowerBound)
        let backLeftTop = Coord(x: xRange.lowerBound, y: yRange.upperBound - 1, z: zRange.lowerBound)
        let frontRightBottom = Coord(x: xRange.upperBound - 1, y: yRange.lowerBound, z: zRange.upperBound - 1)
        let frontLeftBottom = Coord(x: xRange.lowerBound, y: yRange.lowerBound, z: zRange.upperBound - 1)
        let backRightBottom = Coord(x: xRange.upperBound - 1, y: yRange.lowerBound, z: zRange.lowerBound)
        let backLeftBottom = Coord(x: xRange.lowerBound, y: yRange.lowerBound, z: zRange.lowerBound)
        return [frontRightTop, frontLeftTop, backRightTop, backLeftTop, frontRightBottom, frontLeftBottom, backRightBottom, backLeftBottom]
    }

    public func contains(_ coord: Coord) -> Bool {
        return xRange.contains(coord.x) && yRange.contains(coord.y) && zRange.contains(coord.z)
    }

    public func overlaps(bot: Nanobot) -> Bool {
        let botCenter = Coord(x: bot.x, y: bot.y, z: bot.z)
        if contains(botCenter) { return true }
        for corner in corners() {
            if corner.distance(from: botCenter) <= bot.radius { return true }
        }
        return false
    }
}

extension Cube: Equatable {}

import Foundation
import AdventLib

public struct Coordinate {
    public var x: Int
    public var y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension Coordinate {
    public init?(line: String) {
        let parts = line.components(separatedBy: ", ")
        print(parts)
        guard parts.count == 2,
            let x = Int(parts[0]),
            let y = Int(parts[1]) else { return nil }
        self.x = x; self.y = y
    }

    static func - (lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        let x = lhs.x - rhs.x
        let y = lhs.y - rhs.y
        return Coordinate(x: x, y: y)
    }

    public static func + (lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        let x = lhs.x + rhs.x
        let y = lhs.y + rhs.y
        return Coordinate(x: x, y: y)
    }

    public func distance(to other: Coordinate) -> Int {
        return abs(x - other.x) + abs(y - other.y)
    }
}

public func findLargestArea(coordinates: [Coordinate]) -> Int {
    // first, we find the min and max x and y
    let minX = coordinates.map { $0.x }.min()!
    let minY = coordinates.map { $0.y }.min()!
    let maxX = coordinates.map { $0.x }.max()!
    let maxY = coordinates.map { $0.y }.max()!

    // our origin is at (minX, miny)
    let origin = Coordinate(x: minX, y: minY)
    // and the size is the difference
    let width = (maxX - minX) + 1
    let height = (maxY - minY) + 1

    var grid = Rect<Int>(width: width, height: height, defaultValue: -1)

    // filter out the ones at the edges; these would have infinite extents
    let edgeCoords = coordinates.enumerated().filter { (offset, coordinate) -> Bool in
        return coordinate.x == minX || coordinate.x == maxX || coordinate.y == minY || coordinate.y == maxY
    }

    print("edgeCoords: \(edgeCoords)")

    let edgeCoordOffsets = edgeCoords.map { $0.offset }
    // fill in the grid
    for x in 0..<grid.width {
        print(x)
        for y in 0..<grid.height {
            let normalized = Coordinate(x: x, y: y) + origin

            let distances = (coordinates.enumerated().map { (offset: $0.offset, distance: $0.element.distance(to: normalized)) })

            let sortedDistances = distances.sorted { $0.distance < $1.distance }
            if sortedDistances.count > 1 && sortedDistances[0].distance == sortedDistances[1].distance {
                continue
            }
            grid[x, y] = sortedDistances[0].offset
        }
    }

    // find the most frequent number, except -1...a

    var counts: [Int: Int] = [:]
    for x in 0..<grid.width {
        for y in 0..<grid.width {
            let offset = grid[x, y]
            if offset == -1 { continue }
            if edgeCoordOffsets.contains(offset) { continue }
            counts[offset, default: 0] += 1
        }
    }

    print(grid)
    print(counts)
    return counts.values.sorted { $0 > $1 }.first!
}

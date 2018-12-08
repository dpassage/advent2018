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

    // we want to leave a 1-cell gap around the edge
    // so the origin is 1 cell above and to the left
    let origin = Coordinate(x: minX - 1, y: minY - 1)
    // and the size is the difference, plus two
    let width = (maxX - minX) + 2
    let height = (maxY - minY) + 2

    // fill with -1
    var grid = Rect<Int>(width: width, height: height, defaultValue: -1)

    // cells on the edge are special; the closet point to them would have
    // infinite extent, and so get bucketed out.
    var edgeRegionOffsets: Set<Int> = []

    func nearestRegion(to normalized: Coordinate) -> Int? {
        let distances = (coordinates.enumerated().map { (offset: $0.offset, distance: $0.element.distance(to: normalized)) })

        let sortedDistances = distances.sorted { $0.distance < $1.distance }
        if sortedDistances.count > 1 && sortedDistances[0].distance == sortedDistances[1].distance {
            return nil
        }
        return sortedDistances[0].offset
    }

    // first we find the edge regions
    // top and bottom edges
    // fill in the grid
    for x in 0..<grid.width {
        print(x)
        for y in 0..<grid.height {
            let normalized = Coordinate(x: x, y: y) + origin
            if let nearest = nearestRegion(to: normalized) {
                // if it's an edge cell, update the edge list
                if x == 0 || x == (width - 1) || y == 0 || y == (height - 1) {
                    edgeRegionOffsets.insert(nearest)
                } else {
                    grid[x, y] = nearest
                }
            }
        }
    }

    // find the most frequent number, except -1...a

    var counts: [Int: Int] = [:]
    for x in 0..<grid.width {
        for y in 0..<grid.width {
            let offset = grid[x, y]
            if offset == -1 { continue }
            if edgeRegionOffsets.contains(offset) { continue }
            counts[offset, default: 0] += 1
        }
    }
    print(counts)
    return counts.values.sorted { $0 > $1 }.first!
}

public func sizeOfNearbyArea(coordinates: [Coordinate], limit: Int) -> Int {
    let buffer = (limit / coordinates.count) + 1
    // first, we find the min and max x and y
    let minX = coordinates.map { $0.x }.min()!
    let minY = coordinates.map { $0.y }.min()!
    let maxX = coordinates.map { $0.x }.max()!
    let maxY = coordinates.map { $0.y }.max()!

    let origin = Coordinate(x: minX - buffer, y: minY - buffer)
    // and the size is the difference, plus two
    let width = (maxX - minX) + (2 * buffer)
    let height = (maxY - minY) + (2 * buffer)

    var count = 0
    for x in 0..<width {
        for y in 0..<height {
            let normalized = Coordinate(x: x, y: y) + origin
            let totalDistance = coordinates.map { $0.distance(to: normalized) }.reduce(0, +)
            if totalDistance < limit {
                count += 1
            }
        }
    }
    return count
}


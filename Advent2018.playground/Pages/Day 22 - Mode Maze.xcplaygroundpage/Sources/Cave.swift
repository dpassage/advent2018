import Foundation
import AdventLib

extension Point {
    static let origin = Point(x: 0, y: 0)

    var west: Point { return Point(x: x - 1, y: y) }
    var east: Point { return Point(x: x + 1, y: y) }
    var north: Point { return Point(x: x, y: y - 1) }
    var south: Point { return Point(x: x, y: y + 1) }
}

class Box<T> {
    var value: T
    init(value: T) { self.value = value }
}

public struct Cave {
    var depth: Int
    var target: Point

    var erosionLevels: Box<[Point: Int]>
    public init(depth: Int, target: Point) {
        self.depth = depth
        self.target = target

        erosionLevels = Box(value: [:])
    }

    public func erosionLevel(point: Point) -> Int {
        if let memoizedLevel = erosionLevels.value[point] { return memoizedLevel }

        let geologicIndex: Int
        switch (point.x, point.y) {
        case (0, 0), (target.x, target.y): geologicIndex = 0
        case (0, _): geologicIndex = point.y * 48271
        case (_, 0): geologicIndex = point.x * 16807
        default:
            let above = erosionLevel(point: point.north)
            let left = erosionLevel(point: point.west)
            geologicIndex = above * left
        }

        let erosion = (geologicIndex + depth) % 20183
        erosionLevels.value[point] = erosion
        return erosion
    }
}

public enum Region: Int {
    case rocky = 0
    case wet = 1
    case narrow = 2

    var validTools: Set<Tool> {
        switch self {
        case .rocky: return [.climbing, .torch]
        case .wet: return [.climbing, .neither]
        case .narrow: return [.torch, .neither]
        }
    }
}

enum Tool: Int {
    case climbing
    case torch
    case neither
}

extension Cave {
    public func regionType(_ point: Point) -> Region {
        return Region(rawValue: erosionLevel(point: point) % 3)!
    }
}

extension Cave: AStar {
    public struct Node: Hashable {
        var position: Point
        var tool: Tool
    }

    public func estimatedCost(from: Node, to: Node) -> Int {
        return from.position.distance(from: to.position)
    }

    public func neighborsOf(_ node: Node) -> [(node: Node, distance: Int)] {
        let neighbors = node.position.adjacents()
            .filter { $0.x >= 0 && $0.y >= 0 }
            .filter { regionType($0).validTools.contains(node.tool) }
            .map { (node: Node(position: $0, tool: node.tool), distance: 1) }

        let tools = regionType(node.position).validTools.filter({ $0 != node.tool }).map {
            (node: Node(position: node.position, tool: $0), distance: 7)
        }

        return neighbors + tools
    }

    public func shortestPathLength() -> Int {
        let start = Node(position: .origin, tool: .torch)
        let goal = Node(position: target, tool: .torch)
        let result = aStar(from: start, to: goal)
        print(result)
        return result.cost
    }
}

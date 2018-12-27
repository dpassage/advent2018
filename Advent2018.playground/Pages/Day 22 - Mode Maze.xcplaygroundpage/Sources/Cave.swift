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

extension Cave {
    struct Node: Hashable {
        var position: Point
        var tool: Tool
    }

    func reconstructPath(cameFrom: [Node: Node], current: Node) -> [Node] {
        var current = current
        var path = [current]
        while let nextCurrent = cameFrom[current] {
            path.append(nextCurrent)
            current = nextCurrent
        }

        return path
    }

    func estimatedCost(from: Node, to: Node) -> Int {
        return from.position.distance(from: to.position)
    }

    func neighborsOf(_ node: Node) -> [(node: Node, distance: Int)] {
        let neighbors = node.position.adjacents()
            .filter { $0.x >= 0 && $0.y >= 0 }
            .filter { regionType($0).validTools.contains(node.tool) }
            .map { (node: Node(position: $0, tool: node.tool), distance: 1) }

        let tools = regionType(node.position).validTools.filter({ $0 != node.tool }).map {
            (node: Node(position: node.position, tool: $0), distance: 7)
        }

        return neighbors + tools
    }

    func aStar(from start: Node, to goal: Node) -> (path: [Node], cost: Int) {
        var closedSet: Set<Node> = []
        var cameFrom: [Node: Node] = [:]
        var gScore: [Node: Int] = [start: 0]

        var heap = Heap<(node: Node, fScore: Int)>(priorityFunction: { $0.fScore < $1.fScore })

        heap.enqueue((node: start, fScore: estimatedCost(from: start, to: goal)))

        while let current = heap.dequeue()?.node {
            if current == goal {
                let path = reconstructPath(cameFrom: cameFrom, current: current)
                let score = gScore[current, default: Int.max]
                return (path, score)
            }
            closedSet.insert(current)

            for (neighbor, distance) in neighborsOf(current) {
                if closedSet.contains(neighbor) { continue }
                let tentativeScore = gScore[current, default: Int.max] + distance
                if tentativeScore > gScore[neighbor, default: Int.max] {
                    continue
                }
                cameFrom[neighbor] = current
                gScore[neighbor] = tentativeScore
                heap.enqueue((node: neighbor, fScore: tentativeScore + estimatedCost(from: neighbor, to: goal)))
            }
        }
        return (path: [], cost: -1)
    }
    public func shortestPathLength() -> Int {
        let start = Node(position: .origin, tool: .torch)
        let goal = Node(position: target, tool: .torch)
        let result = aStar(from: start, to: goal)
        print(result)
        return result.cost
    }
}

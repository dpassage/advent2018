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

    var erosionLevels: Box<Rect<Int>>
    public init(depth: Int, target: Point) {
        self.depth = depth
        self.target = target

        // we build it much bigger than the rectangle because paths my run past the target and come back.
        let levelsRect = Rect(width: target.x * 2, height: target.y * 2, defaultValue: -1)
        erosionLevels = Box(value: levelsRect)
    }

    public func erosionLevel(point: Point) -> Int {
        if erosionLevels.value[point] != -1 { return erosionLevels.value[point] }

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

    struct Path {
        var nodes: [Node]
        var costSoFar: Int

        func score(to: Point) -> Int {
            return nodes.last!.position.distance(from: to) + costSoFar
        }

        func moving(to: Point) -> Path {
            let tool = nodes.last!.tool
            var new = self
            new.nodes.append(Node(position: to, tool: tool))
            new.costSoFar += 1
            return new
        }

        func changingTool(to: Tool) -> Path {
            let position = nodes.last!.position
            var new = self
            new.nodes.append(Node(position: position, tool: to))
            new.costSoFar += 7
            return new
        }
    }

    public func shortestPathLength() -> Int {
        let targetNode = Node(position: target, tool: .torch)
        var heap = Heap<Path> { (lhs, rhs) -> Bool in
            return lhs.score(to: targetNode.position) < rhs.score(to: targetNode.position)
        }
        let firstNode = Node(position: .origin, tool: .torch)
        var visited: Set<Node> = [firstNode]
        let firstPath = Path(nodes: [firstNode], costSoFar: 0)
        heap.enqueue(firstPath)

        while let current = heap.dequeue() {
            let currentNode = current.nodes.last!
            if currentNode == targetNode {
                print(current)
                return current.costSoFar
            }

            if currentNode.position == target {
                let newPath = current.changingTool(to: .torch)
                heap.enqueue(newPath)
            }

            let currentRegion = regionType(currentNode.position)
            let adjacents = currentNode.position.adjacents()
                .filter { erosionLevels.value.isValidIndex($0) }
                .filter { regionType($0).validTools.contains(currentNode.tool) }
                .filter { !visited.contains(Node(position: $0, tool: currentNode.tool)) }
            for adjacent in adjacents {
                let newPath = current.moving(to: adjacent)
                visited.insert(newPath.nodes.last!)
                heap.enqueue(newPath)
            }
            for tool in currentRegion.validTools {
                if tool != currentNode.tool {
                    let newPath = current.changingTool(to: tool)
                    visited.insert(newPath.nodes.last!)
                    heap.enqueue(newPath)
                }
            }
        }
        return -1
    }
}

//: [Previous](@previous)

import Foundation
import AdventLib

struct Point: CustomStringConvertible {
    var x: Int
    var y: Int

    var description: String {
        return "(\(x), \(y))"
    }
}

extension Point: Hashable {}

extension Point: Comparable {
    static func < (lhs: Point, rhs: Point) -> Bool {
        if lhs.y == rhs.y {
            return lhs.x < rhs.x
        }
        return lhs.y < rhs.y
    }

    func adjacents() -> [Point] {
        return [
            Point(x: x - 1, y: y),
            Point(x: x + 1, y: y),
            Point(x: x, y: y + 1),
            Point(x: x, y: y - 1)
        ]
    }

    func distance(from: Point) -> Int {
        return abs(from.x - x) + abs(from.y - y)
    }
}



extension Rect {
    subscript(point: Point) -> Element {
        get { return self[point.x, point.y] }
        set { self[point.x, point.y] = newValue }
    }

    func isValidIndex(_ point: Point) -> Bool {
        return (0..<width).contains(point.x) && (0..<height).contains(point.y)
    }
}


class Unit: CustomStringConvertible {
    enum Kind: Character {
        case goblin = "G"
        case elf = "E"
    }
    var position: Point
    var hitPoints: Int
    var kind: Kind

    init(position: Point, kind: Kind) {
        self.position = position
        self.hitPoints = 200
        self.kind = kind
    }

    var description: String {
        return "\(kind) \(position) \(hitPoints)"
    }
}

enum Space: Character {
    case wall = "#"
    case open = "."
}

struct Cave: CustomStringConvertible {
    var grid: Rect<Space>
    var units: [Unit] = []
    var roundsCompleted = 0

    init(input: String) {
        let lines = input.components(separatedBy: "\n")
        let width = lines.map { $0.count }.max() ?? 0
        grid = Rect(width: width, height: lines.count, defaultValue: .open)

        for (y, line) in lines.enumerated() {
            for (x, char) in line.enumerated() {
                grid[x, y] = Space(rawValue: char) ?? .open
                if let unitKind = Unit.Kind(rawValue: char) {
                    units.append(Unit(position: Point(x: x, y: y), kind: unitKind))
                }
            }
        }
    }

    func isOccupied(_ point: Point) -> Bool {
        return grid[point] == .wall || units.map { $0.position }.contains(point)
    }

    var description: String {
        var result = ""
        let unitMap = [Point: Unit](uniqueKeysWithValues: units.map { ($0.position, $0) })
        for y in 0..<grid.height {
            var thisRowUnits = [Unit]()
            for x in 0..<grid.width {
                let location = Point(x: x, y: y)
                if let unit = unitMap[location] {
                    result.append(unit.kind.rawValue)
                    thisRowUnits.append(unit)
                } else {
                    result.append(grid[x, y].rawValue)
                }
            }
            if !thisRowUnits.isEmpty {
                let printUnits = thisRowUnits.map { "\($0.kind.rawValue)(\($0.hitPoints))" }.joined(separator: ",")
                result.append("   \(printUnits)")
            }
            result.append("\n")
        }
        return result
    }

    mutating func fight() -> Int {
        while true {
            print(self, roundsCompleted)
            if let finalScore = round() {
                return finalScore
            }
        }
    }

    mutating func round() -> Int? {
        units.sort { $0.position < $1.position }
        print(units)
        for unit in units {
            let hadTarget = turn(unit: unit)
            guard hadTarget else { return finalScore() }
        }
        roundsCompleted += 1
        return nil
    }

    func finalScore() -> Int {
        let remainingPoints = units.map { $0.hitPoints }.reduce(1, *)
        return remainingPoints * roundsCompleted
    }

    // returns true if unit had a target
    mutating func turn(unit: Unit) -> Bool {
        print("turn for \(unit)")
        // find all target units
        let targets = units.filter { $0.kind != unit.kind }
        guard !targets.isEmpty else { return false }
        print("targets are \(targets)")
        // find all squares adjacent to a target
        let allAdjacentSquares = Set(targets.flatMap { $0.position.adjacents() })
        // filter by valid
        let validAdjacent = allAdjacentSquares.filter { grid.isValidIndex($0) }
        print("validAdjacent: \(validAdjacent)")
        // filter by empty
         // if i'm not in one of them
        /// WRONG!!
        if !validAdjacent.contains(unit.position) {
            print("moving!")
            // move!
            let emptyAdjacentToTarget = validAdjacent.filter { !isOccupied($0) }
            print("emptyAdjacentToTarget: ", emptyAdjacentToTarget)

            // for square in adjency list
            //  find shortest path to square
            let pathsToTargets: [(length: Int, target: Point)] = emptyAdjacentToTarget.map { (target) -> (length: Int, target: Point) in
                let length = shortestPath(from: unit.position, to: target)
                return (length, target)
            }

            // pick target square

            let targetSquare = pathsToTargets.sorted { (lhs, rhs) -> Bool in
                if lhs.length == rhs.length {
                    return lhs.target < rhs.target
                }
                return lhs.length < rhs.length
            }.first?.target

            if let targetSquare = targetSquare {
                let nextSquares = unit.position.adjacents()
                    .filter { grid.isValidIndex($0) }
                    .filter { !isOccupied($0 )}
                print("nextSquares: \(nextSquares)")
                let nextSquareDistances = nextSquares.map { (nextSquare) -> (length: Int, nextSquare: Point) in
                    let length = shortestPath(from: targetSquare, to: nextSquare)
                    return (length, nextSquare)
                }
                print("nextSquareDistances: \(nextSquareDistances)")
                let bestMove = nextSquareDistances.sorted { (lhs, rhs) -> Bool in
                    if lhs.length == rhs.length {
                        return lhs.nextSquare < rhs.nextSquare
                    }
                    return lhs.length < rhs.length
                    }.first?.nextSquare

                if let bestMove = bestMove {
                    print("moving to \(bestMove)")
                    unit.position = bestMove
                } else {
                    print("no useful move")
                }

            }
        } else {
            print("already adjacent, not moving")
        }

        // if i'm now next to a target, attack
        attack(from: unit, targets: targets)

        return true
    }

    private struct PathRecord {
        var currentLoc: Point
        var steps: Int

        func score(destination: Point) -> Int {
            return currentLoc.distance(from: destination) + steps
        }
    }

    func shortestPath(from: Point, to destination: Point) -> Int {
        var visited: Set<Point> = []
        var heap = Heap<PathRecord> { (left, right) -> Bool in
            left.score(destination: destination) < right.score(destination: destination)
        }
        heap.enqueue(PathRecord(currentLoc: from, steps: 0))

        while let current = heap.dequeue() {
            if current.currentLoc == destination {
                return current.steps
            }
            for neighbor in current.currentLoc.adjacents() {
                if visited.contains(neighbor) { continue } else { visited.insert(neighbor) }
                if grid.isValidIndex(neighbor), !isOccupied(neighbor) {
                    heap.enqueue(PathRecord(currentLoc: neighbor, steps: current.steps + 1))
                }
            }
        }

        return -1
    }

    mutating func attack(from: Unit, targets: [Unit]) {
        print("attacking!")
        let targetPositions = [Point: Unit](uniqueKeysWithValues: targets.map { ($0.position, $0) })

        let adjacentToMe = from.position.adjacents()
        let adjacentTargets = adjacentToMe.compactMap { targetPositions[$0] }
        let sortedTargets = adjacentTargets.sorted { (lhs, rhs) -> Bool in
            if lhs.hitPoints == rhs.hitPoints {
                return lhs.position < rhs.position
            }
            return lhs.hitPoints < rhs.hitPoints
        }
        if let target = sortedTargets.first {
            print("\(from) attacking \(target)")
            target.hitPoints -= 3
            if target.hitPoints <= 0 {
                if let index = self.units.firstIndex(where: { $0 === target }) {
                    self.units.remove(at: index)
                }
            }
        } else {
            print("\(from) cannot attack")
        }
    }
}

let example = """
#########
#G..G..G#
#.......#
#.......#
#G..E..G#
#.......#
#.......#
#G..G..G#
#########
"""

var cave = Cave(input: example)
print(cave)
//cave.round()
//print(cave)
//cave.round()
//print(cave)
//cave.round()
//print(cave)

let firstTest = """
#######
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######
"""

var firstTestCave = Cave(input: firstTest)
print(firstTestCave)
print(firstTestCave.fight())

//: [Next](@next)

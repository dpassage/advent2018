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
    var unitPositions: [Point: Unit] = [:]
    var roundsCompleted = 0

    mutating func updateUnitPositions() {
        unitPositions = [Point: Unit](uniqueKeysWithValues: units.map { ($0.position, $0) })
    }

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
        updateUnitPositions()
    }

    func isOccupied(_ point: Point) -> Bool {
        return grid[point] == .wall || unitPositions.keys.contains(point)
    }

    var description: String {
        var result = ""
        for y in 0..<grid.height {
            var thisRowUnits = [Unit]()
            for x in 0..<grid.width {
                let location = Point(x: x, y: y)
                if let unit = unitPositions[location] {
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
        let remainingPoints = units.map { $0.hitPoints }.reduce(0, +)
        return remainingPoints * roundsCompleted
    }


    mutating func turn(unit: Unit) -> Bool {
        print("turn for \(unit)")
        if unit.hitPoints <= 0 {
            print("\(unit) alrady dead, skipping")
            return true
        }
        let targets = units.filter { $0.kind != unit.kind }
        guard !targets.isEmpty else { return false }
        print("targets are \(targets)")

        // move
        move(unit, targets: targets)
        // attack
        attack(from: unit, targets: targets)
        return true
    }

    mutating func move(_ unit: Unit, targets: [Unit]) {
        print("move for \(unit)")
        // first check to see if there's a target adjacent
        let adjacents = unit.position.adjacents()
        for target in targets {
            if adjacents.contains(target.position) {
                print("already next to a target")
                return
            }
        }

        let possibleMoves = adjacents.filter { grid.isValidIndex($0) }
            .filter { !isOccupied($0) }
        print("possibleMoves: \(possibleMoves)")
        // for each possible move
        //   for each target
        //     compute shortest path
        var paths: [PathRecord] = []
        for move in possibleMoves {
            for target in targets {
                if let shortestPath = shortestPath(from: move, to: target.position) {
                    paths.append(shortestPath)
                }
            }
        }
        // sort by length then order of first step

        let sortedPaths = paths.sorted { (lhs, rhs) -> Bool in
            if lhs.path.count == rhs.path.count {
                return lhs.path.first! < rhs.path.first!
            }
            return lhs.path.count < rhs.path.count
        }
        // if there's a move, that's your move
        if let move = sortedPaths.first?.path.first {
            print("moving to \(move)")
            unit.position = move
            updateUnitPositions()
        } else {
            print("no move found")
        }
    }

    struct PathRecord {
        var path: [Point]

        func score(destination: Point) -> Int {
            return (path.last?.distance(from: destination) ?? 0 ) + path.count
        }
    }

    func shortestPath(from: Point, to destination: Point) -> PathRecord? {
        var visited: Set<Point> = []
        var heap = Heap<PathRecord> { (left, right) -> Bool in
            left.score(destination: destination) < right.score(destination: destination)
        }
        heap.enqueue(PathRecord(path: [from]))
        visited.insert(from)
 
        while let current = heap.dequeue() {
            let last = current.path.last!
            if last == destination {
                return current
            }
            for neighbor in last.adjacents() {
                if visited.contains(neighbor) { continue } else { visited.insert(neighbor) }
                if grid.isValidIndex(neighbor) && (!isOccupied(neighbor) || neighbor == destination) {
                    let newPath = PathRecord(path: current.path + [neighbor])
                    heap.enqueue(newPath)
                }
            }
        }

        return nil
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
                print("\(target) is dead removing!")
                if let index = self.units.firstIndex(where: { $0 === target }) {
                    self.units.remove(at: index)
                    updateUnitPositions()
                } else {
                    print("============ couldn't find target, units: \(units)")
                }
            }
        } else {
            print("\(from) cannot attack")
        }
    }
}

//let firstTest = """
//#######
//#.G...#
//#...EG#
//#.#.#G#
//#..G#E#
//#.....#
//#######
//"""
//
//var firstTestCave = Cave(input: firstTest)
//print(firstTestCave)
//print(firstTestCave.fight())

var secondTestCave = Cave(input: """
#######
#G..#E#
#E#E.E#
#G.##.#
#...#E#
#...E.#
#######
""")

print(secondTestCave.fight())

//: [Next](@next)

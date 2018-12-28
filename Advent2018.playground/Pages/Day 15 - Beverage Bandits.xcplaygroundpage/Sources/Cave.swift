import Foundation
import AdventLib

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

public struct Cave: CustomStringConvertible {
    var grid: Rect<Space>
    var units: [Unit] = []
    var unitPositions: [Point: Unit] = [:]
    var roundsCompleted = 0

    mutating func updateUnitPositions() {
        unitPositions = [Point: Unit](uniqueKeysWithValues: units.map { ($0.position, $0) })
    }

    public init(input: String) {
        let lines = input.components(separatedBy: "\n").filter { !$0.isEmpty }
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

    public var description: String {
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

    public mutating func fight() -> Int {
        while true {
            print(self, roundsCompleted)
            if let finalScore = round() {
                print(self, roundsCompleted)
                return finalScore
            }
        }
    }

    public mutating func round() -> Int? {
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

        let targetSquares = Set(targets.flatMap { $0.position.adjacents() })
            .filter { grid.isValidIndex($0) }
            .filter { !isOccupied($0) }
        print("targetSquares: \(targetSquares)")

        // compute all distances
        let allDistances = distances(from: unit.position)
        let targetPaths = allDistances.filter { targetSquares.contains($0.0) }

        // sort by length then order of last step

        let sortedPaths = targetPaths.sorted { (lhs, rhs) -> Bool in
            if lhs.value == rhs.value {
                return lhs.key < rhs.key
            }
            return lhs.value < rhs.value
        }
        print("sortedPaths are \(sortedPaths)")
        guard let selectedTarget = sortedPaths.first?.key,
            let selectedDistance = sortedPaths.first?.value else {
            print("no move found")
            return
        }

        // now we have a target, figure out what the next square is
        let startSquares = unit.position.adjacents().filter { grid.isValidIndex($0) }.filter { !isOccupied($0) }

        let startPaths = startSquares.compactMap { shortestPath(from: $0, to: selectedTarget, limit: selectedDistance - 1) }
        let sortedStartPaths = startPaths.sorted { (lhs, rhs) -> Bool in
            if lhs.path.count == rhs.path.count {
                return lhs.path.first! < rhs.path.first!
            }
            return lhs.path.count < rhs.path.count
        }
        print("sortedStartPaths are \(sortedStartPaths)")
        if let nextSquare = sortedStartPaths.first?.path.first {
            print("moving to \(nextSquare)")
            unit.position = nextSquare
            updateUnitPositions()
        } else {
            print("no move found")
        }
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

extension Cave {
    struct PathRecord {
        var path: [Point]

        func score(destination: Point) -> Int {
            return (path.last?.distance(from: destination) ?? 0 ) + path.count
        }
    }

    func shortestPath(from: Point, to destination: Point, limit: Int = Int.max) -> PathRecord? {
        print("computing path \(from) to \(destination)")
        let result = aStar(from: from, to: destination, limit: limit)
        if result.cost == -1 {
            return nil
        } else {
            return PathRecord(path: result.path)
        }
    }
}

extension Cave: AStar {
    public typealias Node = Point

    public func estimatedCost(from: Node, to: Node) -> Int {
        return from.distance(from: to)
    }

    public func neighborsOf(_ node: Node) -> [(node: Node, distance: Int)] {
        return node.adjacents()
            .filter { grid.isValidIndex($0) }
            .filter { !isOccupied($0) }
            .map { (node: $0, distance: 1) }
    }
}

extension Cave: Dijkstra {}

//: [Previous](@previous)

import Foundation
import AdventLib

struct Point {
    var x: Int
    var y: Int
}

extension Point: Hashable {}

extension Point: Comparable {
    static func < (lhs: Point, rhs: Point) -> Bool {
        if lhs.y == rhs.y {
            return lhs.x < rhs.x
        }
        return lhs.y < rhs.y
    }
}

extension Rect {
    subscript(point: Point) -> Element {
        get { return self[point.x, point.y] }
        set { self[point.x, point.y] = newValue }
    }
}


class Unit {
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
}

enum Space: Character {
    case wall = "#"
    case open = "."
}

struct Cave: CustomStringConvertible {
    var grid: Rect<Space>
    var units: [Unit] = []

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

    var description: String {
        var result = ""
        let unitMap = [Point: Unit.Kind](uniqueKeysWithValues: units.map { ($0.position, $0.kind) })
        for y in 0..<grid.height {
            for x in 0..<grid.width {
                let location = Point(x: x, y: y)
                if let unit = unitMap[location] {
                    result.append(unit.rawValue)
                } else {
                    result.append(grid[x, y].rawValue)
                }
            }
            result.append("\n")
        }
        return result
    }
}

let firstTest = """
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

let cave = Cave(input: firstTest)
print(cave)

//: [Next](@next)

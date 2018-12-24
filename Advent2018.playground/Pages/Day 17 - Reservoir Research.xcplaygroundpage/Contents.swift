//: [Previous](@previous)

import Foundation
import AdventLib

let testInput = """
x=495, y=2..7
y=7, x=495..501
x=501, y=3..7
x=498, y=2..4
x=506, y=1..2
x=498, y=10..13
x=504, y=10..13
y=13, x=498..504
"""

enum Square: Character {
    case sand = "."
    case clay = "#"
    case stream = "|"
    case stopped = "~"

    var isWet: Bool {
        return self == .stream || self == .stopped
    }
}

extension Point {
    var below: Point { return Point(x: x, y: y + 1) }
    var left: Point { return Point(x: x - 1, y: y) }
    var right: Point { return Point(x: x + 1, y: y) }
    var above: Point { return Point(x: x, y: y - 1) }
}

struct Vein {
    var x: ClosedRange<Int>
    var y: ClosedRange<Int>

    static let regex = try! Regex(pattern: "([xy])=(\\d+), [xy]=(\\d+)\\.\\.(\\d+)")

    init?(line: String) {
        guard let matches = Vein.regex.match(input: line),
            matches.count == 4,
            let firstNumber = Int(matches[1]),
            let secondNumber = Int(matches[2]),
            let thirdNumber = Int(matches[3]) else { return nil }

        let range = secondNumber ... thirdNumber

        if matches[0] == "x" {
            x = firstNumber ... firstNumber
            y = range
        } else {
            x = range
            y = firstNumber ... firstNumber
        }
    }
}

let testVeins = testInput.components(separatedBy: "\n").compactMap(Vein.init)
print(testVeins)

struct Slice: CustomStringConvertible {
    var grid: Rect<Square>
    var offset: Point
    var current: Point

    init(veins: [Vein]) {
        let minX = veins.map { $0.x.lowerBound }.min()!
        let maxX = veins.map { $0.x.upperBound }.max()!
        let minY = veins.map { $0.y.lowerBound }.min()!
        let maxY = veins.map { $0.y.upperBound }.max()!
        grid = Rect(width: (maxX - minX) + 1, height: (maxY - minY) + 1, defaultValue: .sand)
        offset = Point(x: minX, y: minY)
        
        for vein in veins {
            for x in vein.x {
                for y in vein.y {
                    let coordinate = Point(x: x, y: y) - offset
                    grid[coordinate] = .clay
                }
            }
        }
        current = Point(x: 500 - offset.x, y: 0)
    }

    var description: String {
        var result = ""
        var wetCount = 0
        for y in 0..<grid.height {
            for x in 0..<grid.width {
                result.append(grid[x, y].rawValue)
                wetCount += grid[x, y].isWet ? 1 : 0
            }
            result.append("\n")
        }
        result.append("wetCount: \(wetCount)")
        return result
    }

    func wetCount() -> Int {
        var result = 0
        for x in 0..<grid.width {
            for y in 0..<grid.height {
                result += grid[x, y].isWet ? 1 : 0
            }
        }
        return result
    }

    mutating func fill() {
        switch grid[current] {
        case .sand:
            let below = current.below
            if !grid.isValidIndex(below) { grid[current] = .stream }
        default:
            break
        }
    }
}

var testSlice = Slice(veins: testVeins)
print(testSlice)

let url = Bundle.main.url(forResource: "day17.input", withExtension: "txt")!
let day17string = try! String(contentsOf: url)
let day17lines = day17string.components(separatedBy: "\n")
let day17veins = day17lines.compactMap(Vein.init)
var day17slice = Slice(veins: day17veins)



//: [Next](@next)

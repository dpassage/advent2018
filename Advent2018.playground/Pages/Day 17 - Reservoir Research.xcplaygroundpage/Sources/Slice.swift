import Foundation
import AdventLib

public enum Square: Character {
    case sand = "."
    case clay = "#"
    case stream = "|"
    case stopped = "~"

    var isWet: Bool {
        return self == .stream || self == .stopped
    }

    var isFilled: Bool {
        return self == .clay || self == .stopped
    }
}

extension Point {
    var below: Point { return Point(x: x, y: y + 1) }
    var left: Point { return Point(x: x - 1, y: y) }
    var right: Point { return Point(x: x + 1, y: y) }
    var above: Point { return Point(x: x, y: y - 1) }
}

public struct Vein {
    var x: ClosedRange<Int>
    var y: ClosedRange<Int>

    static let regex = try! Regex(pattern: "([xy])=(\\d+), [xy]=(\\d+)\\.\\.(\\d+)")

    public init?(line: String) {
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

public struct Slice: CustomStringConvertible {
    public var grid: Rect<Square>
    var offset: Point
    var currents: [Point]
    public var printSteps = false

    public init(veins: [Vein]) {
        let minX = veins.map { $0.x.lowerBound }.min()! - 1
        let maxX = veins.map { $0.x.upperBound }.max()! + 1
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
        let firstCurrent = Point(x: 500 - offset.x, y: 0)
        currents = [firstCurrent]
        grid[firstCurrent] = .stream
    }

    public var description: String {
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

    public func wetCount() -> Int {
        var result = 0
        for x in 0..<grid.width {
            for y in 0..<grid.height {
                result += grid[x, y].isWet ? 1 : 0
            }
        }
        return result
    }

    func firstClayLeftOf(_ point: Point) -> Point? {
        var point = point
        while grid.isValidIndex(point) {
            if grid[point] == .clay {
                return point
            } else {
                point.x -= 1
            }
        }
        return nil
    }

    func firstClayRightOf(_ point: Point) -> Point? {
        var point = point
        while grid.isValidIndex(point) {
            if grid[point] == .clay {
                return point
            } else {
                point.x += 1
            }
        }
        return nil
    }


    public mutating func fill() {
        while let current = currents.popLast() {
            if printSteps {
                print(current, currents)
                print(self)
            }
            let below = current.below
            if !grid.isValidIndex(below) { continue } // at bottom of grid, done
            switch grid[below] {
            case .stream:
                // already been processed
                break
            case .sand:
                grid[below] = .stream
                currents.append(below)
            case .clay, .stopped:
                let left = firstClayLeftOf(current)
                let right = firstClayRightOf(current)
                switch (left, right) {
                case (let left?, let right?):
                    // first see if the entire row below us is filled
                    let range = (left.x + 1) ..< (right.x)
                    let belowPoints = range.map { Point(x: $0, y: current.y + 1) }
                    let belowSquares = belowPoints.map { grid[$0] }
                    if belowSquares.allSatisfy({ $0.isFilled }) {
                        for x in (left.x + 1) ... (right.x - 1) {
                            grid[x, current.y] = .stopped
                        }
                        grid[current.above] = .stream
                        currents.append(current.above)
                        continue
                    }
                default:
                    break
                }

                let leftRange = (0 ..< current.x).reversed()
                let rightRange = (current.x + 1) ..< grid.width
                for x in leftRange {
                    let this = Point(x: x, y: current.y)
                    if grid[this].isFilled { break }
                    let below = this.below
                    grid[this] = .stream
                    if !grid[below].isFilled {
                        currents.append(this)
                        break
                    }
                }
                for x in rightRange {
                    let this = Point(x: x, y: current.y)
                    if grid[this].isFilled { break }
                    let below = this.below
                    grid[this] = .stream
                    if !grid[below].isFilled {
                        currents.append(this)
                        break
                    }
                }
            }
        }
        print(self)
    }
}

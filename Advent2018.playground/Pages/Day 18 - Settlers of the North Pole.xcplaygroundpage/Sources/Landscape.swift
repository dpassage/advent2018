import Foundation
import AdventLib


enum Acre: Character {
    case open = "."
    case trees = "|"
    case lumberyard = "#"
}

public struct Landscape: CustomStringConvertible {
    var grid: Rect<Acre>

    public init(input: String) {
        let lines = input.components(separatedBy: "\n").filter { !$0.isEmpty }
        let height = lines.count
        let width = lines.map { $0.count }.max()!
        grid = Rect(width: width, height: height, defaultValue: .open)
        for (y, line) in lines.enumerated() {
            for (x, char) in line.enumerated() {
                grid[x, y] = Acre(rawValue: char) ?? .open
            }
        }
    }

    public var description: String {
        return grid.description
    }

    public mutating func generation() {
        var result = grid
        for x in 0..<grid.width {
            for y in 0..<grid.height {
                let thisPoint = Point(x: x, y: y)
                let thisSquare = grid[thisPoint]
                let adjacents = thisPoint.allAdjacents().filter { grid.isValidIndex($0) }
                switch thisSquare {
                case .open:
                    let treeCount = adjacents.map { grid[$0] }.filter { $0 == .trees }.count
                    if treeCount >= 3 {
                        result[thisPoint] = .trees
                    }
                case .trees:
                    let lumberCount = adjacents.map { grid[$0] }.filter { $0 == .lumberyard }.count
                    if lumberCount >= 3 {
                        result[thisPoint] = .lumberyard
                    }
                case .lumberyard:
                    let adjacentsAcres = adjacents.map { grid[$0] }
                    if adjacentsAcres.contains(.lumberyard) && adjacentsAcres.contains(.trees) {
                        result[thisPoint] = .lumberyard
                    } else {
                        result[thisPoint] = .open
                    }
                }

            }
        }
        grid = result
    }

    public func score() -> Int {
        var wooded = 0
        var lumberyards = 0
        for x in 0..<grid.width {
            for y in 0..<grid.height {
                switch grid[x, y] {
                case .open: break
                case .trees: wooded += 1
                case .lumberyard: lumberyards += 1
                }
            }
        }
        return wooded * lumberyards
    }
}

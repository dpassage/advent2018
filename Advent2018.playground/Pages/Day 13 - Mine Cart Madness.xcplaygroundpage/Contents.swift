//: [Previous](@previous)

import Foundation
import AdventLib

let testURL = Bundle.main.url(forResource: "testInput", withExtension: "txt")!
let testInput = try! String(contentsOf: testURL)

enum Space: Character {
    case empty = " "
    case vert = "|"
    case horiz = "-"
    case plus = "+"
    case slash = "/"
    case backSlash = "\\"
}

struct Maze {
    var grid: Rect<Space>

    init(input: String) {
        let lines = input.components(separatedBy: "\n").filter{ !$0.isEmpty }
        let height = lines.count
        let width = lines.map { $0.count }.max() ?? 0
        grid = Rect(width: width, height: height, defaultValue: .empty)
        for (y, line) in lines.enumerated() {
            for (x, char) in line.enumerated() {
                grid[x, y] = Space(rawValue: char) ?? .empty
            }
        }
    }
}

extension Maze: CustomStringConvertible {
    var description: String {
        var result = ""
        for y in 0..<grid.height {
            for x in 0..<grid.width {
                result.append(grid[x, y].rawValue)
            }
            result.append("\n")
        }
        return result
    }
}

let testMaze = Maze(input: testInput)
print(testMaze)

//: [Next](@next)

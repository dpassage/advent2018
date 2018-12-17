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
    var carts: [Cart] = []
    init(input: String) {
        let lines = input.components(separatedBy: "\n").filter{ !$0.isEmpty }
        let height = lines.count
        let width = lines.map { $0.count }.max() ?? 0
        grid = Rect(width: width, height: height, defaultValue: .empty)
        for (y, line) in lines.enumerated() {
            for (x, char) in line.enumerated() {
                if let direction = Cart.Direction(rawValue: char) {
                    let cart = Cart(direction: direction, x: x, y: y)
                    carts.append(cart)
                    grid[x, y] = direction.isVertical ? .vert : .horiz
                } else {
                    grid[x, y] = Space(rawValue: char) ?? .empty
                }
            }
        }
    }
}

extension Maze: CustomStringConvertible {
    var description: String {
        var result = ""
        for y in 0..<grid.height {
            for x in 0..<grid.width {
                if let cart = carts.first(where: { $0.location == (x, y) }) {
                    result.append(cart.direction.rawValue)
                } else {
                    result.append(grid[x, y].rawValue)
                }
            }
            result.append("\n")
        }
        return result
    }
}

class Cart {
    enum Direction: Character {
        case up = "^"
        case down = "v"
        case left = "<"
        case right = ">"

        var isVertical: Bool {
            return self == .up || self == .down
        }

        var move: (x: Int, y: Int) {
            switch self {
            case .up: return (0, -1)
            case .down: return (0, 1)
            case .left: return (-1, 0)
            case .right: return (1, 0)
            }
        }
    }

    enum NextTurn {
        case left
        case straight
        case right

        var successor: NextTurn {
            switch self {
            case .left: return .straight
            case .straight: return .right
            case .right: return .left
            }
        }

        func apply(_ direction: Direction) -> Direction {
            switch self {
            case .straight:
                return direction
            case .left:
                switch direction {
                case .up: return .left
                case .down: return .right
                case .left: return .down
                case .right: return .up
                }
            case .right:
                switch direction {
                case .up: return .right
                case .down: return .left
                case .left: return .up
                case .right: return .down
                }
            }
        }
    }

    var direction: Direction
    var nextTurn: NextTurn = .left
    var location: (x: Int, y: Int)

    init(direction: Direction, x: Int, y: Int) {
        self.direction = direction
        self.location = (x, y)
    }

    func move() {
        let movement = direction.move
        location.x += movement.x
        location.y += movement.y
    }
}

var testMaze = Maze(input: testInput)
print(testMaze)

extension Maze {
    enum MazeError: Error {
        case collision(x: Int, y: Int)
    }

    mutating func move() throws {
        carts.sort { (lhs, rhs) -> Bool in
            if lhs.location.y == rhs.location.y {
                return lhs.location.x < lhs.location.x
            }
            return lhs.location.y < rhs.location.y
        }
        for cart in carts {
            cart.move()
            for other in carts {
                if other === cart { continue }
                if other.location.x == cart.location.x &&
                    other.location.y == cart.location.y {
                    throw MazeError.collision(x: other.location.x, y: other.location.y)
                }

            }
            switch grid[cart.location.x, cart.location.y] {
            case .empty: fatalError("should not be here")
            case .vert, .horiz: break
            case .plus:
                let newDirection = cart.nextTurn.apply(cart.direction)
                cart.direction = newDirection
                cart.nextTurn = cart.nextTurn.successor
            case .slash: // /
                switch cart.direction {
                case .left: cart.direction = .down
                case .right: cart.direction = .up
                case .up: cart.direction = .right
                case .down: cart.direction = .left
                }
            case .backSlash: // \
                switch cart.direction {
                case .left: cart.direction = .up
                case .right: cart.direction = .down
                case .up: cart.direction = .left
                case .down: cart.direction = .right
                }
            }
        }
    }
}

while true {
    do {
        try testMaze.move()
        print(testMaze)
    } catch {
        print(error)
        break
    }
}

let day13url = Bundle.main.url(forResource: "day13.input", withExtension: "txt")!
let day13input = try! String(contentsOf: day13url)

var day13maze = Maze(input: day13input)

while true {
    do {
        try day13maze.move()
        print(testMaze)
    } catch {
        print(error)
        break
    }
}

//: [Next](@next)

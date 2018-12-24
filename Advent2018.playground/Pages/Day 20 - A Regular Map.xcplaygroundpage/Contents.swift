//: [Previous](@previous)

import Foundation
import AdventLib


// start at 0,0 depth 0 length 0
// switch char

extension Point {
    var west: Point { return Point(x: x - 1, y: y) }
    var east: Point { return Point(x: x + 1, y: y) }
    var north: Point { return Point(x: x, y: y - 1) }
    var south: Point { return Point(x: x, y: y + 1) }

    func move(_ char: Character) -> Point {
        switch char {
        case "W": return west
        case "E": return east
        case "N": return north
        case "S": return south
        default: fatalError()
        }
    }
}

func deepestPath(input: String) -> (Int, Int) {
    var lengths: [Point: Int] = [:]
    var currentPosition = Point(x: 0, y: 0)
    var stack: [(position: Point, path: String)] = []
    var currentPath = ""

    for char in input {
//        print(char, currentPosition, currentPath)
        switch char {
        case "W", "E", "N", "S":
            currentPath.append(char)
            currentPosition = currentPosition.move(char)
            lengths[currentPosition] = min(lengths[currentPosition, default: Int.max], currentPath.count)
        case "(":
            stack.append((position: currentPosition, path: currentPath))
        case "|":
            let currents = stack.last!
            currentPosition = currents.position
            currentPath = currents.path
        case ")":
            let currents = stack.popLast()!
            currentPosition = currents.position
            currentPath = currents.path
        default:
            break
        }
    }
    let deepestRoom = lengths.values.max() ?? -1
    let atLeast1000 = lengths.values.filter { $0 >= 1000 }.count
    return (deepestRoom, atLeast1000)
}

// input: ^WNE$
// answer: 3

print(deepestPath(input: "^WNE$"))

// input: ^ENWWW(NEEE|SSE(EE|N))$
// answer: 10
print(deepestPath(input: "^ENWWW(NEEE|SSE(EE|N))$"))

// input: ^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$
// answer: 18

print(deepestPath(input: "^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$"))
// input: ^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$
// answer: 23
print(deepestPath(input: "^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$"))

// input: ^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$
// answer: 31

print(deepestPath(input: "^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$"))

let url = Bundle.main.url(forResource: "day20.input", withExtension: "txt")!
let day20input = try! String(contentsOf: url)
print(deepestPath(input: day20input))

//: [Next](@next)

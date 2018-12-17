//: [Previous](@previous)

import Foundation
import AdventLib

let testURL = Bundle.main.url(forResource: "testInput", withExtension: "txt")!
let testInput = try! String(contentsOf: testURL)

var testMaze = Maze(input: testInput)
print(testMaze)

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
    } catch {
        print(error)
        break
    }
}

let part2url = Bundle.main.url(forResource: "part2", withExtension: "txt")!
let part2input = try! String(contentsOf: part2url)

var part2maze = Maze(input: part2input)
print(part2maze.moveAndDestroy())

var day13destroymaze = Maze(input: day13input)
print(day13destroymaze.moveAndDestroy())

//: [Next](@next)

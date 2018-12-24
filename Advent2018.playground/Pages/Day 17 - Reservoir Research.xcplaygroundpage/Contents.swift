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
//
//let testVeins = testInput.components(separatedBy: "\n").compactMap(Vein.init)
//var testSlice = Slice(veins: testVeins)
//testSlice.printSteps = true
//print(testSlice)
//
//testSlice.fill()
//print(testSlice)


/*
     +
1#.............#
2...#........#..
3...#..#.#...#..
4...#..### ..#..
5...#........#..
6...##########..
 */
let cupTest = """
x=496, y=1..2
x=499, y=2..6
y=6, x=499..508
x=508, y=2..6
x=502, y=3..4
x=504, y=3..4
y=4, x=502..504
"""
let cupVeins = cupTest.components(separatedBy: "\n").compactMap(Vein.init)
var cupSlice = Slice(veins: cupVeins)
cupSlice.printSteps = true
print(cupSlice)
cupSlice.fill()


let url = Bundle.main.url(forResource: "day17.input", withExtension: "txt")!
let day17string = try! String(contentsOf: url)
let day17lines = day17string.components(separatedBy: "\n")
let day17veins = day17lines.compactMap(Vein.init)
var day17slice = Slice(veins: day17veins)

print(day17slice.grid.width, day17slice.grid.height)

day17slice.fill() // 27331 is correct part 1!
                  // 22245 is correct part 2!

//: [Next](@next)

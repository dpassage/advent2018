//: [Previous](@previous)

import Foundation
import AdventLib

print(powerLevel(x: 3, y: 5, serial: 8))
//Fuel cell at  122,79, grid serial number 57: power level -5.
print(powerLevel(x: 122, y: 79, serial: 57))
// Fuel cell at 217,196, grid serial number 39: power level  0.
print(powerLevel(x: 217, y: 196, serial: 39))
// Fuel cell at 101,153, grid serial number 71: power level  4.
print(powerLevel(x: 101, y: 153, serial: 71))

//print(squareScore(x: 33, y: 45, serial: 18))
//print(squareScore(x: 21, y: 61, serial: 42))

func buildGrid(serial: Int, size: Int) -> Rect<Int> {
    var result = Rect<Int>(width: size, height: size, defaultValue: 0)

    for x in 0..<size {
        for y in 0..<size {
            let power = powerLevel(x: x + 1, y: y + 1, serial: serial)
            result[x, y] = power
        }
    }
    return result
}



let grid18 = buildGrid(serial: 3613, size: 300)
print(squareScore(grid: grid18, x: 33, y: 45, size: 3))
print(bestSquare(grid: grid18, size: 3))

func findBestSquare(grid: Rect<Int>) -> (x: Int, y: Int, size: Int, score: Int) {
    var largestSoFar = (x: 0, y: 0, size: 0, score: 0)
    for size in 1...grid.width {
        let best = bestSquare(grid: grid, size: size)
        if best.score > largestSoFar.score {
            largestSoFar = (best.x, best.y, size, best.score)
            print(largestSoFar)
        }
    }
    return largestSoFar
}

print(findBestSquare(grid: grid18))

//: [Next](@next)

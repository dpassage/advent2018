import Foundation
import AdventLib

public func powerLevel(x: Int, y: Int, serial: Int) -> Int {
    //    Find the fuel cell's rack ID, which is its X coordinate plus 10.
    let rackId = x + 10
    //    Begin with a power level of the rack ID times the Y coordinate.
    let firstPower = rackId * y
    //    Increase the power level by the value of the grid serial number (your puzzle input).
    let secondPower = firstPower + serial
    //    Set the power level to itself multiplied by the rack ID.
    let thirdPower = secondPower * rackId
    //    Keep only the hundreds digit of the power level (so 12345 becomes 3; numbers with no hundreds digit become 0).
    let fourthPower = hundredsDigit(num: thirdPower)
    //    Subtract 5 from the power level.
    return fourthPower - 5
}

func hundredsDigit(num: Int) -> Int {
    return (num % 1_000) / 100
}

public func squareScore(grid: Rect<Int>, x: Int, y: Int, size: Int) -> Int {
    var result = 0
    // our grid is 0-indexed but puzzle is 1-indexed
    for littleX in 0..<size {
        for littleY in 0..<size {
            result += grid[x + littleX - 1, y + littleY - 1]
        }
    }
    return result
}

public func bestSquare(grid: Rect<Int>, size: Int) -> (x: Int, y: Int, score: Int) {
    var largestSoFar = (x: 0, y: 0, score: -1)
    for x in 1...(grid.width - size + 1) {
        for y in 1...(grid.width - size + 1) {
            let score = squareScore(grid: grid, x: x, y: y, size: size)
            if score > largestSoFar.score {
                largestSoFar = (x: x, y: y, score: score)
            }
        }
    }
    return largestSoFar
}

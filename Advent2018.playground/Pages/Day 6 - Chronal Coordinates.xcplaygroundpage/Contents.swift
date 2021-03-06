//: [Previous](@previous)

import Foundation
import AdventLib

let testInputLines = """
1, 1
1, 6
8, 3
3, 4
5, 5
8, 9
""".components(separatedBy: "\n")

let testCoordinates = testInputLines.compactMap(Point.init)

print(findLargestArea(coordinates: testCoordinates))

let url = Bundle.main.url(forResource: "day6.input", withExtension: "txt")!
let day6lines = try! String(contentsOf: url).components(separatedBy: "\n")
let day6coords = day6lines.compactMap(Point.init)

//print(findLargestArea(coordinates: day6coords))

// part 2


print(sizeOfNearbyArea(coordinates: testCoordinates, limit: 32))
print(sizeOfNearbyArea(coordinates: day6coords, limit: 10_000))

//: [Next](@next)

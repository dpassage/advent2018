//: [Previous](@previous)

import Foundation
import AdventLib

// test input:
// depth: 510
// target: 10,10
// risk level: 114
// my input:
// depth: 9465
// target: 13,704
func totalRiskLevel(depth: Int, target: Point) -> Int {
    func geologicIndex(area: Point, cave: Rect<Int>) -> Int {
        // The region at 0,0 (the mouth of the cave) has a geologic index of 0.
        // The region at the coordinates of the target has a geologic index of 0.
        if area == Point(x: 0, y: 0) || area == target {
            return 0
        }
        // If the region's Y coordinate is 0, the geologic index is its X coordinate times 16807.
        if area.y == 0 { return area.x * 16807 }
        // If the region's X coordinate is 0, the geologic index is its Y coordinate times 48271.
        if area.x == 0 { return area.y * 48271 }
        // Otherwise, the region's geologic index is the result of multiplying the erosion levels of the regions at X-1,Y and X,Y-1.
        return cave[area.x - 1, area.y] * cave[area.x, area.y - 1]
    }

    // cave tracks erosion levels of each area
    var cave = Rect<Int>(width: target.x + 1, height: target.y + 1, defaultValue: 0)
    var risk = 0
    for y in 0..<cave.height {
        for x in 0..<cave.width {
            let geoIndex = geologicIndex(area: Point(x: x, y: y), cave: cave)
            let erosion = (geoIndex + depth) % 20183
            cave[x, y] = erosion
            risk += erosion % 3
        }
    }

    return risk
}

print(totalRiskLevel(depth: 510, target: Point(x: 10, y: 10)))
print(totalRiskLevel(depth: 9465, target: Point(x: 13, y: 704)))

//////////// part 2


let testCave = Cave(depth: 510, target: Point(x: 10, y: 10))
print(testCave.erosionLevel(point: Point(x: 5, y: 5)))
print(testCave.erosionLevel(point: Point(x: 1, y: 1)))
print(testCave.regionType(Point(x: 2, y: 2)))

print(testCave.shortestPathLength())

let realCave = Cave(depth: 9465, target: Point(x: 13, y: 704))
print(realCave.shortestPathLength()) // 975 too high
//: [Next](@next)

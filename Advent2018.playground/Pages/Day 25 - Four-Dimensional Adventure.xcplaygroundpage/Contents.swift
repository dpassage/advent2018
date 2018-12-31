//: [Previous](@previous)

import Foundation


let testInput = """
1,-1,-1,-2
-2,-2,0,1
0,2,1,3
-2,3,-2,1
0,2,3,-2
-1,-1,1,-2
0,-2,-1,0
-2,2,3,-1
1,2,2,0
-1,-2,0,-2
"""

let points = testInput.components(separatedBy: "\n").compactMap(TimePoint.init)
var spaceTime = SpaceTime(points: points)
spaceTime.fullyReduce()
print(spaceTime.constellations.count)

let url = Bundle.main.url(forResource: "day25.input", withExtension: "txt")!
let day25input = try! String(contentsOf: url)
let day25points = day25input.components(separatedBy: "\n").compactMap(TimePoint.init)
var day25spacetime = SpaceTime(points: day25points)
day25spacetime.fullyReduce()
print(day25spacetime.constellations.count)

//: [Next](@next)

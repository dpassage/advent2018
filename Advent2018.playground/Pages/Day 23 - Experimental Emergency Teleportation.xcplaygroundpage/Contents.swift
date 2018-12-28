//: [Previous](@previous)

import Foundation
import AdventLib

struct Nanobot {
    var x: Int
    var y: Int
    var z: Int
    var radius: Int

    func distance(from other: Nanobot) -> Int {
        let xDist: Int = abs(x - other.x)
        let yDist: Int = abs(y - other.y)
        let zDist: Int = abs(z - other.z)
        return xDist + yDist + zDist
    }

    static let regex = try! Regex(pattern: "pos=<(-?\\d+),(-?\\d+),(-?\\d+)>, r=(\\d+)")

    init?(line: String) {
        guard let matches = Nanobot.regex.match(input: line),
            matches.count >= 4,
            let x = Int(matches[0]),
            let y = Int(matches[1]),
            let z = Int(matches[2]),
            let radius = Int(matches[3]) else { return nil }
        self.x = x
        self.y = y
        self.z = z
        self.radius = radius
    }
}

let testInput = """
pos=<0,0,0>, r=4
pos=<1,0,0>, r=1
pos=<4,0,0>, r=3
pos=<0,2,0>, r=1
pos=<0,5,0>, r=3
pos=<0,0,3>, r=1
pos=<1,1,1>, r=1
pos=<1,1,2>, r=1
pos=<1,3,1>, r=1
"""

let nanobots = testInput.components(separatedBy: "\n").compactMap(Nanobot.init)

func inRangeOfLargest(_ nanobots: [Nanobot]) -> Int {
    let largest = nanobots.sorted(by: { $0.radius > $1.radius }).first!
    let inRange = nanobots.filter { largest.distance(from: $0) <= largest.radius }
    return inRange.count
}

print(inRangeOfLargest(nanobots))

let url = Bundle.main.url(forResource: "day23.input", withExtension: "txt")!
let day23input = try! String(contentsOf: url)
let day23bots = day23input.components(separatedBy: "\n").compactMap(Nanobot.init)
print(day23bots.count)
print(inRangeOfLargest(day23bots)) // 691 is correct!
let minX = day23bots.map { $0.x }.min()!
let maxX = day23bots.map { $0.y }.max()!
print(minX, maxX)

//: [Next](@next)

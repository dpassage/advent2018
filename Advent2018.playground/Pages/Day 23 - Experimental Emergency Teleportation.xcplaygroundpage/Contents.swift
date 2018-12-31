//: [Previous](@previous)

import Foundation
import AdventLib

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
let maxX = day23bots.map { $0.x }.max()!
print(minX, maxX)
let minY = day23bots.map { $0.y }.min()!
let maxY = day23bots.map { $0.y }.max()!
print(minY, maxY)
let minZ = day23bots.map { $0.z }.min()!
let maxZ = day23bots.map { $0.z }.max()!
print(minZ, maxZ)



struct SearchResult {
    var cube: Cube
    var botsOverlapped: Int
    var size: Int { return cube.size }
    var distanceFromOrigin: Int { return cube.corners().map { $0.distance(from: .origin) }.min() ?? Int.max }

    init(cube: Cube, bots: [Nanobot]) {
        self.cube = cube
        self.botsOverlapped = bots.filter { cube.overlaps(bot: $0) }.count
    }
}

extension SearchResult: Equatable {}

extension SearchResult {
    func betterThan(_ other: SearchResult) -> Bool {
        let this = [botsOverlapped, -size, -distanceFromOrigin]
        let otherNums = [other.botsOverlapped, -other.size, -other.distanceFromOrigin]
        return this > otherNums
    }
}
struct Formation {
    var bots: [Nanobot]

    func findBestCoord() -> Coord? {
        var heap = Heap<SearchResult> { (first, second) -> Bool in
            return first.betterThan(second)
        }

        let firstCube = Cube.maximal
        let firstResult = SearchResult(cube: firstCube, bots: bots)
        heap.enqueue(firstResult)
        while let current = heap.dequeue() {
            print(current.size, current.botsOverlapped, current.cube.corners())
            if current.size == 1 {
                return current.cube.corners().first!
            }
            for newCube in current.cube.partition() {
                let newResult = SearchResult(cube: newCube, bots: bots)
                heap.enqueue(newResult)
            }
        }
        return nil
    }
}

let part2input = """
pos=<10,12,12>, r=2
pos=<12,14,12>, r=2
pos=<16,12,12>, r=4
pos=<14,14,14>, r=6
pos=<50,50,50>, r=200
pos=<10,10,10>, r=5
"""

let bigBot = Nanobot(line: "pos=<50,50,50>, r=200")!
let cube = Cube(xRange: 0..<13, yRange: 0..<13, zRange: 0..<13)
print(cube.overlaps(bot: bigBot))
let part2bots = part2input.components(separatedBy: "\n").compactMap(Nanobot.init)
for bot in part2bots {
    print(bot, cube.overlaps(bot: bot))
}
print(cube.corners())
let testFormation = Formation(bots: part2bots)
print(testFormation.findBestCoord())

let realFormation = Formation(bots: day23bots)
let result = realFormation.findBestCoord()!
print(result)
print(result.distance(from: .origin))

//: [Next](@next)

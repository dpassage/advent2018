import Foundation
import AdventLib

public struct Point {
    var x: Int
    var y: Int

    var xVel: Int
    var yVel: Int

    mutating func tick() {
        x += xVel
        y += yVel
    }
}

let pointRegex = try! Regex(pattern: "position=< *(-?[\\d]+), *(-?[\\d]+)> velocity=< *(-?[\\d]+), *(-?[\\d]+)>")
extension Point {
    public init?(line: String) {
        guard let matches = pointRegex.match(input: line),
            matches.count == 4,
            let x = Int(matches[0]),
            let y = Int(matches[1]),
            let xVel = Int(matches[2]),
            let yVel = Int(matches[3]) else { return nil }

        self.x = x
        self.y = y
        self.xVel = xVel
        self.yVel = yVel
    }
}

func printGrid(points: [Point]) {
    let minX = points.map { $0.x }.min()!
    let maxX = points.map { $0.x }.max()!
    let minY = points.map { $0.y }.min()!
    let maxY = points.map { $0.y }.max()!

    let originX = minX
    let originY = minY

    let width = (maxX - minX) + 1
    let height = (maxY - minY) + 1

    var grid = Rect<Bool>(width: width, height: height, defaultValue: false)
    for point in points {
        let x = point.x - originX
        let y = point.y - originY
        grid[x, y] = true
    }

    for y in 0..<grid.height {
        for x in 0..<grid.width {
            print(grid[x, y] ? "#" : ".", terminator: "")
        }
        print("")
    }
}

public func board(points: [Point], tickLimit: Int) {
    var points = points
    for tick in 0..<tickLimit {
        for i in 0..<points.count {
            points[i].tick()
        }

        let minX = points.map { $0.x }.min()!
        let maxX = points.map { $0.x }.max()!
        let minY = points.map { $0.y }.min()!
        let maxY = points.map { $0.y }.max()!

        if maxX - minX < 200 && maxY - minY < 200 {
            printGrid(points: points)
            print(tick)
            sleep(1)
        }
    }
}

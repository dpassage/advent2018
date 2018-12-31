import Foundation

public struct TimePoint {
    var x: Int
    var y: Int
    var z: Int
    var w: Int

    public func distanceFrom(_ other: TimePoint) -> Int {
        let first = abs(x - other.x) + abs(y - other.y)
        let second = abs(z - other.z) + abs(w - other.w)
        return first + second
    }
}

extension TimePoint {
    public init?(line: String) {
        let numbers = line.components(separatedBy: ",").compactMap { Int($0) }
        guard numbers.count == 4 else { return nil }
        x = numbers[0]
        y = numbers[1]
        z = numbers[2]
        w = numbers[3]
    }
}

public struct SpaceTime {
    public var constellations: [[TimePoint]] = []

    public init(points: [TimePoint]) {
        outer:
            for point in points {
                for i in 0..<constellations.count {
                    if constellations[i].contains(where: { $0.distanceFrom(point) <= 3}) {
                        constellations[i].append(point)
                        continue outer
                    }
                }
                constellations.append([point])
        }
    }

    mutating func reduce() {
        var newConstellations = [[TimePoint]]()
        outer:
            for constellation in constellations {
                for i in 0..<newConstellations.count {
                    for point in constellation {
                        if newConstellations[i].contains(where: { $0.distanceFrom(point) <= 3}) {
                            newConstellations[i].append(contentsOf: constellation)
                            continue outer
                        }
                    }
                }
                newConstellations.append(constellation)
        }
        constellations = newConstellations
    }

    public mutating func fullyReduce() {
        while true {
            var before = constellations.count
            reduce()
            if constellations.count == before { return }
        }
    }
}

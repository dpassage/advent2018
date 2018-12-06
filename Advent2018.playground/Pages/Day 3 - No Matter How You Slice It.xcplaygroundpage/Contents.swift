//: [Previous](@previous)

import Foundation

// Part 1

let testLines = """
#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2
""".components(separatedBy: "\n")

struct Claim {
    var id: Int
    var x: Int
    var y: Int
    var width: Int
    var height: Int

    func coordinates() -> [(x: Int, y: Int)] {
        var result = [(x: Int, y: Int)]()
        for w in 0..<width {
            for h in 0..<height {
                (result.append((x: x + w, y: y + h)))
            }
        }

        return result
    }
}

extension Claim: CustomStringConvertible {
    var description: String {
        return "#\(id) @ \(x),\(y): \(width)x\(height)"
    }
}

let regex = try! Regex(pattern: "#(\\d+) @ (\\d+),(\\d+): (\\d+)x(\\d+)")
extension Claim {
    init?(line: String) {
        guard let matches = regex.match(input: line) else { return nil }
        let numbers = matches.map { Int($0)! }
        self.id = numbers[0]
        self.x = numbers[1]
        self.y = numbers[2]
        self.width = numbers[3]
        self.height = numbers[4]
    }
}

let testClaims = testLines.compactMap { Claim(line: $0) }
print(testClaims)
print(testClaims[0].coordinates())
print(testClaims[0].coordinates().count)

struct Rect<Element> {
    var storage: [Element]
    var width: Int
    var height: Int

    init(width: Int, height: Int, defaultValue: Element) {
        storage = Array<Element>(repeating: defaultValue, count: width * height)
        self.width = width
        self.height = height
    }

    private func index(x: Int, y: Int) -> Int? {
        guard x < width, y < height else { return nil }
        return (y * width) + x
    }

    subscript(x: Int, y: Int) -> Element {
        get {
            guard let index = index(x: x, y: y) else { fatalError("out of range") }
            return storage[index]
        }
        set {
            guard let index = index(x: x, y: y) else { fatalError("out of range") }
            storage[index] = newValue
        }
    }
}

func countOverlaps(claims: [Claim], size: Int) -> Int {
    var fabric = Rect(width: size, height: size, defaultValue: 0)

    for claim in claims {
        for coord in claim.coordinates() {
            fabric[coord.x, coord.y] += 1
        }
    }

    return fabric.storage.filter { $0 >= 2}.count
}

print(countOverlaps(claims: testClaims, size: 10))

let url = Bundle.main.url(forResource: "day3.input", withExtension: "txt")!
let lines = try! String(contentsOf: url).components(separatedBy: "\n")
let day3claims = lines.compactMap{ Claim(line: $0) }

print(countOverlaps(claims: day3claims, size: 1000))

//: [Next](@next)

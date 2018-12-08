//: [Previous](@previous)

import Foundation

let testInput = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"

let testNumbers = testInput.components(separatedBy: CharacterSet.whitespacesAndNewlines).compactMap(Int.init)

class ReferenceIterator {
    var numbers: [Int]
    init(numbers: [Int]) {
        self.numbers = numbers
    }

    func next() -> Int? {
        if numbers.isEmpty {
            return nil
        } else {
            return numbers.removeFirst()
        }
    }
}

let iterator = ReferenceIterator(numbers: testNumbers)
struct Node {
    var children: [Node]
    var metaData: [Int]

    init?(iterator: ReferenceIterator) {
        guard let nodes = iterator.next() else { return nil }
        guard let metaData = iterator.next() else { return nil }
        self.children = []
        self.metaData = []
        for _ in 0..<nodes {
            children.append(Node(iterator: iterator)!)
        }
        for _ in 0..<metaData {
            self.metaData.append(iterator.next()!)
        }
    }

    func totalMetadata() -> Int {
        let mine = metaData.reduce(0, +)
        let children = self.children.map { $0.totalMetadata() }.reduce(0, +)
        return mine + children
    }

    func value() -> Int {
        if children.isEmpty {
            return metaData.reduce(0, +)
        }

        return metaData
            .compactMap { children.indices.contains($0 - 1) ? children[$0 - 1] : nil }
            .map { $0.value() }
            .reduce(0, +)
    }
}

let node = Node(iterator: iterator)!
print(node)
print(node.totalMetadata())

let url = Bundle.main.url(forResource: "day8.input", withExtension: "txt")!
let day8string = try! String(contentsOf: url)
let day8numbers = day8string.components(separatedBy: CharacterSet.whitespacesAndNewlines).compactMap(Int.init)

let day8iterator = ReferenceIterator(numbers: day8numbers)
let day8node = Node(iterator: day8iterator)!
print(day8node.totalMetadata())

// day 2
print(node.value())
print(day8node.value())

//: [Next](@next)

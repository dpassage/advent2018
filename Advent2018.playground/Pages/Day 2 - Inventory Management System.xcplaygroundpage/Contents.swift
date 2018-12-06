//: [Previous](@previous)

import Foundation

let testInput =
"""
abcdef
bababc
abbcde
abcccd
aabcdd
abcdee
ababab
""".components(separatedBy: "\n")

func histogram(input: String) -> [Character: Int] {
    var result: [Character: Int] = [:]
    for char in input {
        result[char, default: 0] += 1
    }
    return result
}

print(histogram(input: testInput[0]))

func checksum(input: [String]) -> Int {
    var twoLetters = 0
    var threeLetters = 0

    let histograms = input.map { histogram(input: $0) }

    for histogram in histograms {
        if histogram.values.contains(2) { twoLetters += 1 }
        if histogram.values.contains(3) { threeLetters += 1}
    }

    return twoLetters * threeLetters
}

print(checksum(input: testInput))

let fileURL = Bundle.main.url(forResource: "day2.input", withExtension: "txt")!
let day2 = try! String(contentsOf: fileURL)
let day2lines = day2.components(separatedBy: "\n")

print(checksum(input: day2lines))

//: [Next](@next)

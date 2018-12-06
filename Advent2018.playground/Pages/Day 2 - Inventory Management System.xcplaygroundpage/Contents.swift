//: [Previous](@previous)

import Foundation

// Part 1

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

// Part 2

let part2Test = """
abcde
fghij
klmno
pqrst
fguij
axcye
wvxyz
""".components(separatedBy: "\n")

// Strategy:
// For each line in the input:
//   compute a set where each char is replaced with " "
//   for each item in the set
//     if already exists in bag, return version with space stripped out
//     otherwise insert into set

func eachReplacedWithSpace(input: String) -> [String] {
    var result: [String] = []
    for index in input.indices {
        let range = index ... index

        var next = input
        next.replaceSubrange(range, with: " ")

        result.append(next)
    }
    return result
}

print(eachReplacedWithSpace(input: "abcde"))

func findSimilar(input: [String]) -> String {
    var soFar: Set<String> = []

    for line in input {
        let replaced = eachReplacedWithSpace(input: line)
        for value in replaced {
            if soFar.contains(value) {
                return value.filter { $0 != " " }
            } else {
                soFar.insert(value)
            }
        }
    }

    return ""
}

print(findSimilar(input: part2Test))
print(findSimilar(input: day2lines))

//: [Next](@next)

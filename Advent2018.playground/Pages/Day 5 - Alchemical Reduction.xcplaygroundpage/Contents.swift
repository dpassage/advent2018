//: [Previous](@previous)

import Foundation
import AdventLib

func fasterReact(inputChars: [Char]) -> [Char] {
    var outputChars = [Char]()
    for char in inputChars {
        guard let last = outputChars.last else {
            outputChars.append(char); continue
        }
        if char != last && char ~= last {
            (outputChars.removeLast())
        } else {
            (outputChars.append(char))
        }
    }

    return outputChars
}

func fasterReact(input: String) -> String {
    let inputChars = input.chars

    return String(fasterReact(inputChars: inputChars))
}

print(fasterReact(input: "aA"))
print(fasterReact(input: "abBA"))
print(fasterReact(input: "abAB"))
print(fasterReact(input: "aabAAB"))

print(fasterReact(input: "dabAcCaCBAcCcaDA"))

let url = Bundle.main.url(forResource: "day5.input", withExtension: "txt")!
let day5input = try! String(contentsOf: url).components(separatedBy: "\n").first! // chop newline
print(fasterReact(input: day5input).count)

func improveReaction(input: String) -> Int {
    var shortestSoFar = Int.max
    let inputChars = input.chars

    let letters: ClosedRange<Char> = "a"..."z"

    for letter in letters {
        let filteredChars = inputChars.filter { !($0 ~= letter) }
        let reactedLength = fasterReact(inputChars: filteredChars).count
        shortestSoFar = min(shortestSoFar, reactedLength)
    }

    return shortestSoFar
}

print(improveReaction(input: "dabAcCaCBAcCcaDA"))
print(improveReaction(input: day5input))

//: [Next](@next)

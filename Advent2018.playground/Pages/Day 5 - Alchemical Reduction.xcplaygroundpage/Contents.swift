//: [Previous](@previous)

import Foundation
import AdventLib

func fasterReact(input: String) -> String {
    let inputChars = input.chars
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

    return String(outputChars)
}

print(fasterReact(input: "aA"))
print(fasterReact(input: "abBA"))
print(fasterReact(input: "abAB"))
print(fasterReact(input: "aabAAB"))

print(fasterReact(input: "dabAcCaCBAcCcaDA"))

let url = Bundle.main.url(forResource: "day5.input", withExtension: "txt")!
let day5input = try! String(contentsOf: url).components(separatedBy: "\n").first! // chop newline
print(fasterReact(input: day5input).count)

//: [Next](@next)

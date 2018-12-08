//: [Previous](@previous)

import Foundation
import AdventLib

let chars = "foo".chars

func react(inputChars: [Char]) -> [Char] {
    var output = [Char]()
    print(inputChars.count)

    var index = 0
    while index < inputChars.count - 1 {
//        let this = (inputChars[index])
//        let next = (inputChars[index + 1])

        if inputChars[index] != inputChars[index + 1] && inputChars[index] ~= inputChars[index + 1] {
            (index += 2)
        } else {
            (output.append(inputChars[index]))
            (index += 1)
        }
    }

    if index == inputChars.count - 1 {
        output.append(inputChars[inputChars.count - 1])
    }
    return output
}

func fullyReact(inputChars: [Char]) -> [Char] {
    let reacted = react(inputChars: inputChars)
    if reacted == inputChars { return reacted }
    return fullyReact(inputChars: reacted)
}

func fullyReact(input: String) -> String {
    let chars = fullyReact(inputChars: input.chars)
    return String(chars)
}

print(fullyReact(input: "aA"))
print(fullyReact(input: "abBA"))
print(fullyReact(input: "abAB"))
print(fullyReact(input: "aabAAB"))

print(fullyReact(input: "dabAcCaCBAcCcaDA"))

let url = Bundle.main.url(forResource: "day5.input", withExtension: "txt")!
let day5input = try! String(contentsOf: url).components(separatedBy: "\n").first! // chop newline
print(fullyReact(input: day5input).count)

//: [Next](@next)

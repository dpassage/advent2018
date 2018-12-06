//: [Previous](@previous)

import Foundation

func calibrate(input: [String]) -> Int {
    return input.reduce(0) { (soFar, input) -> Int in
        return soFar + (Int(input) ?? 0)
    }
}

print(calibrate(input: "+1, +1, +1".components(separatedBy: ", ")))
print(calibrate(input: "+1, +1, -2".components(separatedBy: ", ")))
print(calibrate(input: "-1, -2, -3".components(separatedBy: ", ")))

let fileURL = Bundle.main.url(forResource: "day1.input", withExtension: "txt")!
let day1 = try! String(contentsOf: fileURL)
let day1lines = day1.components(separatedBy: "\n")

print(calibrate(input: day1lines))

func findRepat(input: [String]) -> Int {
    let changes = input.compactMap { Int($0) }

    var soFar: Set<Int> = [0]

    var currentFrequency = 0

    while true {
        for change in changes {
            currentFrequency += change
            if soFar.contains(currentFrequency) {
                return currentFrequency
            } else {
                soFar.insert(currentFrequency)
            }
        }
    }
}

print(findRepat(input: "+1, -2, +3, +1".components(separatedBy: ", ")))
print(findRepat(input: "+1, -1".components(separatedBy: ", ")))
print(findRepat(input: "+3, +3, +4, -2, -4".components(separatedBy: ", ")))
print(findRepat(input: "-6, +3, +8, +5, -6".components(separatedBy: ", ")))
print(findRepat(input: "+7, +7, -2, -7, -4".components(separatedBy: ", ")))

print(findRepat(input: day1lines))
//: [Next](@next)

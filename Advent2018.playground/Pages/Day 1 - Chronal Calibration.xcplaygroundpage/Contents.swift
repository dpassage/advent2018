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

//: [Next](@next)

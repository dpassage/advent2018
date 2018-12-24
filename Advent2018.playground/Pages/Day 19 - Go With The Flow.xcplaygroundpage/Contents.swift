//: [Previous](@previous)

import Foundation
import AdventLib

let testInput = """
#ip 0
seti 5 0 1
seti 6 0 2
addi 0 1 0
addr 1 2 3
setr 1 0 0
seti 8 0 4
seti 9 0 5
"""

var testDevice = Device(input: testInput)
testDevice.run()
print(testDevice)

//let url = Bundle.main.url(forResource: "day19.input", withExtension: "txt")!
//let day19input = try! String(contentsOf: url)
//
//print("==== part 1")
//var day19device = Device(input: day19input)
////day19device.printSteps = true
//day19device.run() // answer was 930
//print(day19device.registers)

//print("==== part 2")
//var part2device = Device(input: day19input)
//part2device.registers[0] = 1
//part2device.printSteps = true
//part2device.run(to: 1000)
//print(part2device.registers) // 10551330 is too low

let testProgramUrl = Bundle.main.url(forResource: "test.input", withExtension: "txt")!
let testProgramInput = try! String(contentsOf: testProgramUrl)

for i in 2...10 {
    var device = Device(input: testProgramInput)
    device.registers[0] = i
    device.run()
    print("input \(i) result \(device.registers[0])")
}

//input 2 result 3   1 + 2
//input 3 result 4   1 + 3
//input 4 result 7   1 + 2 + 4
//input 5 result 6
//input 6 result 12
//input 7 result 8
//input 8 result 15
//input 9 result 13
//input 10 result 18
// program computes sum of all factors!

// prime factorization of 10551329: 137 × 77017
// so answer is: 1 + 137 + 77017 + 10551329 => 10628484
//: [Next](@next)

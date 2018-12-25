//: [Previous](@previous)

import Foundation

let url = Bundle.main.url(forResource: "day21.input", withExtension: "txt")!
let day21input = try! String(contentsOf: url)

var lastValue = -1
var seenValues: Set<Int> = []
var device = Device(input: day21input)
device.stopIp = 28
device.stopBlock = { device in
    let value = device.registers[1]
    if seenValues.contains(value) {
        fatalError("======cycle! lastvalue was \(lastValue)")
    }
    lastValue = value
    seenValues.insert(value)
}
device.run()
print(device.ip, device.registers)

// part 1 is 10332277: the value of r1 the first time it hits instruction 28.
// part 2 is 13846724: this is the last value of r1 before it cycles to a previous value.
//: [Next](@next)

//: [Previous](@previous)

import Foundation

let url = Bundle.main.url(forResource: "day21.input", withExtension: "txt")!
let day21input = try! String(contentsOf: url)

var device = Device(input: day21input)
device.stopIp = 28
device.run()
print(device.ip, device.registers)

// part 1 is 10332277: the value of r1 the first time it hits instruction 28.

//: [Next](@next)

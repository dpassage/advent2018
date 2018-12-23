//: [Previous](@previous)

import Foundation
import AdventLib

typealias Operation = (inout Device, Int, Int, Int) -> ()

struct InstructionSet: CustomStringConvertible {

    var opCodes = [[Operation]](repeating: InstructionSet.allMethods, count: 16)

    var description: String {
        var result = ""
        for i in 0..<opCodes.count {
            result.append("code \(i) instructions \(opCodes[i].count)\n")
        }
        return result
    }

    mutating func train(_ testCase: TestCase) {
        let opCode = testCase.instruction.opCode
        var instructions = opCodes[opCode]
        print("testing \(instructions.count) instructions for opcode \(opCode)")
        instructions = instructions.filter { instruction in
            var device = Device(registers: testCase.before)
            device.apply(instruction, a: testCase.instruction.a, b: testCase.instruction.b, c: testCase.instruction.c)
            print(device.registers, testCase.after)
            return device.registers == testCase.after
        }
        print("result \(instructions.count) instructions")
        opCodes[testCase.instruction.opCode] = instructions
    }

    // addr (add register) stores into register C the result of adding register A and register B.
    static func addr(device: inout Device, a: Int, b: Int, c: Int) {
        device.registers[c] = device.registers[a] + device.registers[b]
    }
    // addi (add immediate) stores into register C the result of adding register A and value B.
    static func addi(device: inout Device, a: Int, b: Int, c: Int) {
        device.registers[c] = device.registers[a] + b
    }

    // mulr (multiply register) stores into register C the result of multiplying register A and register B.
    static func mulr(device: inout Device, a: Int, b: Int, c: Int) {
        device.registers[c] = device.registers[a] * device.registers[b]
    }

    // muli (multiply immediate) stores into register C the result of multiplying register A and value B.
    static func muli(device: inout Device, a: Int, b: Int, c: Int) {
        device.registers[c] = device.registers[a] * b
    }

    // banr (bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.
    static func banr(device: inout Device, a: Int, b: Int, c: Int) {
        device.registers[c] = device.registers[a] & device.registers[b]
    }

    // bani (bitwise AND immediate) stores into register C the result of the bitwise AND of register A and value B.
    static func bani(device: inout Device, a: Int, b: Int, c: Int) {
        device.registers[c] = device.registers[a] & b
    }

    // borr (bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.
    static func borr(device: inout Device, a: Int, b: Int, c: Int) {
        device.registers[c] = device.registers[a] | device.registers[b]
    }

    // bori (bitwise OR immediate) stores into register C the result of the bitwise OR of register A and value B.
    static func bori(device: inout Device, a: Int, b: Int, c: Int) {
        device.registers[c] = device.registers[a] | b
    }

    // setr (set register) copies the contents of register A into register C. (Input B is ignored.)
    static func setr(device: inout Device, a: Int, b: Int, c: Int) {
        device.registers[c] = device.registers[a]
    }

    // seti (set immediate) stores value A into register C. (Input B is ignored.)
    static func seti(device: inout Device, a: Int, b: Int, c: Int) {
        device.registers[c] = a
    }

    //    Greater-than testing:
    // gtir (greater-than immediate/register) sets register C to 1 if value A is greater than register B. Otherwise,
    // register C is set to 0.
    static func gtir(device: inout Device, a: Int, b: Int, c: Int) {
        device.registers[c] = a > device.registers[b] ? 1 : 0
    }

    // gtri (greater-than register/immediate) sets register C to 1 if register A is greater than value B. Otherwise,
    // register C is set to 0.
    static func gtri(device: inout Device, a: Int, b: Int, c: Int) {
        device.registers[c] = device.registers[a] > b ? 1 : 0
    }

    // gtrr (greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise,
    // register C is set to 0.
    static func gtrr(device: inout Device, a: Int, b: Int, c: Int) {
        device.registers[c] = device.registers[a] > device.registers[b] ? 1 : 0
    }

    // Equality testing:
    // eqir (equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is
    // set to 0.
    static func eqir(device: inout Device, a: Int, b: Int, c: Int) {
        device.registers[c] = a == device.registers[b] ? 1 : 0
    }
    // eqri (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is
    // set to 0.
    static func eqri(device: inout Device, a: Int, b: Int, c: Int) {
        device.registers[c] = device.registers[a] == b ? 1 : 0
    }
    // eqrr (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C
    // is set to 0.
    static func eqrr(device: inout Device, a: Int, b: Int, c: Int) {
        device.registers[c] = device.registers[a] == device.registers[b] ? 1 : 0
    }

    static var allMethods = [
        addr,
        addi,
        mulr,
        muli,
        banr,
        bani,
        borr,
        bori,
        setr,
        seti,
        gtir,
        gtri,
        gtrr,
        eqir,
        eqri,
        eqrr,
        ]
}

struct Device: CustomStringConvertible {
    var registers: [Int] = [0, 0, 0, 0]

    init(registers: [Int]) { self.registers = registers }

    mutating func apply(_ operation: Operation, a: Int, b: Int, c: Int) {
        operation(&self, a, b, c)
    }

    mutating func execute(instruction: Instruction, instructionSet: InstructionSet) {
        let opCode = instruction.opCode
        let operation = instructionSet.opCodes[opCode].first!
        print(self, instruction)
        apply(operation, a: instruction.a, b: instruction.b, c: instruction.c)
    }

    mutating func program(instructions: [Instruction], instructionSet: InstructionSet) {
        for instruction in instructions {
            execute(instruction: instruction, instructionSet: instructionSet)
        }
    }

    var description: String {
        return "\(registers)"
    }
}

let input = """
Before: [3, 2, 1, 1]
9 2 1 2
After:  [3, 2, 2, 1]

Before: [3, 2, 1, 1]
9 2 1 2
After:  [3, 2, 2, 1]
"""

struct Instruction {
    var opCode: Int
    var a: Int
    var b: Int
    var c: Int

    init?(line: String) {
        let numbers = line.components(separatedBy: " ").compactMap { Int($0) }
        guard numbers.count == 4 else { return nil }
        opCode = numbers[0]
        a = numbers[1]
        b = numbers[2]
        c = numbers[3]
    }
}

struct TestCase {
    static let regex = try! Regex(pattern: ".*\\[(\\d), (\\d), (\\d), (\\d)\\]")
    var before: [Int]
    var instruction: Instruction
    var after: [Int]

    init?(input: String) {
        let lines = input.components(separatedBy: "\n")
        guard lines.count == 3 else { return nil }
        guard let before = TestCase.regex.match(input: lines[0])?.compactMap({ Int($0) }) else {
            return nil
        }
        self.before = before
        guard let instruction = Instruction(line: lines[1]) else { return nil }
        self.instruction = instruction
        guard let after = TestCase.regex.match(input: lines[2])?.compactMap({ Int($0) }) else {
            return nil
        }
        self.after = after
    }

    func validOperations() -> Int {
        var valid = 0
        for method in InstructionSet.allMethods {
            var device = Device(registers: before)
            method(&device, instruction.a, instruction.b, instruction.c)
            if device.registers == after {
                valid += 1
            }

        }
        return valid
    }
}

let testCases = input.components(separatedBy: "\n\n").compactMap(TestCase.init)
print(testCases)

print(testCases.map { $0.validOperations() })

let url = Bundle.main.url(forResource: "day16.input", withExtension: "txt")!
let day16input = try! String(contentsOf: url)
let day16sections = day16input.components(separatedBy: "\n\n\n\n")
let day16cases = day16sections[0].components(separatedBy: "\n\n").compactMap(TestCase.init)
print(day16cases.count)
let day16results = day16cases.map { $0.validOperations() }
print(day16results)
print(day16results.filter { $0 >= 3 }.count)

let day16instructions = day16sections[1].components(separatedBy: "\n").compactMap(Instruction.init)

var instructionSet = InstructionSet()
for i in 0..<16 {
    let testCases = day16cases.filter { $0.instruction.opCode == i }
    for testCase in testCases {
        instructionSet.train(testCase)
    }
}
print(instructionSet)

var finalDevice = Device(registers: [0, 0, 0, 0])
finalDevice.program(instructions: day16instructions, instructionSet: instructionSet)
print(finalDevice)

//: [Next](@next)

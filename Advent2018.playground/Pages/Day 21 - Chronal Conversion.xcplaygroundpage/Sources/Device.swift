import Foundation

import AdventLib

enum Operation: String, CaseIterable {
    case addr
    case addi
    case mulr
    case muli
    case banr
    case bani
    case borr
    case bori
    case setr
    case seti
    case gtir
    case gtri
    case gtrr
    case eqir
    case eqri
    case eqrr

    var op: (inout Device, Int, Int, Int) -> () {
        switch self {
        case .addr: return InstructionSet.addr
        case .addi: return InstructionSet.addi
        case .mulr: return InstructionSet.mulr
        case .muli: return InstructionSet.muli
        case .banr: return InstructionSet.banr
        case .bani: return InstructionSet.bani
        case .borr: return InstructionSet.borr
        case .bori: return InstructionSet.bori
        case .setr: return InstructionSet.setr
        case .seti: return InstructionSet.seti
        case .gtir: return InstructionSet.gtir
        case .gtri: return InstructionSet.gtri
        case .gtrr: return InstructionSet.gtrr
        case .eqir: return InstructionSet.eqir
        case .eqri: return InstructionSet.eqri
        case .eqrr: return InstructionSet.eqrr
        }
    }
}

struct InstructionSet {
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
}

struct Instruction: CustomStringConvertible {
    var op: Operation
    var a: Int
    var b: Int
    var c: Int

    var description: String {
        return "op: \(op.rawValue), a: \(a), b: \(b), c: \(c)"
    }
}

public struct Device {
    public var registers: [Int]
    public var ip: Int
    var ipRegister: Int
    var instructions: [Instruction]
    public var steps = 0
    public var printSteps = false
    public var stopIp = Int.max
    public var stopBlock: (Device) -> () = { _ in }

    public init(input: String) {
        registers = [0, 0, 0, 0, 0, 0]
        ip = 0
        ipRegister = 0
        instructions = []
        for line in input.components(separatedBy: "\n") {
            if line.hasPrefix("#ip") {
                let parts = line.components(separatedBy: " ")
                if parts.count == 2, let ipRegister = Int(parts[1]) {
                    self.ipRegister = ipRegister
                }
            } else {
                let parts = line.components(separatedBy: " ")
                guard parts.count >= 4,
                    let operation = Operation(rawValue: parts[0]),
                    let a = Int(parts[1]),
                    let b = Int(parts[2]),
                    let c = Int(parts[3]) else { continue }
                instructions.append(Instruction(op: operation, a: a, b: b, c: c))
            }
        }
    }

    // returns true if next instruction is legal
    public mutating func step() -> Bool {
        guard instructions.indices.contains(ip) else { return false }
        let instruction = instructions[ip]
        registers[ipRegister] = ip
        if ip == stopIp {
            stopBlock(self)
        }
        instruction.op.op(&self, instruction.a, instruction.b, instruction.c)
        ip = registers[ipRegister]
        ip += 1
        steps += 1
        return true
    }

    public mutating func run(to: Int = Int.max) {
        while step() && steps < to {
        }
    }
}

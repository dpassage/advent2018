//: [Previous](@previous)

import Foundation

struct Device {
    var registers: [Int] = [0, 0, 0, 0]

    // addr (add register) stores into register C the result of adding register A and register B.
    mutating func addr(a: Int, b: Int, c: Int) {
        registers[c] = registers[a] + registers[b]
    }
    // addi (add immediate) stores into register C the result of adding register A and value B.
    mutating func addi(a: Int, b: Int, c: Int) {
        registers[c] = registers[a] + b
    }

    // mulr (multiply register) stores into register C the result of multiplying register A and register B.
    mutating func mulr(a: Int, b: Int, c: Int) {
        registers[c] = registers[a] * registers[b]
    }

    // muli (multiply immediate) stores into register C the result of multiplying register A and value B.
    mutating func muli(a: Int, b: Int, c: Int) {
        registers[c] = registers[a] * b
    }

    // banr (bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.
    mutating func banr(a: Int, b: Int, c: Int) {
        registers[c] = registers[a] & registers[b]
    }

    // bani (bitwise AND immediate) stores into register C the result of the bitwise AND of register A and value B.
    mutating func bani(a: Int, b: Int, c: Int) {
        registers[c] = registers[a] & b
    }

    // borr (bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.
    mutating func borr(a: Int, b: Int, c: Int) {
        registers[c] = registers[a] | registers[b]
    }

    // bori (bitwise OR immediate) stores into register C the result of the bitwise OR of register A and value B.
    mutating func bori(a: Int, b: Int, c: Int) {
        registers[c] = registers[a] | b
    }

    // setr (set register) copies the contents of register A into register C. (Input B is ignored.)
    mutating func setr(a: Int, b: Int, c: Int) {
        registers[c] = registers[a]
    }

    // seti (set immediate) stores value A into register C. (Input B is ignored.)
    mutating func seti(a: Int, b: Int, c: Int) {
        registers[c] = a
    }

    //    Greater-than testing:
    // gtir (greater-than immediate/register) sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.
    mutating func gtir(a: Int, b: Int, c: Int) {
        registers[c] = a > registers[b] ? 1 : 0
    }

    // gtri (greater-than register/immediate) sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0.
    mutating func gtri(a: Int, b: Int, c: Int) {
        registers[c] = registers[a] > b ? 1 : 0
    }

    // gtrr (greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.
    mutating func gtrr(a: Int, b: Int, c: Int) {
        registers[c] = registers[a] > registers[b] ? 1 : 0
    }

//    Equality testing:
//
//    eqir (equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.
    mutating func eqir(a: Int, b: Int, c: Int) {
        registers[c] = a == registers[b] ? 1 : 0
    }
//    eqri (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.
    mutating func eqri(a: Int, b: Int, c: Int) {
        registers[c] = registers[a] == b ? 1 : 0
    }
//    eqrr (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.
    mutating func eqrr(a: Int, b: Int, c: Int) {
        registers[c] = registers[a] == registers[b] ? 1 : 0
    }
}


//: [Next](@next)

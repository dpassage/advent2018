//: [Previous](@previous)

import Foundation
import AdventLib

enum AttackType: String, CustomStringConvertible {
    case fire
    case slashing
    case bludgeoning
    case radiation
    case cold

    var description: String { return self.rawValue }
}

class Group {
    var units: Int
    var hitPoints: Int
    var attackDamage: Int
    var attackType: AttackType
    var initiative: Int

    var weak: [AttackType] = []
    var immune: [AttackType] = []

    static let regex = try! Regex(pattern: "(\\d+) units each with (\\d+) hit points( \\(([a-z, ;]*)\\))? with an attack that does (\\d+) ([a-z]+) damage at initiative (\\d+)")
    init?(line: String) {
        guard let matches = Group.regex.match(input: line) else { return nil }
        print(matches)
        if matches.count == 7 {
            guard let units = Int(matches[0]),
                let hitPoints = Int(matches[1]),
                let attackDamage = Int(matches[4]),
                let attackType = AttackType(rawValue: matches[5]),
                let initiative = Int(matches[6]) else { return nil }
            self.units = units
            self.hitPoints = hitPoints
            self.attackDamage = attackDamage
            self.attackType = attackType
            self.initiative = initiative

            let modifiers = matches[3].components(separatedBy: "; ")
            for modifier in modifiers {
                let parsed = modifier.components(separatedBy: " to ")
                let types = parsed[1].components(separatedBy: ", ").compactMap(AttackType.init(rawValue:))
                if parsed[0] == "weak" {
                    self.weak = types
                } else {
                    self.immune = types
                }
            }
        } else if matches.count == 5 {
            guard let units = Int(matches[0]),
                let hitPoints = Int(matches[1]),
                let attackDamage = Int(matches[2]),
                let attackType = AttackType(rawValue: matches[3]),
                let initiative = Int(matches[4]) else { return nil }
            self.units = units
            self.hitPoints = hitPoints
            self.attackDamage = attackDamage
            self.attackType = attackType
            self.initiative = initiative
        } else {
            return nil
        }
    }
}

let group = Group(line: "8897 units each with 6420 hit points (immune to bludgeoning, slashing, fire; weak to radiation) with an attack that does 1 bludgeoning damage at initiative 19")
print(String(describing: group))

let group2 = Group(line: "1590 units each with 3940 hit points with an attack that does 24 cold damage at initiative 5")
print(String(describing: group2))

struct Battle {
    var immune: [Group] = []
    var infection: [Group] = []

    enum Side: String {
        case immune = "Immune System"
        case infection = "Infection"
    }

    init(input: String) {
        let lines = input.components(separatedBy: "\n")
        var currentSide: Side = .immune
        for line in lines {
            if line.hasPrefix("Immune System") {
                currentSide = .immune
            } else if line.hasPrefix("Infection") {
                currentSide = .infection
            } else if let group = Group(line: line) {
                if currentSide == .immune {
                    self.immune.append(group)
                } else {
                    self.infection.append(group)
                }
            }
        }
    }
}

let testInput = """
Immune System:
17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2
989 units each with 1274 hit points (immune to fire; weak to bludgeoning, slashing) with an attack that does 25 slashing damage at initiative 3

Infection:
801 units each with 4706 hit points (weak to radiation) with an attack that does 116 bludgeoning damage at initiative 1
4485 units each with 2961 hit points (immune to radiation; weak to fire, cold) with an attack that does 12 slashing damage at initiative 4
"""

var testBattle = Battle(input: testInput)
print(testBattle)

//: [Next](@next)

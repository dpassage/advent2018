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

enum Side: String {
    case immune = "Immune System"
    case infection = "Infection"
}

class Group {
    var units: Int
    var hitPoints: Int
    var attackDamage: Int
    var attackType: AttackType
    var initiative: Int

    var weak: [AttackType] = []
    var immune: [AttackType] = []

    var number: Int = 0
    var side: Side

    static let regex = try! Regex(pattern: "(\\d+) units each with (\\d+) hit points( \\(([a-z, ;]*)\\))? with an attack that does (\\d+) ([a-z]+) damage at initiative (\\d+)")
    init?(line: String, side: Side) {
        self.side = side
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

    var effectivePower: Int { return units * attackDamage }

    func damageTo(_ target: Group) -> Int {
        if target.immune.contains(self.attackType) { return 0 }
        if target.weak.contains(self.attackType) {
            return effectivePower * 2
        } else {
            return effectivePower
        }
    }

    // apply the amount of damage; return number of units destroyed
    func takeDamage(_ damage: Int) -> Int {
        var unitsKilled = damage / hitPoints
        if unitsKilled > units {
            unitsKilled = units
        }
        units -= unitsKilled
        return unitsKilled
    }
}

let group = Group(line: "8897 units each with 6420 hit points (immune to bludgeoning, slashing, fire; weak to radiation) with an attack that does 1 bludgeoning damage at initiative 19", side: .immune)
print(String(describing: group))

let group2 = Group(line: "1590 units each with 3940 hit points with an attack that does 24 cold damage at initiative 5", side: .immune)
print(String(describing: group2))

struct Battle {
    var immune: [Group] = []
    var infection: [Group] = []

    init(input: String) {
        let lines = input.components(separatedBy: "\n")
        var currentSide: Side = .immune
        for line in lines {
            if line.hasPrefix("Immune System") {
                currentSide = .immune
            } else if line.hasPrefix("Infection") {
                currentSide = .infection
            } else if let group = Group(line: line, side: currentSide) {
                if currentSide == .immune {
                    self.immune.append(group)
                    group.number = immune.count
                } else {
                    self.infection.append(group)
                    group.number = infection.count
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

extension Battle {
    func printStatus() {
        print("Immune System:")
        if immune.count == 0 {
            print("No groups remain.")
        } else {
            for group in immune {
                print("Group \(group.number) contains \(group.units) units")
            }
        }
        print("Infection:")
        if infection.count == 0 {
            print("No groups remain.")
        } else {
            for group in infection {
                print("Group \(group.number) contains \(group.units) units")
            }
        }
    }

    mutating func round() {
        // target selection
        var allAttackers = immune + infection
        var allTargets = immune + infection

        var allAttacks: [(attacker: Group, target: Group)] = []

        allAttackers.sort { (lhs, rhs) -> Bool in
            if lhs.effectivePower == rhs.effectivePower {
                return lhs.initiative > rhs.initiative
            }
            return lhs.effectivePower > rhs.effectivePower
        }

        for attacker in allAttackers {
            let potentialTargets = allTargets.filter { $0.side != attacker.side }
            for potentialTarget in potentialTargets {
                // Infection group 1 would deal defending group 1 185832 damage
                print("\(attacker.side.rawValue) group \(attacker.number) would deal defending group \(potentialTarget.number) \(attacker.damageTo(potentialTarget)) damage")
            }
            let sortedTargets = potentialTargets.sorted { (lhs, rhs) -> Bool in
                let left = [attacker.damageTo(lhs), lhs.effectivePower, lhs.initiative]
                let right = [attacker.damageTo(rhs), rhs.effectivePower, rhs.initiative]
                return left > right
            }
            if let target = sortedTargets.first, attacker.damageTo(target) > 0 {
                allAttacks.append((attacker, target))
                allTargets.removeAll { $0 === target }
            }
        }

        print("")

        let sortedAttacks = allAttacks.sorted { $0.attacker.initiative > $1.attacker.initiative }
        // execute attacks {
        for (attacker, target) in sortedAttacks {
            guard attacker.units > 0 else { continue }
            let damage = attacker.damageTo(target)
            let unitsKilled = target.takeDamage(damage)
            // Infection group 1 attacks defending group 1, killing 17 units
            print("\(attacker.side.rawValue) group \(attacker.number) attacks defending group \(target.number), killing \(unitsKilled) units")
        }

        // cull the dead
        immune = immune.filter { $0.units > 0 }
        infection = infection.filter { $0.units > 0 }
    }

    mutating func battle() {
        while true {
            printStatus()
            print("")
            if immune.count > 0 && infection.count > 0 {
                round()
                print("\n")
            } else {
                let totalRemaining = immune.reduce(0, { $0 + $1.units }) + infection.reduce(0, { $0 + $1.units })
                print("Total remaining: \(totalRemaining)")
                return
            }
        }
    }
}

testBattle.battle()

let url = Bundle.main.url(forResource: "day24.input", withExtension: "txt")!
let day24input = try! String(contentsOf: url)
var day24battle = Battle(input: day24input)
day24battle.battle()

//: [Next](@next)

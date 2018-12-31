//: [Previous](@previous)

import Foundation
import AdventLib


let group = Group(line: "8897 units each with 6420 hit points (immune to bludgeoning, slashing, fire; weak to radiation) with an attack that does 1 bludgeoning damage at initiative 19", side: .immune)
print(String(describing: group))

let group2 = Group(line: "1590 units each with 3940 hit points with an attack that does 24 cold damage at initiative 5", side: .immune)
print(String(describing: group2))


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

testBattle.battle()

let url = Bundle.main.url(forResource: "day24.input", withExtension: "txt")!
let day24input = try! String(contentsOf: url)

for i in 25..<Int.max {
    print("Boosting by \(i)")
    var battle = Battle(input: day24input, boost: i)
    battle.log = false
    battle.battle()
    print("Total remaining units: \(battle.totalRemaining)")
    if battle.reindeerWon {
        print("Reindeer win with boost \(i)")
        break
    }
}
// 4009 was correct!

//: [Next](@next)

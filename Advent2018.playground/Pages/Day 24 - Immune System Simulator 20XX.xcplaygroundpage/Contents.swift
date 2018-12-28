//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

enum AttackType {
    case fire
    case slashing
    case bludgeoning
    case radiation
    case cold
}
struct Group {
    var units: Int
    var hitPoints: Int
    var attackDamage: Int
    var attackType: AttackType
    var initiative: Int

    var weak: [AttackType]
    var immune: [AttackType]
}
//: [Next](@next)

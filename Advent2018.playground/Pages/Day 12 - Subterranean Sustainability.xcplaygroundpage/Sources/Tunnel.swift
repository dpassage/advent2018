import Foundation
import AdventLib

public struct Rule {
    var pattern: [Bool]
    var result: Bool
}

let ruleRegex = try! Regex(pattern: "([#\\.]{5}) => ([#\\.])")
extension Rule {
    public init?(line: String) {
        guard let matches = ruleRegex.match(input: line),
            matches.count == 2 else { return nil }
        pattern = matches[0].map { $0 == "#" }
        guard let resultChar = matches[1].first else { return nil }
        result = (resultChar == "#")
    }
}

public struct RuleSet {
    var rules: [Bool] = [Bool](repeating: false, count: 32)

    func ruleNumber(for pattern: [Bool]) -> Int {
        return pattern.reduce(0) { (number, next) -> Int in
            return (number * 2) + (next ? 1 : 0)
        }
    }

    mutating func insert(_ rule: Rule) {
        let slot = ruleNumber(for: rule.pattern)
        rules[slot] = rule.result
    }

    mutating func setup(rules: [Rule]) {
        for rule in rules {
            insert(rule)
        }
    }

    func applyTo(input: [Bool]) -> Bool {
        let slot = ruleNumber(for: input)
        return rules[slot]
    }
}

public struct Tunnel {
    var pots: TwoWayArray<Bool>
    var rules: RuleSet

    public init(input: String) {
        self.pots = TwoWayArray(repeating: false, count: 20_000, firstIndex: -10_000)
        self.rules = RuleSet()

        for line in input.components(separatedBy: "\n") {
            if line.hasPrefix("initial state:") {
                print(line)
                let initialPots: [Bool] = line.compactMap {
                    switch $0 {
                    case "#": return true
                    case ".": return false
                    default: return nil
                    }
                }
                for (index, pot) in initialPots.enumerated() {
                    pots[index] = pot
                }
            } else if let rule = Rule(line: line) {
                rules.insert(rule)
            }
        }
    }

    public mutating func generation() {
        var newPots = pots
        for i in pots.indices {
            if i + 5 > pots.endIndex { break }
            let potPattern = pots[i..<i+5]
            newPots[i + 2] = rules.applyTo(input: [Bool](potPattern))
        }
        pots = newPots
    }

    public mutating func generations(_ count: Int) {
        for _ in 0..<count {
            generation()
        }
    }

    public func sumOfPotIndices() -> Int {
        var result = 0
        for i in pots.startIndex ..< pots.endIndex {
            result += pots[i] ? i : 0
        }
        return result
    }
}

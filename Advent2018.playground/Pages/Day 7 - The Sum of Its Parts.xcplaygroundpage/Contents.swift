//: [Previous](@previous)

import Foundation
import AdventLib

let testInput = """
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.
""".components(separatedBy: "\n")

struct Rule {
    var from: String
    var to: String
}

extension Rule {
    init?(line: String) {
        let regex = try! Regex(pattern: "Step ([A-Z]) must be finished before step ([A-Z]) can begin\\.")
        guard let matches = regex.match(input: line), matches.count == 2 else { return nil }
        from = matches[0]
        to = matches[1]
    }
}

let testRules = testInput.compactMap(Rule.init)
print(testRules)

struct Node {
    var name: String
    var requires: Set<String>
}

extension Node: CustomStringConvertible {
    var description: String {
        return "\(name): requires \(requires)"
    }
}

func build(rules: [Rule]) -> String {

    var nodeSet: [String: Node] = [:]
    var allSteps: Set<String> = []
    for rule in rules {
        allSteps.insert(rule.from)
        allSteps.insert(rule.to)

        if nodeSet.keys.contains(rule.to) {
            nodeSet[rule.to]?.requires.insert(rule.from)
        } else {
            nodeSet[rule.to] = Node(name: rule.to, requires: [rule.from])
        }
        print(nodeSet)
    }
    print(allSteps)

    let remainingSteps = allSteps.subtracting(nodeSet.keys)
    print("remainingSteps: \(remainingSteps)")

    var availableSteps = Heap<String>(priorityFunction: <)
    for step in remainingSteps {
        availableSteps.enqueue(step)
    }

    var stepsTaken = [String]()

    while let nextStep = availableSteps.dequeue() {
        stepsTaken.append(nextStep)
        for key in nodeSet.keys {
            nodeSet[key]!.requires.remove(nextStep)
            if nodeSet[key]!.requires.isEmpty {
                nodeSet[key] = nil
                availableSteps.enqueue(key)
            }
        }
    }

    return stepsTaken.joined()
}

print(build(rules: testRules))

let url = Bundle.main.url(forResource: "day7.input", withExtension: "txt")!
let day7lines = try! String(contentsOf: url).components(separatedBy: "\n")
let day7rules = day7lines.compactMap(Rule.init)

print(build(rules: day7rules))


//: [Next](@next)

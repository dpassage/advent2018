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
    var from: Char
    var to: Char
}

extension Rule {
    init?(line: String) {
        let regex = try! Regex(pattern: "Step ([A-Z]) must be finished before step ([A-Z]) can begin\\.")
        guard let matches = regex.match(input: line), matches.count == 2 else { return nil }
        from = matches[0].chars.first!
        to = matches[1].chars.first!
    }
}

let testRules = testInput.compactMap(Rule.init)
print(testRules)

struct Node {
    var name: Char
    var requires: Set<Char>
}

extension Node: CustomStringConvertible {
    var description: String {
        return "\(name): requires \(requires)"
    }
}

func build(rules: [Rule]) -> String {

    var nodeSet: [Char: Node] = [:]
    var allSteps: Set<Char> = []
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

    var availableSteps = Heap<Char>(priorityFunction: <)
    for step in remainingSteps {
        availableSteps.enqueue(step)
    }

    var stepsTaken = [Char]()

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

    return String(stepsTaken)
}

print(build(rules: testRules))

let url = Bundle.main.url(forResource: "day7.input", withExtension: "txt")!
let day7lines = try! String(contentsOf: url).components(separatedBy: "\n")
let day7rules = day7lines.compactMap(Rule.init)

print(build(rules: day7rules))

// Part 2

struct Worker {
    var currentStep: Char?
    var secondsLeft: Int

    var isBusy: Bool { return currentStep != nil }
    mutating func work() { secondsLeft -= 1 }
    var isDone: Bool { return secondsLeft <= 0 }
}

extension Worker: CustomStringConvertible {
    var description: String {
        if let currentStep = currentStep {
            return "\(currentStep): \(secondsLeft) remaining"
        } else {
            return "idle"
        }
    }
}

func hardBuild(rules: [Rule], workers workerCount: Int, minSecs: Int) -> Int {
    var time = 0

    var nodeSet: [Char: Node] = [:]
    var allSteps: Set<Char> = []
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

    var availableSteps = Heap<Char>(priorityFunction: <)
    for step in remainingSteps {
        availableSteps.enqueue(step)
    }

    var stepsTaken = [Char]()

    var workers = [Worker](repeating: Worker(currentStep: nil, secondsLeft: 0), count: workerCount)

    while !availableSteps.isEmpty || !(workers.compactMap { $0.currentStep }.isEmpty) {
        print(workers)
        // each time around is 1 second.
        // first, the workers work.
        for i in 0..<workers.count {
            if let currentStep = workers[i].currentStep {
                workers[i].work()
                if workers[i].isDone {
                    workers[i].currentStep = nil
                    stepsTaken.append(currentStep)
                    for key in nodeSet.keys {
                        nodeSet[key]!.requires.remove(currentStep)
                        if nodeSet[key]!.requires.isEmpty {
                            nodeSet[key] = nil
                            availableSteps.enqueue(key)
                        }
                    }
                }
            }
        }

        // then, idle workers get loaded up
        for i in 0..<workers.count {
            if !workers[i].isBusy {
                if let nextStep = availableSteps.dequeue() {
                    let time = -(nextStep.distance(to: "A")) + 1 + minSecs
                    workers[i].currentStep = nextStep
                    workers[i].secondsLeft = time
                }
            }
        }

        time += 1
    }

    print(stepsTaken)
    return (time - 1)
}

print(hardBuild(rules: testRules, workers: 2, minSecs: 0))

print(hardBuild(rules: day7rules, workers: 5, minSecs: 60))
//: [Next](@next)

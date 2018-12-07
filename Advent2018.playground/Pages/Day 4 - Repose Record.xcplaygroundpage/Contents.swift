//: [Previous](@previous)

import Foundation

let testInput = """
[1518-11-01 00:00] Guard #10 begins shift
[1518-11-01 00:05] falls asleep
[1518-11-01 00:25] wakes up
[1518-11-01 00:30] falls asleep
[1518-11-01 00:55] wakes up
[1518-11-01 23:58] Guard #99 begins shift
[1518-11-02 00:40] falls asleep
[1518-11-02 00:50] wakes up
[1518-11-03 00:05] Guard #10 begins shift
[1518-11-03 00:24] falls asleep
[1518-11-03 00:29] wakes up
[1518-11-04 00:02] Guard #99 begins shift
[1518-11-04 00:36] falls asleep
[1518-11-04 00:46] wakes up
[1518-11-05 00:03] Guard #99 begins shift
[1518-11-05 00:45] falls asleep
[1518-11-05 00:55] wakes up
""".components(separatedBy: "\n")

struct Sleep {
    var start: Int
    var end: Int

    var length: Int { return end - start }
}

struct Guard {
    var sleeps: [Sleep] = []

    mutating func startSleeping(at: Int) {
        let newSleep = Sleep(start: at, end: Int.max)
        sleeps.append(newSleep)
    }

    mutating func stopSleeping(at: Int) {
        sleeps[sleeps.count - 1].end = at
    }

    var totalSleeps: Int { return sleeps.reduce(0, { return $0 + $1.length }) }

    func sleepiestMinute() -> (minute: Int, sleeps: Int) {
        var minutes: [Int: Int] = [:]
        for sleep in sleeps {
            for minute in sleep.start ..< sleep.end {
                minutes[minute, default: 0] += 1
            }
        }

        let keyValue = minutes.sorted { $0.value > $1.value }.first!
        return (minute: keyValue.key, sleeps: keyValue.value)
    }
}

struct GuardSet {
    var guards: [Int: Guard] = [:]

    subscript(id: Int) -> Guard {
        get { return guards[id] ?? Guard() }
        set { guards[id] = newValue }
    }

    init(lines: [Line]) {
        var currentGuard = -1
        for line in lines {
            switch line {
            case let .newGuard(id: id): currentGuard = id
            case let .startSleep(at: minute): guards[currentGuard, default: Guard()].startSleeping(at: minute)
            case let .endSleep(at: minute): guards[currentGuard, default: Guard()].stopSleeping(at: minute)
            }
        }

    }
}

enum Line {
    case newGuard(id: Int)
    case startSleep(at: Int)
    case endSleep(at: Int)

    private static let newGuardRegex = try! Regex(pattern: ".* Guard #(\\d+) begins shift")
    private static let startSleepRegex = try! Regex(pattern: "\\[.*:(\\d\\d)] falls asleep")
    private static let endSleepRegex = try! Regex(pattern: "\\[.*:(\\d\\d)] wakes up")

    init?(text: String) {
        if let matches = Line.newGuardRegex.match(input: text),
            let id = Int(matches[0]) {
            self = .newGuard(id: id)
        } else if let matches = Line.startSleepRegex.match(input: text),
            let minute = Int(matches[0]) {
            self = .startSleep(at: minute)
        } else if let matches = Line.endSleepRegex.match(input: text),
            let minute = Int(matches[0]) {
            self = .endSleep(at: minute)
        } else {
            return nil
        }
    }

}

let testLines = testInput.compactMap { Line(text: $0) }
print(testLines)

func strategyOne(lines: [Line]) -> Int {
    let guardSet = GuardSet(lines: lines)

    let sleepiestGuard = guardSet.guards.sorted { $0.value.totalSleeps > $1.value.totalSleeps }.first!

    let sleepiestGuardId = sleepiestGuard.key
    let sleepiestMinute = sleepiestGuard.value.sleepiestMinute()

    return sleepiestGuardId * sleepiestMinute.minute
}

print(strategyOne(lines: testLines))

let url = Bundle.main.url(forResource: "day4.input", withExtension: "txt")!
let day4Input = try! String(contentsOf: url).components(separatedBy: "\n").sorted()
let day4Lines = day4Input.compactMap { Line(text: $0) }
print(strategyOne(lines: day4Lines))

func strategyTwo(lines: [Line]) -> Int {
    let guardSet = GuardSet(lines: lines)

    let guardSleepiestMinutes = guardSet.guards.mapValues { $0.sleepiestMinute() }
    let guardWithSleepiestMinute = guardSleepiestMinutes.sorted { $0.value.sleeps > $1.value.sleeps }.first!

    return guardWithSleepiestMinute.key * guardWithSleepiestMinute.value.minute
}

print(strategyTwo(lines: testLines))
print(strategyTwo(lines: day4Lines))

//: [Next](@next)

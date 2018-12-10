import Foundation


public struct Board {
    class Marble {
        var value: Int
        var next: Marble!
        var prev: Marble!

        init(value: Int) {
            self.value = value
            next = self
            prev = self
        }

        func insertAfter(marble: Marble) {
            self.next = marble.next
            marble.next.prev = self
            marble.next = self
            self.prev = marble
        }

        func remove() {
            prev.next = next
            next.prev = prev

            self.next = nil
            self.prev = nil
        }
    }

    var center: Marble

    public var nextMarbleNumber: Int

    init() {
        center = Marble(value: 0)
        nextMarbleNumber = 1
    }

    // places a marble, returning the resulting score
    public mutating func place() -> Int {
        if nextMarbleNumber % 23 == 0 {
            for _ in 0..<7 {
                center = center.prev
            }
            let newCenter = center.next!
            let score = nextMarbleNumber + center.value
            center.remove()
            center = newCenter
            nextMarbleNumber += 1
            return score
        } else {
            let newMarble = Marble(value: nextMarbleNumber)
            let oneRight = center.next!
            newMarble.insertAfter(marble: oneRight)
            center = newMarble
            nextMarbleNumber += 1
            return 0
        }
    }
}

public struct Game {
    var players: Int
    var lastMarble: Int
    var scores: [Int]
    var board: Board
    public init(players: Int, lastMarble: Int) {
        self.players = players
        self.lastMarble = lastMarble
        scores = [Int](repeating: 0, count: players)
        board = Board()
    }

    public mutating func winningPlayer() -> Int {
        while true {
            for i in 0..<scores.count {
                let thisScore = board.place()
                scores[i] += thisScore
                if board.nextMarbleNumber > lastMarble {
                    return scores.max() ?? -1
                }
            }
        }
    }
}


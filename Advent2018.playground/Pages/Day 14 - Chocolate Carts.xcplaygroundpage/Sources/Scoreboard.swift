import Foundation

public struct Scoreboard {
    var elf1index: Int = 0
    var elf2index: Int = 1
    var board = [3, 7]

    public init() {}

    public mutating func iterate() {
        let sum = board[elf1index] + board[elf2index]
        let first = sum / 10
        let second = sum % 10
        if first > 0 { board.append(first) }
        board.append(second)

        elf1index = (1 + elf1index + board[elf1index]) % board.count
        elf2index = (1 + elf2index + board[elf2index]) % board.count
    }

    public mutating func tenAfter(limit: Int) -> String {
        while board.count < limit + 10 {
            iterate()
        }

        let next10 = board[limit ..< (limit + 10)]
        return next10.map(String.init).joined()
    }
}

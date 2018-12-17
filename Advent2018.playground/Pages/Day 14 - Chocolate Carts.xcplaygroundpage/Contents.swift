//: [Previous](@previous)

import Foundation



var board = Scoreboard()
for _ in 0..<20 {
    board.iterate()
    print(board)
}

board.tenAfter(limit: 18)
print(board.tenAfter(limit: 409551))

//: [Next](@next)

//: [Previous](@previous)

import Foundation



var board = Scoreboard()
for _ in 0..<20 {
    board.iterate()
    print(board)
}

board.tenAfter(limit: 18)
print(board.tenAfter(limit: 409551))

print(board.recipesUntil(pattern: "51589"))
print(board.recipesUntil(pattern: "01245"))
print(board.recipesUntil(pattern: "92510"))
print(board.recipesUntil(pattern: "59414"))
print(board.recipesUntil(pattern: "409551"))


//: [Next](@next)

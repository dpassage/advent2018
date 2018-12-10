//: [Previous](@previous)

import Foundation

var testGame = Game(players: 9, lastMarble: 25)
print(testGame.winningPlayer())

func playGame(players: Int, lastMarble: Int) -> Int {
    var game = Game(players: players, lastMarble: lastMarble)
    return game.winningPlayer()
}

print(playGame(players: 10, lastMarble: 1618))

print(playGame(players: 465, lastMarble: 71498))
print(playGame(players: 465, lastMarble: 7149800))
//: [Next](@next)

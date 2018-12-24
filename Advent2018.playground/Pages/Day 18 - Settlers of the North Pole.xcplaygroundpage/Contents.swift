//: [Previous](@previous)

import Foundation
import AdventLib


let testInput = """
.#.#...|#.
.....#|##|
.|..|...#.
..|#.....#
#.#|||#|#|
...#.||...
.|....|...
||...#|.#|
|.||||..|.
...#.|..|.
"""

var testLandscape = Landscape(input: testInput)
print(testLandscape)

for _ in 0..<10 {
    testLandscape.generation()
    print(testLandscape)
}
print(testLandscape.score())

let url = Bundle.main.url(forResource: "day18.input", withExtension: "txt")!
let day18input = try! String(contentsOf: url)
var day18landscape = Landscape(input: day18input)

for i in 0..<1000 {
    day18landscape.generation()
    print(i, day18landscape.score())
}

/*
 971 189168
 972 189504 x
 973 192440 x
 974 193890 x
 975 192855 x
 976 192444 x
 977 188442
 978 185255 x
 979 184470 x
 980 181582 x
 981 180144 x
 982 178476 x
 983 179118 x
 984 180468 x
 985 185148 x
 986 179439 x
 987 182325 x
 988 186120 x
 989 189840 x
 990 191080 x
 991 192296 x
 992 192997 x
 993 189608 x
 994 188421
 995 185504 x
 996 184548 x
 997 184368 x
 998 186147 x
 999 189168
 */
let period = 999 - 971
let remaining = 1000000000 - 999
let factor = remaining / period
let last = 999 + (factor * period)
// 186147 too low
// 189504 too high
// 189168 just right!

//: [Next](@next)

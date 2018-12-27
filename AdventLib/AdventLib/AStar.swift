//
//  AStar.swift
//  AdventLib
//
//  Created by David Paschich on 12/27/18.
//  Copyright © 2018 David Paschich. All rights reserved.
//

import Foundation

public protocol AStar {
    associatedtype Node: Hashable

    func estimatedCost(from: Node, to: Node) -> Int

    func neighborsOf(_ node: Node) -> [(node: Node, distance: Int)]
}

extension AStar {
    func reconstructPath(cameFrom: [Node: Node], current: Node) -> [Node] {
        var current = current
        var path = [current]
        while let nextCurrent = cameFrom[current] {
            path.append(nextCurrent)
            current = nextCurrent
        }

        return path
    }

    public func aStar(from start: Node, to goal: Node) -> (path: [Node], cost: Int) {
        var closedSet: Set<Node> = []
        var cameFrom: [Node: Node] = [:]
        var gScore: [Node: Int] = [start: 0]

        var heap = Heap<(node: Node, fScore: Int)>(priorityFunction: { $0.fScore < $1.fScore })

        heap.enqueue((node: start, fScore: estimatedCost(from: start, to: goal)))

        while let current = heap.dequeue()?.node {
            if current == goal {
                let path = reconstructPath(cameFrom: cameFrom, current: current)
                let score = gScore[current, default: Int.max]
                return (path, score)
            }
            closedSet.insert(current)

            for (neighbor, distance) in neighborsOf(current) {
                if closedSet.contains(neighbor) { continue }
                let tentativeScore = gScore[current, default: Int.max] + distance
                if tentativeScore > gScore[neighbor, default: Int.max] {
                    continue
                }
                cameFrom[neighbor] = current
                gScore[neighbor] = tentativeScore
                heap.enqueue((node: neighbor, fScore: tentativeScore + estimatedCost(from: neighbor, to: goal)))
            }
        }
        return (path: [], cost: -1)
    }
}

//
//  Dijkstra.swift
//  AdventLib
//
//  Created by David Paschich on 12/27/18.
//  Copyright © 2018 David Paschich. All rights reserved.
//

import Foundation

public protocol Dijkstra {
    associatedtype Node: Hashable

    func neighborsOf(_ node: Node) -> [(node: Node, distance: Int)]
}

extension Dijkstra {

    // computes distances from the source node to every reachable node
    // in the graph
    public func distances(from source: Node) -> [Node: Int] {
        // dist[source] ← 0                           // Initialization
        var dist: [Node: Int] = [source: 0]
        var visited: Set<Node> = []
        var heap = HashedHeap<Node>(sort: { dist[$0] ?? Int.max < dist[$1] ?? Int.max})
        heap.insert(source)
        
        while let current = heap.remove() {
            for (neighbor, distance) in neighborsOf(current) {
                if visited.contains(neighbor) { continue }
                let newDist = dist[current, default: Int.max] + distance
                let oldDist = dist[neighbor, default: Int.max]
                if newDist < oldDist {
                    dist[neighbor] = newDist
                    if let neighborIndex = heap.index(of: neighbor) {
                        heap.replace(neighbor, at: neighborIndex)
                    } else {
                        heap.insert(neighbor)
                    }
                }
            }
            visited.insert(current)
        }

        return dist
    }
}

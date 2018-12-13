//
//  TwoWayArray.swift
//  AdventLib
//
//  Created by David Paschich on 12/12/18.
//  Copyright © 2018 David Paschich. All rights reserved.
//

import Foundation


// An array which can grow in either direction
public struct TwoWayArray<Element> {
    private var storage: [Element]
    private var firstIndex: Int

    public init(repeating: Element, count: Int, firstIndex: Int = 0) {
        storage = [Element](repeating: repeating, count: count)
        self.firstIndex = firstIndex
    }
}

extension TwoWayArray: Sequence {
    public func makeIterator() -> TwoWayArray<Element>.Iterator {
        return Iterator(array: storage, index: 0)
    }

    public struct Iterator: IteratorProtocol {
        let array: [Element]
        var index: Int

        mutating public func next() -> Element? {
            if index < array.count {
                let result = array[index]
                index += 1
                return result
            } else {
                return nil
            }
        }
    }
}

extension TwoWayArray: MutableCollection {
    private func normalize(index: Int) -> Int {
        return index - firstIndex
    }

    public subscript(position: Int) -> Element {
        get {
            return storage[normalize(index: position)]
        }
        set {
            storage[normalize(index: position)] = newValue
        }
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }

    public var startIndex: Int {
        return firstIndex
    }

    public var endIndex: Int {
        return firstIndex + storage.count
    }

    public typealias Index = Int
}

extension TwoWayArray: BidirectionalCollection {
    public func index(before i: Int) -> Int {
        return i - 1
    }
}

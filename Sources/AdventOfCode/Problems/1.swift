import Foundation

struct Day1: Day {
    let dayNumber = 1

    struct P: Parser {
        func parse(_ input: [String]) throws -> [Int] {
            input.compactMap(Int.init)
        }
    }

    struct S1: Solver {
        func solve(with input: [Int]) async throws -> Int {
            input
                .slidingWindow(size: 2)
                .filter { $0[0] < $0[1] }
                .count
        }
    }

    struct S2: Solver {
        func solve(with input: [Int]) async throws -> Int {
            input
                .slidingWindow(size: 3)
                .map { $0.reduce(0, +) }
                .slidingWindow(size: 2)
                .filter { $0[0] < $0[1] }
                .count
        }
    }
}

struct SlidingWindow<C>: Sequence, IteratorProtocol where C: Collection {
    private let collection: C
    private let windowSize: Int
    private var index: C.Index

    init(_ collection: C, windowSize: Int) {
        self.collection = collection
        self.windowSize = windowSize
        self.index = collection.startIndex
    }

    func makeIterator() -> some IteratorProtocol {
        self
    }

    mutating func next() -> [C.Element]? {
        guard collection.index(index, offsetBy: windowSize) <= collection.endIndex else {
            return nil
        }
        defer {
            index = collection.index(after: index)
        }
        return Array(collection[index..<collection.index(index, offsetBy: windowSize)])
    }
}

extension Collection {
    func slidingWindow(size windowSize: Int) -> SlidingWindow<Self> {
        .init(self, windowSize: windowSize)
    }
}

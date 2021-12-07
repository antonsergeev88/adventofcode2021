import Foundation

struct Day1: Problem {
    func input(from stream: InputStream) throws -> [Int] {
        var data = Data()
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1024)
        while stream.hasBytesAvailable {
            let count = stream.read(buffer, maxLength: 1024)
            data.append(buffer, count: count)
        }
        guard let text = String(data: data, encoding: .utf8) else {
            throw ProblemError.badInput
        }
        return text.split(separator: "\n").map(String.init).compactMap(Int.init)
    }

    func process(_ input: [Int]) async throws -> (first: Int, second: Int) {
        let first = input
            .slidingWindow(size: 2)
            .reduce(0) { partialResult, pair in
                pair[0] < pair[1] ? partialResult + 1 : partialResult
            }

        let second = input
            .slidingWindow(size: 3)
            .map {
                $0.reduce(0, +)
            }
            .slidingWindow(size: 2)
            .reduce(0) { partialResult, pair in
                pair[0] < pair[1] ? partialResult + 1 : partialResult
            }

        return (first: first, second: second)
    }

    func text(from output: (first: Int, second: Int)) -> String {
        String(describing: output)
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

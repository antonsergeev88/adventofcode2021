import Foundation

struct Day7: Problem {
    func input(from stream: InputStream) throws -> [Int] {
        var data = Data()
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1024)
        defer {
            buffer.deallocate()
        }
        while stream.hasBytesAvailable {
            let count = stream.read(buffer, maxLength: 1024)
            data.append(buffer, count: count)
        }
        guard let text = String(data: data, encoding: .utf8) else {
            throw ProblemError.badInput
        }
        return text.split(separator: "\n").first!.split(separator: ",").map(String.init).compactMap(Int.init)
    }

    func process(_ input: [Int]) async throws -> (first: Int, second: Int) {
//        let input = [16,1,2,0,4,2,7,1,2,14]

        let sorted = input.sorted()
        let median = sorted[input.count / 2]
        let first = input.reduce(0) { partialResult, element in
            partialResult + abs(element - median)
        }

        let min = sorted.first!
        let max = sorted.last!

        let secondMed = findMin(min: min, max: max, input: sorted)
        let second = input.reduce(0) { partialResult, element in
            let diff = abs(secondMed - element)
            return partialResult + (1 + diff) * diff / 2
        }

        return (first, second)
    }

    func text(from output: (first: Int, second: Int)) -> String {
        String(describing: output)
    }
}

private func findMin(min: Int, max: Int, input: [Int]) -> Int {
    if min == max {
        return min
    }
    if max - min == 1 {
        let weightMin = input.reduce(0) { partialResult, element in
            let diff = abs(min - element)
            return partialResult + (1 + diff) * diff / 2
        }
        let weightMax = input.reduce(0) { partialResult, element in
            let diff = abs(max - element)
            return partialResult + (1 + diff) * diff / 2
        }
        return weightMin < weightMax ? min : max
    }
    if max - min == 2 {
        let weightMin = input.reduce(0) { partialResult, element in
            let diff = abs(min - element)
            return partialResult + (1 + diff) * diff / 2
        }
        let weightMid = input.reduce(0) { partialResult, element in
            let diff = abs(min + 1 - element)
            return partialResult + (1 + diff) * diff / 2
        }
        let weightMax = input.reduce(0) { partialResult, element in
            let diff = abs(max - element)
            return partialResult + (1 + diff) * diff / 2
        }
        return [(weightMin, min), (weightMid, min + 1), (weightMax, max)].sorted(by: { $0.0 < $1.0 }).first!.1
    }
    let left = min + (max - min) / 3
    let right = max - (max - min) / 3
    let leftWeight = input.reduce(0) { partialResult, element in
        let diff = abs(left - element)
        return partialResult + (1 + diff) * diff / 2
    }
    let rightWeight = input.reduce(0) { partialResult, element in
        let diff = abs(right - element)
        return partialResult + (1 + diff) * diff / 2
    }
    if leftWeight > rightWeight {
        return findMin(min: left, max: max, input: input)
    } else {
        return findMin(min: min, max: right, input: input)
    }
}

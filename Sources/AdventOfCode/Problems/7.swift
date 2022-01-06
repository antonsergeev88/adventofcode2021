import Foundation

struct Day7: Day {
    let dayNumber = 7

    struct P: Parser {
        func parse(_ input: [String]) throws -> [Int] {
            input.first!.split(separator: ",").map(String.init).compactMap(Int.init)
        }
    }

    struct S1: Solver {
        func solve(with input: [Int]) async throws -> Int {
            let sorted = input.sorted()
            let median = sorted[input.count / 2]
            return input.reduce(0) { partialResult, element in
                partialResult + abs(element - median)
            }
        }
    }

    struct S2: Solver {
        func solve(with input: [Int]) async throws -> Int {
            let sorted = input.sorted()

            let min = sorted.first!
            let max = sorted.last!

            let secondMed = findMin(min: min, max: max, input: sorted)
            return input.reduce(0) { partialResult, element in
                let diff = abs(secondMed - element)
                return partialResult + (1 + diff) * diff / 2
            }
        }
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

import Foundation

struct Day6: Day {
    let dayNumber = 6

    struct P: Parser {
        func parse(_ input: [String]) throws -> [Int] {
            input.first!.split(separator: ",").map(String.init).compactMap(Int.init)
        }
    }

    struct S1: Solver {
        func solve(with input: [Int]) async throws -> Int {
            var counts = [Int](repeating: 0, count: 9)
            for i in input {
                counts[i] += 1
            }
            for _ in 0..<80 {
                var newCounts = counts
                for i in 1..<counts.count {
                    newCounts[i-1] = counts[i]
                }
                let new = counts[0]
                newCounts[6] += new
                newCounts[8] = new
                counts = newCounts
            }
            return counts.reduce(0, +)
        }
    }

    struct S2: Solver {
        func solve(with input: [Int]) async throws -> Int {
            var counts = [Int](repeating: 0, count: 9)
            for i in input {
                counts[i] += 1
            }
            for _ in 0..<256 {
                var newCounts = counts
                for i in 1..<counts.count {
                    newCounts[i-1] = counts[i]
                }
                let new = counts[0]
                newCounts[6] += new
                newCounts[8] = new
                counts = newCounts
            }
            return counts.reduce(0, +)
        }
    }
}

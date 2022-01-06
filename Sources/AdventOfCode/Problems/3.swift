import Foundation

struct Day3: Day {
    let dayNumber = 3

    struct P: Parser {
        func parse(_ input: [String]) throws -> [String] {
            input
        }
    }

    struct S1: Solver {
        func solve(with input: [String]) async throws -> UInt {
            let numbers: [UInt] = input.map {
                $0.reduce(0) { partialResult, char in
                    partialResult << 1 + (char == "1" ? 1 : 0)
                }
            }
            let gammaRate = numbers.mostCommonBits(length: 12)
            let epsilonRate = numbers.leastCommonBits(length: 12)
            return gammaRate * epsilonRate
        }
    }

    struct S2: Solver {
        func solve(with input: [String]) async throws -> UInt {
            let numbers: [UInt] = input.map {
                $0.reduce(0) { partialResult, char in
                    partialResult << 1 + (char == "1" ? 1 : 0)
                }
            }

            var oxygens = numbers
            for digit in (0..<12).reversed() {
                guard oxygens.count > 1 else {
                    break
                }
                let mostCommonDigits = oxygens.mostCommonBits(length: digit + 1)
                let pattern = mostCommonDigits & (1 << digit)
                oxygens = oxygens.filter { num in
                    num & (1 << digit) == pattern
                }
            }

            var co2s = numbers
            for digit in (0..<12).reversed() {
                guard co2s.count > 1 else {
                    break
                }
                let leastCommonDigits = co2s.leastCommonBits(length: digit + 1)
                let pattern = leastCommonDigits & (1 << digit)
                co2s = co2s.filter { num in
                    num & (1 << digit) == pattern
                }
            }

            return oxygens.first! * co2s.first!
        }
    }
}

extension Array where Element == UInt {
    func mostCommonBits(length: Int) -> UInt {
        var digitsCount = [Int](repeating: 0, count: length)
        forEach { number in
            for digit in 0..<length {
                if number & 1<<digit == 0 {
                    digitsCount[digit] -= 1
                } else {
                    digitsCount[digit] += 1
                }
            }
        }
        return digitsCount.reversed().reduce(0) { partialResult, num in
            partialResult << 1 + (num >= 0 ? 1 : 0)
        }
    }

    func leastCommonBits(length: Int) -> UInt {
        var digitsCount = [Int](repeating: 0, count: length)
        forEach { number in
            for digit in 0..<length {
                if number & 1<<digit == 0 {
                    digitsCount[digit] -= 1
                } else {
                    digitsCount[digit] += 1
                }
            }
        }
        return digitsCount.reversed().reduce(0) { partialResult, num in
            partialResult << 1 + (num < 0 ? 1 : 0)
        }
    }
}

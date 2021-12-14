import Foundation

struct Day8: Problem {
    func input(from stream: InputStream) throws -> [(digits: [String], code: [String])] {
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
        return text.split(separator: "\n").map(String.init).compactMap { input in
            let split = input.split(separator: "|")
            guard split.count == 2 else {
                return nil
            }
            return (
                split[0].split(separator: " ").map(String.init),
                split[1].split(separator: " ").map(String.init)
            )
        }
    }

    func process(_ input: [(digits: [String], code: [String])]) async throws -> (first: Int, second: Int) {
        let first = input.map(\.code).reduce(0) { partialResult, code in
            partialResult + code.filter { digit in
                switch digit.count {
                case 2...4, 7:
                    return true
                default:
                    return false
                }
            }.count
        }

        let second: Int = {
            var result = 0
            for line in input {
                let digits = line.digits.map(Set.init)

                let cf = digits.first(where: { $0.count == 2 })! // 1
                let bcdf = digits.first(where: { $0.count == 4 })! // 4
                let acf = digits.first(where: { $0.count == 3 })! // 7
                let abcdefg = digits.first(where: { $0.count == 7 })! // 8

                let cde = digits.filter({ $0.count == 6 }).reduce(into: Set<Character>()) { partialResult, digit in
                    partialResult.formUnion(abcdefg.subtracting(digit))
                }

                let acdeg = digits.filter({ $0.count == 5 }).first(where: { $0.subtracting(cde).count == 2 })! // 2
                let acdfg = digits.filter({ $0.count == 5 }).first(where: { $0.subtracting(cde).count == 3 })! // 3
                let abdfg = digits.filter({ $0.count == 5 }).first(where: { $0.subtracting(cde).count == 4 })! // 5

                let abcdfg = cf.union(abdfg) // 9

                let d = abdfg.intersection(cde)

                let abcefg = digits.filter({ $0.count == 6 }).filter({ $0 != abcdfg }).first(where: { $0.intersection(d).count == 0 })! // 0
                let abdefg = digits.filter({ $0.count == 6 }).filter({ $0 != abcdfg }).first(where: { $0.intersection(d).count == 1 })! // 6

                let ABC: [Set<Character>: Int] = [
                    abcefg: 0,
                    cf: 1,
                    acdeg: 2,
                    acdfg: 3,
                    bcdf: 4,
                    abdfg: 5,
                    abdefg: 6,
                    acf: 7,
                    abcdefg: 8,
                    abcdfg: 9,
                ]
                let num = line.code.map(Set.init).reduce(0) { partialResult, code in
                    partialResult * 10 + ABC[code]!
                }
                result += num
            }
            return result
        }()

        return (first, second)
    }

    func text(from output: (first: Int, second: Int)) -> String {
        String(describing: output)
    }
}

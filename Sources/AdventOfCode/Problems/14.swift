import Foundation

struct Day14: Problem {
    func input(from stream: InputStream) throws -> (sequence: String, dict: [String: Character]) {
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
        let sequence = text.split(separator: "\n").map(String.init).first!
        let dict = text.split(separator: "\n").map(String.init).reduce(into: [String: Character]()) { partialResult, line in
            let array = line.split(separator: " ").map(String.init)
            guard array.count == 3, array[1] == "->" else {
                return
            }
            partialResult[array[0]] = array[2].first!
        }

        return (sequence, dict)
    }

    func process(_ input: (sequence: String, dict: [String: Character])) async throws -> (first: Int, second: Int) {
        let first: Int = {
            var result = input.sequence
            for _ in 0..<10 {
                result = result.step(with: input.dict)
            }
            let count = result.reduce(into: [Character: Int]()) { partialResult, char in
                partialResult[char] = partialResult[char] != nil ? partialResult[char]! + 1 : 1
            }
            let firstCount = count
                .map { $0.value }
                .sorted()
            return firstCount.last! - firstCount.first!
        }()
        let second: Int = {
            var extraSymbols = input.sequence.dropFirst().dropLast().reduce(into: [Character: Int]()) { partialResult, char in
                partialResult[char] = partialResult[char] != nil ? partialResult[char]! + 1 : 1
            }
            var pairs = zip(input.sequence.dropLast(), input.sequence.dropFirst()).reduce(into: [String: Int]()) { partialResult, pair in
                let string = "\(pair.0)\(pair.1)"
                partialResult[string] = partialResult[string] != nil ? partialResult[string]! + 1 : 1
            }
            for _ in 0..<40 {
                for (pair, count) in pairs {
                    if let middleChar = input.dict[pair] {
                        extraSymbols[middleChar] = extraSymbols[middleChar] != nil ? extraSymbols[middleChar]! + count : count
                        pairs[pair] = pairs[pair]! - count
                        let leftPair = "\(pair.first!)\(middleChar)"
                        let rightPair = "\(middleChar)\(pair.last!)"
                        pairs[leftPair] = pairs[leftPair] != nil ? pairs[leftPair]! + count : count
                        pairs[rightPair] = pairs[rightPair] != nil ? pairs[rightPair]! + count : count
                    }
                }
            }
            var allSymbols = pairs.reduce(into: [Character: Int]()) { partialResult, pair in
                let first = pair.key.first!
                let second = pair.key.last!
                partialResult[first] = partialResult[first] != nil ? partialResult[first]! + pair.value : pair.value
                partialResult[second] = partialResult[second] != nil ? partialResult[second]! + pair.value : pair.value
            }

            extraSymbols.forEach { (key: Character, value: Int) in
                allSymbols[key]! -= value
            }
            let sorted = allSymbols.map { $0.value }.sorted()

            return sorted.last! - sorted.first!
        }()
        return (first, second)
    }

    func text(from output: (first: Int, second: Int)) -> String {
        String(describing: output)
    }
}

private extension String {
    func step(with dict: [String: Character]) -> String {
        var result = ""
        zip(dropLast(), dropFirst()).forEach { lhs, rhs in
            result.append(lhs)
            let pair = String([lhs, rhs])
            if let char = dict[pair] {
                result.append(char)
            }
        }
        result.append(last!)
        return result
    }
}

import Foundation

struct Day6: Problem {
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
        let first: Int = {
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
        }()

        let second: Int = {
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
        }()

        return (first, second)
    }

    func text(from output: (first: Int, second: Int)) -> String {
        String(describing: output)
    }
}



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

    func process(_ input: [Int]) async throws -> Int {
        zip(input.dropLast(1), input.dropFirst(1)).reduce(0) { partialResult, pair in
            pair.0 < pair.1 ? partialResult + 1 : partialResult
        }
    }

    func text(from output: Int) -> String {
        String(describing: output)
    }
}

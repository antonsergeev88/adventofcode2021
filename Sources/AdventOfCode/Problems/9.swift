import Foundation

extension Day9 {
    struct Map {
        private let values: [[Int]]

        init(values: [[Int]]) {
            self.values = values
        }

        var size: (x: Int, y: Int) {
            (values.first!.count, values.count)
        }

        subscript(_ x: Int, _ y: Int) -> Int {
            guard (0..<size.x).contains(x), (0..<size.y).contains(y) else {
                return 9
            }
            return values[y][x]
        }

        func isLowest(_ x: Int, _ y: Int) -> Bool {
            if x - 1 >= 0, self[x, y] > self[x - 1, y] {
                return false
            }
            if y - 1 >= 0, self[x, y] > self[x, y - 1] {
                return false
            }
            if x + 1 < size.x, self[x, y] > self[x + 1, y] {
                return false
            }
            if y + 1 < size.y, self[x, y] > self[x, y + 1] {
                return false
            }
            return true
        }

        static func with(strings: [String]) -> Self {
            .init(values: strings.map { line in
                line.map { char in
                    Int(String(char))!
                }
            })
        }
    }
}

struct Day9: Problem {
    func input(from stream: InputStream) throws -> Map {
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
        return .with(strings: text.split(separator: "\n").map(String.init))
    }

    func process(_ input: Map) async throws -> (first: Int, second: Int) {
        let input = Map.with(strings: [
            "2199943210",
            "3987894921",
            "9856789892",
            "8767896789",
            "9899965678",
        ])
        let first: Int = {
            var risk = 0
            for x in 0..<input.size.x {
                for y in 0..<input.size.y {
                    if input.isLowest(x, y) {
                        risk += input[x, y] + 1
                    }
                }
            }
            return risk
        }()
        return (first, 0)
    }

    func text(from output: (first: Int, second: Int)) -> String {
        String(describing: output)
    }
}

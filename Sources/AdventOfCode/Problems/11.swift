import Foundation

extension Day11 {
    struct Map {
        var values: [[Int]]

        subscript(_ x: Int, y: Int) -> Int {
            get {
                guard (0..<values[0].count).contains(x), (0..<values.count).contains(y) else {
                    return 9
                }
                return values[y][x]
            }
            set {
                guard (0..<values[0].count).contains(x), (0..<values.count).contains(y) else {
                    return
                }
                values[y][x] = newValue
            }
        }

        mutating func step() {
            values = values.map {
                $0.map {
                    $0 + 1
                }
            }
            while wantsToFlash {
                flash()
            }
        }

        var wantsToFlash: Bool {
            for x in 0..<(values[0].count) {
                for y in 0..<(values.count) {
                    guard self[x, y] <= 9 else {
                        return true
                    }
                }
            }
            return false
        }

        mutating func flash() {
            for x in 0..<values[0].count {
                for y in 0..<values.count {
                    if self[x, y] > 9 {
                        for n in (x-1)...(x+1) {
                            for m in (y-1)...(y+1) {
                                if self[n, m] != 0 {
                                    self[n, m] += 1
                                }
                            }
                        }
                        self[x, y] = 0
                    }
                }
            }
        }

        var zeros: Int {
            values.flatMap { $0 }.reduce(0) { $0 + ($1 == 0 ? 1 : 0) }
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

struct Day11: Problem {
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
        let first: Int = {
            var flashCount = 0
            var map = input
            for _ in 1...100 {
                map.step()
                flashCount += map.zeros
            }
            return flashCount
        }()
        let second: Int = {
            var step = 0
            var map = input
            while map.zeros != map.values.count * map.values[0].count {
                step += 1
                map.step()
            }
            return step
        }()
        return (first, second)
    }

    func text(from output: (first: Int, second: Int)) -> String {
        String(describing: output)
    }
}

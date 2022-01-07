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

struct Day11: Day {
    let dayNumber = 11

    struct P: Parser {
        func parse(_ input: [String]) throws -> Day11.Map {
            .with(strings: input)
        }
    }

    struct S1: Solver {
        func solve(with input: Day11.Map) async throws -> Int {
            var flashCount = 0
            var map = input
            for _ in 1...100 {
                map.step()
                flashCount += map.zeros
            }
            return flashCount
        }
    }

    struct S2: Solver {
        func solve(with input: Day11.Map) async throws -> Int {
            var step = 0
            var map = input
            while map.zeros != map.values.count * map.values[0].count {
                step += 1
                map.step()
            }
            return step
        }
    }
}

import Foundation

struct Boundary {
    enum Kind {
        case round
        case squared
        case figured
        case angled
    }
    enum Side {
        case opening
        case closing
    }

    init?(char: Character) {
        switch char {
        case "(":
            kind = .round
            side = .opening
        case ")":
            kind = .round
            side = .closing
        case "[":
            kind = .squared
            side = .opening
        case "]":
            kind = .squared
            side = .closing
        case "{":
            kind = .figured
            side = .opening
        case "}":
            kind = .figured
            side = .closing
        case "<":
            kind = .angled
            side = .opening
        case ">":
            kind = .angled
            side = .closing
        default:
            return nil
        }
    }

    static func from(line: String) -> [Boundary] {
        line.compactMap(Boundary.init(char:))
    }

    let kind: Kind
    let side: Side
}

struct Day10: Day {
    let dayNumber = 10

    struct P: Parser {
        func parse(_ input: [String]) throws -> [[Boundary]] {
            input.map(Boundary.from(line:))
        }
    }

    struct S1: Solver {
        func solve(with input: [[Boundary]]) async throws -> Int {
            var score = 0
            lines: for line in input {
                var stack: [Boundary] = []
                for boundary in line {
                    if case .opening = boundary.side {
                        stack.append(boundary)
                    } else {
                        let last = stack.popLast()!
                        guard last.kind == boundary.kind else {
                            switch boundary.kind {
                            case .round:
                                score += 3
                            case .squared:
                                score += 57
                            case .figured:
                                score += 1197
                            case .angled:
                                score += 25137
                            }
                            continue lines
                        }
                    }
                }
            }
            return score
        }
    }

    struct S2: Solver {
        func solve(with input: [[Boundary]]) async throws -> Int {
            var scores: [Int] = []
            lines: for line in input {
                var stack: [Boundary] = []
                for boundary in line {
                    if case .opening = boundary.side {
                        stack.append(boundary)
                    } else {
                        let last = stack.popLast()!
                        guard last.kind == boundary.kind else {
                            continue lines
                        }
                    }
                }
                let score = stack.reversed().reduce(0) { partialResult, boundary in
                    let score: Int = {
                        switch boundary.kind {
                        case .round: return 1
                        case .squared: return 2
                        case .figured: return 3
                        case .angled: return 4
                        }
                    }()
                    return partialResult * 5 + score
                }
                scores.append(score)
            }
            return scores.sorted()[scores.count / 2]
        }
    }
}

import Foundation

struct Command {
    enum Kind {
        case forward
        case down
        case up
    }

    let kind: Kind
    let value: Int
}

extension Command.Kind {
    init?(inputLine: String) {
        switch inputLine {
        case "forward": self = .forward
        case "down": self = .down
        case "up": self = .up
        default: return nil
        }
    }
}

extension Command {
    init?(inputLine: String) {
        let array = inputLine.split(separator: " ").map(String.init)
        guard
            array.count == 2,
            let kind = Command.Kind(inputLine: array[0]),
            let value = Int(array[1])
        else {
            return nil
        }
        self.kind = kind
        self.value = value
    }
}

struct Day2: Day {
    let dayNumber = 2

    struct P: Parser {
        func parse(_ input: [String]) throws -> [Command] {
            input.compactMap(Command.init(inputLine:))
        }
    }

    struct S1: Solver {
        func solve(with input: [Command]) async throws -> Int {
            var vertical = 0
            var horizontal = 0
            input.forEach { command in
                switch command.kind {
                case .forward: horizontal += command.value
                case .down: vertical += command.value
                case .up: vertical -= command.value
                }
            }
            return vertical * horizontal
        }
    }

    struct S2: Solver {
        func solve(with input: [Command]) async throws -> Int {
            var vertical = 0
            var horizontal = 0
            var aim = 0
            input.forEach { command in
                switch command.kind {
                case .forward:
                    horizontal += command.value
                    vertical += aim * command.value
                case .down: aim += command.value
                case .up: aim -= command.value
                }
            }
            return vertical * horizontal
        }
    }
}

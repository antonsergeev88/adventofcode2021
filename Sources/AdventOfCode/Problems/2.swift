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

struct Day2: Problem {
    func input(from stream: InputStream) throws -> [Command] {
        var data = Data()
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1024)
        while stream.hasBytesAvailable {
            let count = stream.read(buffer, maxLength: 1024)
            data.append(buffer, count: count)
        }
        guard let text = String(data: data, encoding: .utf8) else {
            throw ProblemError.badInput
        }
        return text.split(separator: "\n").map(String.init).compactMap(Command.init(inputLine:))
    }

    func process(_ input: [Command]) async throws -> Int {
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

    func text(from output: Int) -> String {
        String(describing: output)
    }
}

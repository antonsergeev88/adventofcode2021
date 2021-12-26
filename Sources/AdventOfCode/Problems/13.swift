import Foundation

extension Day13 {
    struct Point {
        let x: Int
        let y: Int
    }
    enum Fold {
        case x(Int)
        case y(Int)
    }
    struct Input {
        var points: [Point]
        let folds: [Fold]
    }
}

struct Day13: Problem {
    func input(from stream: InputStream) throws -> Input {
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
        let points = text.split(separator: "\n").map(String.init).compactMap { line -> Point? in
            let components = line.split(separator: ",").map(String.init).compactMap(Int.init)
            guard components.count == 2 else {
                return nil
            }
            return .init(x: components[0], y: components[1])
        }
        let folds = text.split(separator: "\n").map(String.init).compactMap { line -> Fold? in
            let components = line
                .replacingOccurrences(of: "fold along ", with: "")
                .split(separator: "=")
                .map(String.init)
            guard components.count == 2, components[0] == "x" || components[0] == "y", let coord = Int(components[1]) else {
                return nil
            }
            if components[0] == "x" {
                return .x(coord)
            } else {
                return .y(coord)
            }
        }
        return .init(points: points, folds: folds)
    }

    func process(_ input: Input) async throws -> (first: Int, second: Int) {
        (0, 0)
    }

    func text(from output: (first: Int, second: Int)) -> String {
        String(describing: output)
    }
}

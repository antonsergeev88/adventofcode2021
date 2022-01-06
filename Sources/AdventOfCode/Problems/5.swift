import Foundation

extension Day5 {
    struct Point: Hashable {
        let x: Int
        let y: Int

        static func with(input: String) -> Point {
            let coordinates = input.split(separator: ",").map(String.init).compactMap(Int.init)
            return .init(x: coordinates[0], y: coordinates[1])
        }
    }

    struct Line {
        let left: Point
        let right: Point

        static func with(input: String) -> Line {
            let points = input.split(separator: " ").map(String.init).filter({ $0 != "->" }).map(Point.with(input:))
            return .init(left: points[0], right: points[1])
        }
    }

    struct DiagonalLine: Sequence, IteratorProtocol {
        let start: Point
        let end: Point
        let diff: Point?
        private var order = 0
        init(_ line: Line) {
            self.start = line.left
            self.end = line.right
            let diffX = line.right.x - line.left.x
            let diffY = line.right.y - line.left.y
            if abs(diffX) == abs(diffY), abs(diffX) > 0 {
                self.diff = .init(x: diffX > 0 ? 1 : -1, y: diffY > 0 ? 1 : -1)
            } else {
                self.diff = nil
            }
        }
        func makeIterator() -> Day5.DiagonalLine {
            self
        }
        mutating func next() -> Point? {
            guard let diff = diff else {
                return nil
            }
            defer {
                self.order += 1
            }
            if diff.x > 0 {
                if start.x + diff.x * order <= end.x {
                    return .init(x: start.x + diff.x * order, y: start.y + diff.y * order)
                } else {
                    return nil
                }
            } else {
                if start.x + diff.x * order >= end.x {
                    return .init(x: start.x + diff.x * order, y: start.y + diff.y * order)
                } else {
                    return nil
                }
            }
        }
    }

    struct FlatLine: Sequence, IteratorProtocol {
        let start: Point
        let end: Point
        private var order = 0
        init(_ line: Line) {
            if line.left.x == line.right.x {
                start = line.left.y <= line.right.y ? line.left : line.right
                end = line.left.y <= line.right.y ? line.right : line.left
            } else if line.left.y == line.right.y {
                start = line.left.x <= line.right.x ? line.left : line.right
                end = line.left.x <= line.right.x ? line.right : line.left
            } else {
                start = line.left
                end = line.right
            }
        }
        func makeIterator() -> Day5.FlatLine {
            self
        }
        mutating func next() -> Point? {
            defer { order += 1 }
            if start.x == end.x, start.y + order <= end.y {
                return .init(x: start.x, y: start.y + order)
            } else if start.y == end.y, start.x + order <= end.x {
                return .init(x: start.x + order, y: start.y)
            } else {
                return nil
            }
        }
    }
}

struct Day5: Day {
    let dayNumber = 5

    struct P: Parser {
        func parse(_ input: [String]) throws -> [Day5.Line] {
            input.map(Line.with(input:))
        }
    }

    struct S1: Solver {
        func solve(with input: [Day5.Line]) async throws -> Int {
            var map: [Point: Int] = [:]
            for line in input {
                for point in FlatLine(line) {
                    map[point] = map[point] == nil ? 1 : map[point]! + 1
                }
            }
            let overlaps = map.filter { $0.value > 1 }
            return overlaps.count
        }
    }

    struct S2: Solver {
        func solve(with input: [Day5.Line]) async throws -> Int {
            var map: [Point: Int] = [:]
            for line in input {
                for point in FlatLine(line) {
                    map[point] = map[point] == nil ? 1 : map[point]! + 1
                }
            }
            for line in input {
                for point in DiagonalLine(line) {
                    map[point] = map[point] == nil ? 1 : map[point]! + 1
                }
            }
            let allOverlaps = map.filter { $0.value > 1 }
            return allOverlaps.count
        }
    }
}

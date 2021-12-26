import Foundation

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
            return .init(components[0], components[1])
        }
        let map = MapWithSet(points)
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
        return .init(map: map, folds: folds)
    }

    func process(_ input: Input) async throws -> (first: Int, second: String) {
        let folded = input.map.folded(by: input.folds.first!)
        var first = 0
        for x in 0..<folded.size.x {
            for y in 0..<folded.size.y {
                first += folded[.init(x, y)] ? 1 : 0
            }
        }
        let secondMap = input.folds.reduce(input.map) { partialResult, fold in
            partialResult.folded(by: fold)
        }
        var second = ""
        for y in 0..<secondMap.size.y {
            for x in 0..<secondMap.size.x {
                second.append(secondMap[.init(x, y)] ? "*" : " ")
            }
            second.append("\n")
        }
        return (first, second)
    }

    func text(from output: (first: Int, second: String)) -> String {
        "(first: \(output.first), second:\n\(output.second))"
    }
}

enum Fold {
    case x(Int)
    case y(Int)
    var coordinate: Int {
        switch self {
        case .x(let coordinate): return coordinate
        case .y(let coordinate): return coordinate
        }
    }
}
struct Input {
    let map: Map
    let folds: [Fold]
}

struct Point: Hashable {
    let x: Int
    let y: Int
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

struct Size {
    let x: Int
    let y: Int
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

struct Rect {
    let origin: Point
    let size: Size
}

protocol Map {
    subscript(_ point: Point) -> Bool { get }
    var size: Size { get }
}

struct MapWithSet: Map {
    private let points: Set<Point>
    let size: Size
    init<S>(_ points: S) where S: Sequence, S.Element == Point {
        var x = 0
        var y = 0
        self.points = points.reduce(into: Set<Point>()) {
            $0.insert($1)
            if $1.x > x {
                x = $1.x
            }
            if $1.y > y {
                y = $1.y
            }
        }
        self.size = Size(x + 1, y + 1)
    }
    subscript(_ point: Point) -> Bool {
        points.contains(point)
    }
}

struct ClippedMap: Map {
    private let map: Map
    private let rect: Rect
    init(map: Map, rect: Rect) {
        self.map = map
        self.rect = rect
    }
    var size: Size {
        rect.size
    }
    subscript(_ point: Point) -> Bool {
        map[.init(point.x + rect.origin.x, point.y + rect.origin.y)]
    }
}

extension Map {
    func clipped(_ rect: Rect) -> Map {
        ClippedMap(map: self, rect: rect)
    }
    func clippedLeft(_ x: Int) -> Map {
        clipped(.init(origin: .init(0, 0), size: .init(x, size.y)))
    }
    func clippedRight(_ x: Int) -> Map {
        clipped(.init(origin: .init(x + 1, 0), size: .init(size.x - x - 1, size.y)))
    }
    func clippedTop(_ y: Int) -> Map {
        clipped(.init(origin: .init(0, 0), size: .init(size.x, y)))
    }
    func clippedBottom(_ y: Int) -> Map {
        clipped(.init(origin: .init(0, y + 1), size: .init(size.x, size.y - y - 1)))
    }
}

struct FlippedMap: Map {
    enum Side {
        case vertical
        case horizontal
    }
    private let map: Map
    private let side: Side
    init(map: Map, by side: Side) {
        self.map = map
        self.side = side
    }
    var size: Size {
        map.size
    }
    subscript(_ point: Point) -> Bool {
        let flippedPoint: Point = {
            switch side {
            case .vertical:
                return .init(size.x - 1 - point.x, point.y)
            case .horizontal:
                return .init(point.x, size.y - 1 - point.y)
            }
        }()
        return map[flippedPoint]
    }
}

extension Map {
    func flippedHorizontally() -> Map {
        FlippedMap(map: self, by: .horizontal)
    }
    func flippedVertically() -> Map {
        FlippedMap(map: self, by: .vertical)
    }
}

struct StackedMap: Map {
    private let map1: Map
    private let map2: Map
    init(map1: Map, map2: Map) {
        self.map1 = map1
        self.map2 = map2
    }
    var size: Size {
        let maxX = max(map1.size.x, map2.size.x)
        let maxY = max(map1.size.y, map2.size.y)
        return .init(maxX, maxY)
    }
    subscript(point: Point) -> Bool {
        let from1 = map1[point]
        let from2 = map2[point]
        return from1 || from2
    }
}

extension Map {
    func foldedHorizontally(_ y: Int) -> Map {
        let bottom = clippedBottom(y).flippedHorizontally()
        let top = clippedTop(y)
        return StackedMap(map1: top, map2: bottom)
    }
    func foldedVertically(_ x: Int) -> Map {
        let left = clippedLeft(x)
        let right = clippedRight(x).flippedVertically()
        return StackedMap(map1: left, map2: right)
    }
    func folded(by fold: Fold) -> Map {
        switch fold {
        case .x(let coord):
            return foldedVertically(coord)
        case .y(let coord):
            return foldedHorizontally(coord)
        }
    }
}

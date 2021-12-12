import Foundation

extension Day4 {
    struct Board {
        private let values: [[Int]]
        private var moves: [Int] = []
        private(set) var isFull = false
        init(values: [[Int]]) {
            self.values = values
        }
        mutating func addMove(_ move: Int) {
            moves.append(move)
            if !isFull {
                isFull = _isFull
            }
        }
        private var _isFull: Bool {
            for i in 0..<5 {
                if check(row: i) {
                    return true
                }
                if check(column: i) {
                    return true
                }
            }
            return false
        }
        func check(row: Int) -> Bool {
            let row = values[row]
            let rowSet = Set(row)
            let movesSet = Set(moves)
            return movesSet.intersection(rowSet).count == 5
        }
        func check(column: Int) -> Bool {
            let columnValues: [Int] = {
                var columnValues = [Int]()
                for i in 0..<5 {
                    columnValues.append(values[i][column])
                }
                return columnValues
            }()
            let columnSet = Set(columnValues)
            let movesSet = Set(moves)
            return movesSet.intersection(columnSet).count == 5
        }
        var uncheckedSum: Int {
            let movesSet = Set(moves)
            return values
                .flatMap { $0 }
                .filter {
                    !movesSet.contains($0)
                }
                .reduce(0, +)
        }
    }
}

struct Day4: Problem {
    func input(from stream: InputStream) throws -> (moves: [Int], boards: [Board]) {
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
        let strings = text.split(separator: "\n").map(String.init)
        let moves = strings.first!.split(separator: ",").map(String.init).compactMap(Int.init)
        let lines = strings.dropFirst().map {
            $0.split(separator: " ").map(String.init).compactMap(Int.init)
        }
        let boards: [Board] = {
            var boards = [Board]()
            var i = 0
            while i + 4 < lines.count {
                let values = Array(lines[i..<(i+5)])
                boards.append(.init(values: values))
                i += 5
            }
            return boards
        }()
        return (moves, boards)
    }

    func process(_ input: (moves: [Int], boards: [Board])) async throws -> (first: Int, second: Int) {
        let first: Int = {
            var lastMove: Int?
            var lastBoard: Int?
            let moves = input.moves
            var boards = input.boards
            moves: for move in 0..<moves.count {
                for board in 0..<boards.count {
                    boards[board].addMove(moves[move])
                    if boards[board].isFull {
                        lastMove = move
                        lastBoard = board
                        break moves
                    }
                }
            }
            return moves[lastMove!] * boards[lastBoard!].uncheckedSum
        }()

        let second: Int = {
            var lastMove: Int?
            var lastBoard: Int?
            let moves = input.moves
            var boards = input.boards
            moves: for move in 0..<moves.count {
                for board in 0..<boards.count {
                    boards[board].addMove(moves[move])
                    if !boards.map(\.isFull).contains(false) {
                        lastMove = move
                        lastBoard = board
                        break moves
                    }
                }
            }
            return moves[lastMove!] * boards[lastBoard!].uncheckedSum
        }()
        return (first, second)
    }

    func text(from output: (first: Int, second: Int)) -> String {
        String(describing: output)
    }
}

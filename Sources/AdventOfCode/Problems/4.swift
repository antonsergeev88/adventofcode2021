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

struct Day4: Day {
    let dayNumber = 4

    struct P: Parser {
        func parse(_ input: [String]) throws -> (moves: [Int], boards: [Day4.Board]) {
            let moves = input.first!.split(separator: ",").map(String.init).compactMap(Int.init)
            let lines = input.dropFirst().map {
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
    }

    struct S1: Solver {
        func solve(with input: (moves: [Int], boards: [Day4.Board])) async throws -> Int {
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
        }
    }

    struct S2: Solver {
        func solve(with input: (moves: [Int], boards: [Day4.Board])) async throws -> Int {
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
        }
    }


}

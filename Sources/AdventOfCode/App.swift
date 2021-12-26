@main
struct App {
    static func main() async throws {
        [
            try await Day1().run(with: "1"),
            try await Day2().run(with: "2"),
            try await Day3().run(with: "3"),
            try await Day4().run(with: "4"),
            try await Day5().run(with: "5"),
            try await Day6().run(with: "6"),
            try await Day7().run(with: "7"),
            try await Day8().run(with: "8"),
            try await Day9().run(with: "9"),
            try await Day10().run(with: "10"),
            try await Day11().run(with: "11"),
            try await Day12().run(with: "12"),
            try await Day13().run(with: "13"),
        ]
            .enumerated()
            .forEach { (offset, element) in
                print("Day \(offset + 1):\t\(element)")
            }
    }
}

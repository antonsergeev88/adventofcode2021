@main
struct App {
    static func main() async throws {
        [
            try await Day1().run(with: "1"),
            try await Day2().run(with: "2"),
        ]
            .enumerated()
            .forEach { (offset, element) in
                print("Day \(offset + 1):\t\(element)")
            }
    }
}

import Foundation

protocol Problem {
    associatedtype Input
    associatedtype Output
    func input(from stream: InputStream) throws -> Input
    func process(_ input: Input) async throws -> Output
    func text(from output: Output) -> String
}

extension Problem {
    func run(with inputFile: String) async throws -> String {
        guard
            let url = Bundle.module.resourceURL?
                .appendingPathComponent("Inputs")
                .appendingPathComponent(inputFile)
                .appendingPathExtension("txt"),
            let stream = InputStream(url: url)
        else {
            throw ProblemError.lostInput
        }
        stream.open()
        let input = try input(from: stream)
        stream.close()
        let output = try await process(input)
        return text(from: output)
    }
}

enum ProblemError: Error {
    case lostInput
    case badInput
}

extension Day {
    func process() async throws -> (first: String, second: String) {
        let input: [String] = try {
            guard
                let url = Bundle.module.resourceURL?
                    .appendingPathComponent("Inputs")
                    .appendingPathComponent("\(dayNumber)")
                    .appendingPathExtension("txt"),
                let string = try? String.init(contentsOf: url)
            else {
                throw ProblemError.lostInput
            }
            return string.split(separator: "\n").map(String.init)
        }()
        let parser = P()
        let parsedInput = try parser.parse(input)
        let solver1 = Self.S1()
        async let result1 = solver1.solve(with: parsedInput)
        let solver2 = Self.S2()
        async let result2 = solver2.solve(with: parsedInput)
        return try await (String(describing: result1), String(describing: result2))
    }
}

protocol DayProcessor {
    var dayNumber: Int { get }
    func process() async throws -> (first: String, second: String)
}

protocol Day: DayProcessor {
    associatedtype P: Parser
    associatedtype S1: Solver where S1.Input == P.ParsedInput
    associatedtype S2: Solver where S2.Input == P.ParsedInput
}

protocol Parser {
    associatedtype ParsedInput
    init()
    func parse(_ input: [String]) throws -> ParsedInput
}

protocol Solver {
    associatedtype Input
    associatedtype Output
    init()
    func solve(with input: Input) async throws -> Output
}

import Foundation

extension Day12 {
    class Node: Hashable {
        let name: String
        var isBig: Bool {
            name.uppercased() == name
        }
        var paths = Set<Node>()
        init(name: String) {
            self.name = name
        }

        static func == (lhs: Day12.Node, rhs: Day12.Node) -> Bool {
            lhs.name == rhs.name
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }
    }
    struct Map {
        let start: Node
        let end: Node

        static func with(strings: [String]) -> Self {
            var nodes = [String: Node]()
            strings.forEach { string in
                let first = string.split(separator: "-").map(String.init)[0]
                let second = string.split(separator: "-").map(String.init)[1]

                let firstNode: Node = {
                    if let node = nodes[first] {
                        return node
                    } else {
                        let node = Node(name: first)
                        nodes[first] = node
                        return node
                    }
                }()

                let secondNode: Node = {
                    if let node = nodes[second] {
                        return node
                    } else {
                        let node = Node(name: second)
                        nodes[second] = node
                        return node
                    }
                }()

                firstNode.paths.insert(secondNode)
                secondNode.paths.insert(firstNode)
            }

            let map = Map(start: nodes["start"]!, end: nodes["end"]!)
            return map
        }
    }
}

struct Day12: Problem {
    func input(from stream: InputStream) throws -> Map {
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
        return .with(strings: text.split(separator: "\n").map(String.init))
    }

    func process(_ input: Map) async throws -> (first: Int, second: Int) {
        let first: Int = {
            var counter: [Node: Int] = {
                var counter = [Node: Int]()
                func add(root: Node) {
                    guard counter[root] == nil else {
                        return
                    }
                    counter[root] = 0
                    for child in root.paths {
                        add(root: child)
                    }
                }
                add(root: input.start)
                return counter
            }()
            var first = 0
            func findPathsToEnd(root: Node) {
                guard counter[root]! < 1 || root.isBig else {
                    return
                }
                guard root.name != "end" else {
                    first += 1
                    return
                }
                counter[root]! += 1
                for child in root.paths {
                    findPathsToEnd(root: child)
                }
                counter[root]! -= 1
            }
            findPathsToEnd(root: input.start)
            return first
        }()
        let second: Int = {
            0
        }()
        return (first, second)
    }

    func text(from output: (first: Int, second: Int)) -> String {
        String(describing: output)
    }
}

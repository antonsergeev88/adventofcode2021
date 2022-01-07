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

struct Day12: Day {
    let dayNumber = 12

    struct P: Parser {
        func parse(_ input: [String]) throws -> Day12.Map {
            .with(strings: input)
        }
    }

    struct S1: Solver {
        func solve(with input: Day12.Map) async throws -> Int {
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
        }
    }

    struct S2: Solver {
        func solve(with input: Day12.Map) async throws -> Int {
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
                counter[root]! += 1
                defer {
                    counter[root]! -= 1
                }
                guard
                    counter.filter({!$0.key.isBig}).filter({$0.value > 1}).count <= 1,
                    counter.filter({!$0.key.isBig}).filter({$0.value > 2}).isEmpty
                else {
                    return
                }
                guard root.name != "start" else {
                    return
                }
                guard root.name != "end" else {
                    first += 1
                    return
                }

                for child in root.paths {
                    findPathsToEnd(root: child)
                }

            }
            input.start.paths.forEach { node in
                findPathsToEnd(root: node)
            }
            return first
        }
    }
}

//
// Advent of Code 2024 Day 23
//
// https://adventofcode.com/2024/day/23
//

import AoCTools

final class Day23: AdventOfCodeDay {
    let title: String
    let adjacencyList: [String: Set<String>]

    init(input: String) {
        title = "Day 23: LAN Party"
        adjacencyList = Self.parseInput(input)
        print("Initialized Day 23 with \(adjacencyList.count) nodes.")
        print(adjacencyList)
    }

    func part1() async -> Int {
        // Find all triangles (3-cliques)
        let triangles = findTriangles()

        // Filter for triangles with at least one node starting with 't'
        let withT = triangles.filter { triangleString in
            let nodes = triangleString.split(separator: ",").map(String.init)
            return nodes.contains { $0.starts(with: "t") }
        }

        return withT.count
    }

    func part2() async -> String {
        // Find the largest clique using Bron-Kerbosch algorithm
        let largestClique = findLargestClique()

        // Sort alphabetically and join with commas
        let password = largestClique.sorted().joined(separator: ",")

        return password
    }

    // MARK: - Helper Methods

    private func findLargestClique() -> Set<String> {
        var largestClique: Set<String> = []

        // Start with all triangles and greedily expand them
        let triangles = findTriangles()

        for triangleString in triangles {
            let nodes = Set(triangleString.split(separator: ",").map(String.init))
            var clique = nodes

            // Try to expand this clique by adding candidates
            while true {
                var expanded = false

                // Find candidates that are connected to ALL nodes in current clique
                let candidates = allNodesConnectedToClique(clique)

                if let nextNode = candidates.first {
                    clique.insert(nextNode)
                    expanded = true
                }

                if !expanded {
                    break
                }
            }

            // Update largest clique if this is bigger
            if clique.count > largestClique.count {
                largestClique = clique
            }
        }

        return largestClique
    }

    private func allNodesConnectedToClique(_ clique: Set<String>) -> Set<String> {
        // Find all nodes connected to EVERY node in the clique
        guard !clique.isEmpty else { return [] }

        let cliqueArray = Array(clique)
        var candidates = Set(adjacencyList.keys)

        // Remove nodes already in clique
        candidates.subtract(clique)

        // For each candidate, check if it's connected to all clique members
        return candidates.filter { candidate in
            cliqueArray.allSatisfy { cliqueNode in
                (adjacencyList[cliqueNode] ?? []).contains(candidate)
            }
        }
    }

    private func findTriangles() -> Set<String> {
        var triangles: Set<String> = []

        // For each node
        for nodeA in adjacencyList.keys {
            guard let neighborsA = adjacencyList[nodeA] else { continue }

            // For each neighbor of A
            for nodeB in neighborsA {
                guard let neighborsB = adjacencyList[nodeB] else { continue }

                // Find common neighbors of A and B
                let commonNeighbors = neighborsA.intersection(neighborsB)

                // Each common neighbor forms a triangle
                for nodeC in commonNeighbors {
                    // Create canonical form (sorted alphabetically)
                    let sortedNodes = [nodeA, nodeB, nodeC].sorted()
                    let triangleString = sortedNodes.joined(separator: ",")
                    triangles.insert(triangleString)
                }
            }
        }

        return triangles
    }

    private static func parseInput(_ input: String) -> [String: Set<String>] {
        var graph: [String: Set<String>] = [:]

        let lines = input.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n")

        for line in lines {
            let parts = line.split(separator: "-").map(String.init)
            guard parts.count == 2 else { continue }

            let a = parts[0]
            let b = parts[1]

            // Ensure both nodes exist in graph
            if graph[a] == nil {
                graph[a] = []
            }
            if graph[b] == nil {
                graph[b] = []
            }

            // Add bidirectional edges
            graph[a]?.insert(b)
            graph[b]?.insert(a)
        }

        return graph
    }
}

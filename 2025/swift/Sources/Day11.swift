//
// Twelve Days of Code 2025 Day 11
//
// https://adventofcode.com/2025/day/11
//

import AoCTools

final class Day11: AdventOfCodeDay {
    let title = "Reactor"

    /// Graph as adjacency list using integer indices for fast lookup
    private let adjacency: [[Int]]
    /// Map from node name to index
    private let nodeIndex: [String: Int]
    /// Special node indices
    private let youIdx, outIdx, svrIdx, dacIdx, fftIdx: Int

    init(input: String) {
        var nameToIdx: [String: Int] = [:]
        var edges: [(Int, Int)] = []

        // First pass: assign indices to all nodes
        for line in input.split(separator: "\n") {
            let parts = line.split(separator: ":")
            guard parts.count == 2 else { continue }
            let src = String(parts[0].trimmingCharacters(in: .whitespaces))
            if nameToIdx[src] == nil { nameToIdx[src] = nameToIdx.count }

            for dest in parts[1].split(separator: " ") {
                let d = String(dest.trimmingCharacters(in: .whitespaces))
                if nameToIdx[d] == nil { nameToIdx[d] = nameToIdx.count }
                edges.append((nameToIdx[src]!, nameToIdx[d]!))
            }
        }

        // Build adjacency list as array of arrays
        var adj = [[Int]](repeating: [], count: nameToIdx.count)
        for (src, dest) in edges {
            adj[src].append(dest)
        }

        self.adjacency = adj
        self.nodeIndex = nameToIdx
        self.youIdx = nameToIdx["you"] ?? -1
        self.outIdx = nameToIdx["out"] ?? -1
        self.svrIdx = nameToIdx["svr"] ?? -1
        self.dacIdx = nameToIdx["dac"] ?? -1
        self.fftIdx = nameToIdx["fft"] ?? -1
    }

    func part1() async -> Int {
        countPaths(from: youIdx, to: outIdx)
    }

    func part2() async -> Int {
        // Case A: svr → dac → fft → out
        // Case B: svr → fft → dac → out
        let pathA = countPaths(from: svrIdx, to: dacIdx)
                  * countPaths(from: dacIdx, to: fftIdx)
                  * countPaths(from: fftIdx, to: outIdx)

        let pathB = countPaths(from: svrIdx, to: fftIdx)
                  * countPaths(from: fftIdx, to: dacIdx)
                  * countPaths(from: dacIdx, to: outIdx)

        return pathA + pathB
    }

    /// Memoized DFS using integer indices for fast array lookup
    private func countPaths(from start: Int, to end: Int) -> Int {
        var memo = [Int](repeating: -1, count: adjacency.count)

        func dfs(_ node: Int) -> Int {
            if node == end { return 1 }
            if memo[node] >= 0 { return memo[node] }
            var count = 0
            for neighbor in adjacency[node] {
                count += dfs(neighbor)
            }
            memo[node] = count
            return count
        }

        return dfs(start)
    }
}

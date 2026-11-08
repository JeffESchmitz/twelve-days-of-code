//
// Twelve Days of Code 2025 Day 11
//
// https://adventofcode.com/2025/day/11
//

import Algorithms
import AoCTools

final class Day11: AdventOfCodeDay {
    let title = "Reactor"

    /// Graph as adjacency list using integer indices for fast lookup
    private let adjacency: [[Int]]
    /// Special node indices
    private let youIdx, outIdx, svrIdx, dacIdx, fftIdx: Int

    init(input: String) {
        // Parse lines into (source, [destinations]) pairs
        let parsed = input.split(separator: "\n").compactMap { line -> (String, [String])? in
            let parts = line.split(separator: ":")
            guard parts.count == 2 else { return nil }
            let src = String(parts[0]).trimmingCharacters(in: .whitespaces)
            let dests = parts[1].split(separator: " ").map { String($0).trimmingCharacters(in: .whitespaces) }
            return (src, dests)
        }

        // Collect all unique node names and assign indices
        let allNodes = parsed.flatMap { [$0.0] + $0.1 }
        let nameToIdx = Dictionary(uniqueKeysWithValues:
            Set(allNodes).enumerated().map { ($1, $0) }
        )

        // Build adjacency list using reduce
        let adj = parsed.reduce(into: [[Int]](repeating: [], count: nameToIdx.count)) { adj, pair in
            let srcIdx = nameToIdx[pair.0]!
            adj[srcIdx] = pair.1.map { nameToIdx[$0]! }
        }

        self.adjacency = adj
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
        let pathA = [svrIdx, dacIdx, fftIdx, outIdx].adjacentPairs()
            .map { countPaths(from: $0, to: $1) }
            .reduce(1, *)

        let pathB = [svrIdx, fftIdx, dacIdx, outIdx].adjacentPairs()
            .map { countPaths(from: $0, to: $1) }
            .reduce(1, *)

        return pathA + pathB
    }

    /// Memoized DFS using integer indices for fast array lookup
    private func countPaths(from start: Int, to end: Int) -> Int {
        var memo = [Int](repeating: -1, count: adjacency.count)

        func dfs(_ node: Int) -> Int {
            if node == end { return 1 }
            if memo[node] >= 0 { return memo[node] }
            let count = adjacency[node].reduce(0) { $0 + dfs($1) }
            memo[node] = count
            return count
        }

        return dfs(start)
    }
}

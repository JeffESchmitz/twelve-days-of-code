//
// Twelve Days of Code 2025 Day 11
//
// https://adventofcode.com/2025/day/11
//

import AoCTools

final class Day11: AdventOfCodeDay {
    let title = "Reactor"
    let graph: [String: [String]]

    init(input: String) {
        var adjacencyList: [String: [String]] = [:]
        for line in input.split(separator: "\n") {
            let parts = line.split(separator: ":")
            guard parts.count == 2 else { continue }
            let device = String(parts[0].trimmingCharacters(in: .whitespaces))
            let outputs = parts[1].split(separator: " ").map { String($0.trimmingCharacters(in: .whitespaces)) }
            adjacencyList[device] = outputs
        }
        self.graph = adjacencyList
    }

    func part1() async -> Int {
        // Part 1: Count all paths from "you" to "out"
        return countPaths(from: "you", to: "out")
    }

    func part2() async -> Int {
        // We need paths that visit BOTH dac AND fft (in any order)
        //
        // Case A: svr -> ... -> dac -> ... -> fft -> ... -> out
        // Case B: svr -> ... -> fft -> ... -> dac -> ... -> out
        //
        // Total = (paths_svr→dac × paths_dac→fft × paths_fft→out)
        //       + (paths_svr→fft × paths_fft→dac × paths_dac→out)

        // Case A: svr -> dac -> fft -> out
        let svrToDac = countPaths(from: "svr", to: "dac")
        let dacToFft = countPaths(from: "dac", to: "fft")
        let fftToOut = countPaths(from: "fft", to: "out")
        let pathA = svrToDac * dacToFft * fftToOut

        // Case B: svr -> fft -> dac -> out
        let svrToFft = countPaths(from: "svr", to: "fft")
        let fftToDac = countPaths(from: "fft", to: "dac")
        let dacToOut = countPaths(from: "dac", to: "out")
        let pathB = svrToFft * fftToDac * dacToOut

        return pathA + pathB
    }

    /// Memoized DFS to count paths between two specific nodes in the DAG
    /// Since the graph is a DAG (no cycles), we don't need visited tracking
    private func countPaths(from start: String, to end: String) -> Int {
        var memo: [String: Int] = [:]

        func dfs(_ current: String) -> Int {
            if current == end { return 1 }
            if let cached = memo[current] { return cached }

            guard let neighbors = graph[current] else { return 0 }

            var count = 0
            for neighbor in neighbors {
                count += dfs(neighbor)
            }

            memo[current] = count
            return count
        }

        return dfs(start)
    }
}

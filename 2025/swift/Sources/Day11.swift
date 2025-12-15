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
        return countWays(from: "you", pathVisited: [])
    }

    func part2() async -> Int {
        return countWaysWithRequired(from: "svr", visitedDac: false, visitedFft: false, pathVisited: [])
    }
}

extension Day11 {
    /// Recursively counts all possible Ways from a starting device to "out"
    func countWays(from current: String, pathVisited: Set<String>) -> Int {
        // Prevent cycles: if we've visited this node in the current path, stop
        if pathVisited.contains(current) {
            return 0
        }

        // Base case: if we reached "out", we found a Way!
        if current == "out" {
            return 1
        }

        // Guard against devices not in the graph (dead ends)
        guard let neighbors = graph[current] else {
            return 0  // No Ways from here
        }

        // Add current node to path
        var newPath = pathVisited
        newPath.insert(current)

        // Recursive case: explore all neighbors and sum up their Ways
        var totalWays = 0
        for neighbor in neighbors {
            totalWays += countWays(from: neighbor, pathVisited: newPath)
        }

        return totalWays
    }

    /// Part 2: Count Ways that visit both "dac" and "fft"
    func countWaysWithRequired(from current: String, visitedDac: Bool, visitedFft: Bool, pathVisited: Set<String>) -> Int {
        // Prevent cycles: if we've visited this node in the current path, stop
        if pathVisited.contains(current) {
            return 0
        }

        // Track if we've visited the required nodes
        var seenDac = visitedDac
        var seenFft = visitedFft

        if current == "dac" {
            seenDac = true
        }
        if current == "fft" {
            seenFft = true
        }

        // Base case: reached "out"
        if current == "out" {
            // Only count if we visited BOTH dac and fft
            return (seenDac && seenFft) ? 1 : 0
        }

        // Guard against dead ends
        guard let neighbors = graph[current] else {
            return 0
        }

        // Add current node to path
        var newPath = pathVisited
        newPath.insert(current)

        // Recursive case: explore all neighbors
        var totalWays = 0
        for neighbor in neighbors {
            totalWays += countWaysWithRequired(from: neighbor, visitedDac: seenDac, visitedFft: seenFft, pathVisited: newPath)
        }

        return totalWays
    }
}

//
// Twelve Days of Code 2025 Day 11
//
// https://adventofcode.com/2025/day/11
//

import AoCTools

final class Day11: AdventOfCodeDay {
    let title = "Reactor"
    let graph: [String: [String]]

    // Debug instrumentation for Part 2
    private var debugCallCount = 0
    private var debugPathsFound = 0
    private var debugMaxDepth = 0
    private let debugPrintInterval = 10000  // Print every 10k calls
    private var debugMaxPathsToFind: Int? = nil  // Set to limit paths

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
        // Reset debug counters
        debugCallCount = 0
        debugPathsFound = 0
        debugMaxDepth = 0
        // debugMaxPathsToFind = 100  // Uncomment to limit

        print("🔍 Starting Part 2 from 'svr'...")
        let startTime = Date()

        let result = countWaysWithRequired(
            from: "svr",
            visitedDac: false,
            visitedFft: false,
            pathVisited: [],
            depth: 0
        )

        let elapsed = Date().timeIntervalSince(startTime)
        print("📈 Final stats: \(debugCallCount) calls, \(debugPathsFound) paths, \(debugMaxDepth) max depth, \(String(format: "%.2f", elapsed))s")

        return result
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
    func countWaysWithRequired(from current: String, visitedDac: Bool, visitedFft: Bool, pathVisited: Set<String>, depth: Int = 0) -> Int {
        // Track call statistics
        debugCallCount += 1
        debugMaxDepth = max(debugMaxDepth, depth)

        // Print progress every N calls
        if debugCallCount % debugPrintInterval == 0 {
            print("📊 Calls: \(debugCallCount), Paths found: \(debugPathsFound), Max depth: \(debugMaxDepth), Current: \(current)")
        }

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
            if seenDac && seenFft {
                debugPathsFound += 1
                if debugPathsFound <= 10 {  // Print first 10 paths
                    print("✅ Path #\(debugPathsFound) found at depth \(depth)")
                }

                // Optional early termination
                if let limit = debugMaxPathsToFind, debugPathsFound >= limit {
                    return 1  // Early termination reached
                }

                return 1
            }
            return 0
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
            totalWays += countWaysWithRequired(
                from: neighbor,
                visitedDac: seenDac,
                visitedFft: seenFft,
                pathVisited: newPath,
                depth: depth + 1
            )
        }

        return totalWays
    }
}

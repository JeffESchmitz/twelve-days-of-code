//
// Advent of Code 2024 Day 19: Linen Layout
//
// https://adventofcode.com/2024/day/19
//

import AoCTools

final class Day19: AdventOfCodeDay {
    let title = "Day 19: Linen Layout"
    let patterns: [String]
    let designs: [String]

    init(input: String) {
        let lines = input.split(separator: "\n", omittingEmptySubsequences: false)

        // First line contains patterns separated by ", "
        self.patterns = lines[0].components(separatedBy: ", ")

        // After blank line, remaining lines are designs
        self.designs = lines.dropFirst(2).map(String.init)
    }

    func part1() async -> Int {
        // Count how many designs can be made from available patterns
        designs.filter { canMakeDesign($0) }.count
    }

    func part2() async -> Int {
        // Count total number of ways to construct all designs
        designs.reduce(0) { sum, design in
            sum + countWays(design)
        }
    }

    // Check if a design can be made by concatenating available patterns
    private func canMakeDesign(_ design: String) -> Bool {
        var memo: [String: Bool] = [:]

        func canMake(_ remaining: String) -> Bool {
            if remaining.isEmpty {
                return true
            }

            if let cached = memo[remaining] {
                return cached
            }

            // Try each pattern that matches the start of remaining
            for pattern in patterns {
                if remaining.hasPrefix(pattern) {
                    let rest = String(remaining.dropFirst(pattern.count))
                    if canMake(rest) {
                        memo[remaining] = true
                        return true
                    }
                }
            }

            memo[remaining] = false
            return false
        }

        return canMake(design)
    }

    // Count the number of ways to construct a design
    private func countWays(_ design: String) -> Int {
        var memo: [String: Int] = [:]

        func count(_ remaining: String) -> Int {
            if remaining.isEmpty {
                return 1
            }

            if let cached = memo[remaining] {
                return cached
            }

            var ways = 0
            // Try each pattern that matches the start of remaining
            for pattern in patterns {
                if remaining.hasPrefix(pattern) {
                    let rest = String(remaining.dropFirst(pattern.count))
                    ways += count(rest)
                }
            }

            memo[remaining] = ways
            return ways
        }

        return count(design)
    }
}

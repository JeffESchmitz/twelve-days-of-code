//
// Twelve Days of Code 2025 Day 5
//
// https://adventofcode.com/2025/day/5
//

import AoCTools
import Parsing

final class Day05: AdventOfCodeDay {
    let title = "Cafeteria"

    let freshRanges: [ClosedRange<Int>]
    let ingredientIDs: [Int]

    init(input: String) {
        // Parser for a single range: "start-end" → ClosedRange<Int>
        let rangeParser = Parse(input: Substring.self) {
            Int.parser()
            "-"
            Int.parser()
        }.map { start, end in start...end }

        // Parser for the ranges section (newline-separated)
        let rangesParser = Many {
            rangeParser
        } separator: {
            "\n"
        }

        // Parser for the IDs section (newline-separated integers)
        let idsParser: some Parser<Substring, [Int]> = Many {
            Int.parser()
        } separator: {
            "\n"
        }

        // Full input parser: ranges, blank line, IDs
        let inputParser = Parse {
            rangesParser
            "\n\n"
            idsParser
        }

        do {
            let (ranges, ids) = try inputParser.parse(input)
            self.freshRanges = ranges
            self.ingredientIDs = ids
        } catch {
            print("Parse error: \(error)")
            self.freshRanges = []
            self.ingredientIDs = []
        }
    }

    /// Part 1: Count how many ingredient IDs are fresh (fall within any range)
    func part1() async -> Int {
        ingredientIDs.count { id in
            freshRanges.contains { $0.contains(id) }
        }
    }

    /// Part 2: Count total unique IDs covered by all fresh ranges (merge overlapping ranges)
    func part2() async -> Int {
        // Sort ranges by start value
        let sorted = freshRanges.sorted { $0.lowerBound < $1.lowerBound }

        // Merge overlapping ranges
        var merged: [ClosedRange<Int>] = []
        for range in sorted {
            if let last = merged.last, last.upperBound >= range.lowerBound - 1 {
                // Overlapping or adjacent - extend the last range
                merged[merged.count - 1] = last.lowerBound...max(last.upperBound, range.upperBound)
            } else {
                // No overlap - add new range
                merged.append(range)
            }
        }

        // Sum up the sizes of all merged ranges
        return merged.map { $0.count }.sum()
    }
}

//
// Advent of Code 2024 Day 5
//
// https://adventofcode.com/2024/day/5
//

import AoCTools
import Algorithms // For combinations and median calculation
import Foundation

private struct Rule: Hashable {
    let page1: Int
    let page2: Int
}


final class Day05: AdventOfCodeDay {
    let title = "Print Queue"
    private let rules: Set<Rule>
    private let updates: [[Int]]

    init(input: String) {
        let sections = input.components(separatedBy: "\n\n")
        let rawRules = sections[0].split(separator: "\n")
        let rawUpdates = sections[1].split(separator: "\n")

        // Parse rules as a set of `Rule` objects
        self.rules = Set(
            rawRules.map { line in
                let parts = line.split(separator: "|").compactMap { Int($0) }
                return Rule(page1: parts[0], page2: parts[1])
            }
        )

        // Parse updates as arrays of integers
        self.updates = rawUpdates.map { line in
            line.split(separator: ",").compactMap { Int($0) }
        }
    }

    func part1() async -> Int {
        // Filter valid updates and sum their median values
        updates
            .filter { isValidUpdate($0) }
            .map { $0.median() }
            .reduce(0, +)
    }

    func part2() async -> Int {
        // Filter invalid updates, fix their order, and sum their median values
        updates
            .filter { !isValidUpdate($0) }
            .map { fixUpdateOrder($0) }
            .map { $0.median() }
            .reduce(0, +)
    }

    private func isValidUpdate(_ update: [Int]) -> Bool {
        // Check if all pairs of pages in the update satisfy the rules
        update
            .combinations(ofCount: 2)
            .map { Rule(page1: $0[0], page2: $0[1]) }
            .allSatisfy { rules.contains($0) }
    }

    private func fixUpdateOrder(_ update: [Int]) -> [Int] {
        // Sort the update using rules as the comparator
        return update.sorted { p1, p2 in
            rules.contains(Rule(page1: p1, page2: p2))
        }
    }
}

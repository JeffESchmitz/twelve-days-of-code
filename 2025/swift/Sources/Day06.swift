//
// Twelve Days of Code 2025 Day 6
//
// https://adventofcode.com/2025/day/6
//

import AoCTools

final class Day06: AdventOfCodeDay {
    let title = "Trash Compactor"

    let operatorRow: String
    let numberRows: [String]
    let width: Int

    init(input: String) {
        var lines = input.lines

        // Safeguard: ensure all lines are same length by padding shorter ones
        let maxWidth = lines.map(\.count).max() ?? 0
        lines = lines.map { line in
            line.count < maxWidth ? line + String(repeating: " ", count: maxWidth - line.count) : line
        }

        // Last line is operators, rest are numbers
        self.operatorRow = lines.last ?? ""
        self.numberRows = Array(lines.dropLast())
        self.width = maxWidth

        // Debug: verify our parsing
        assert(!operatorRow.isEmpty, "Operator row is empty")
        assert(!numberRows.isEmpty, "No number rows found")
        assert(numberRows.allSatisfy { $0.count == width }, "Number rows have inconsistent widths")
    }

    func part1() async -> Int {
        let separators = findSeparatorColumns()
        let ranges = findProblemRanges(separators: separators)

        return ranges.compactMap {
            solveProblem(in: $0)
        }.sum()
    }

    func part2() async -> Int {
        let separators = findSeparatorColumns()
        let ranges = findProblemRanges(separators: separators)

        return ranges.compactMap {
            solveProblemVertically(in: $0)
        }.sum()
    }

    // MARK: - Helper Functions

    /// Find all column indices where every row has a space character
    private func findSeparatorColumns() -> [Int] {
        let allRows = numberRows + [operatorRow]

        return (0..<width).filter { col in
            allRows.allSatisfy { row in
                let index = row.index(row.startIndex, offsetBy: col)
                return row[index] == " "
            }
        }
    }

    /// Convert separator columns into problem ranges
    /// Groups consecutive separators and returns the ranges between them
    private func findProblemRanges(separators: [Int]) -> [Range<Int>] {
        guard !separators.isEmpty else {
            // No separators = one big problem spanning entire width
            return [0..<width]
        }

        var ranges: [Range<Int>] = []

        // Group consecutive separator columns
        var groups: [[Int]] = []
        var currentGroup = [separators[0]]

        for i in 1..<separators.count {
            if separators[i] == separators[i - 1] + 1 {
                // Consecutive - add to current group
                currentGroup.append(separators[i])
            } else {
                // Gap found - start new group
                groups.append(currentGroup)
                currentGroup = [separators[i]]
            }
        }
        groups.append(currentGroup)

        // Build ranges between separator groups
        var prevEnd = 0
        for group in groups {
            let start = prevEnd
            let end = group.first!

            if end > start {
                ranges.append(start..<end)
            }
            prevEnd = group.last! + 1
        }

        // Handle final range after last separator group
        if prevEnd < width {
            ranges.append(prevEnd..<width)
        }

        return ranges
    }

    /// Solve a single problem within the given column range
    /// Returns the result of applying the operator to all numbers, or nil if invalid
    private func solveProblem(in range: Range<Int>) -> Int? {
        // Extract operator from this range
        let opChunk = operatorRow[range]
        let operators = opChunk.filter { $0 == "+" || $0 == "*" }

        guard let op = operators.first, operators.count == 1 else {
            // Skip ranges with no operator or multiple operators
            return nil
        }

        // Extract all numbers from the number rows in this range
        let numbers = numberRows.flatMap { row in
            row[range].integers()
        }

        guard !numbers.isEmpty else {
            return nil
        }

        // Apply the operation
        return op == "+" ? numbers.sum() : numbers.product()
    }

    /// Part 2: Solve a problem by reading numbers vertically (cephalopod math)
    /// Each column of digits forms one number (top-to-bottom = most-to-least significant)
    private func solveProblemVertically(in range: Range<Int>) -> Int? {
        // Extract operator from this range (same as Part 1)
        let opChunk = operatorRow[range]
        let operators = opChunk.filter { $0 == "+" || $0 == "*" }

        guard let op = operators.first, operators.count == 1 else {
            return nil
        }

        // Extract numbers by reading each COLUMN vertically
        var numbers: [Int] = []

        for col in range {
            // Collect digits from this column, top to bottom
            var digits: [Character] = []

            for row in numberRows {
                let index = row.index(row.startIndex, offsetBy: col)
                let char = row[index]
                if char.isNumber {
                    digits.append(char)
                }
            }

            // If we found digits, concatenate them into a number
            if !digits.isEmpty {
                let numString = String(digits)
                if let num = Int(numString) {
                    numbers.append(num)
                }
            }
        }

        guard !numbers.isEmpty else {
            return nil
        }

        // Apply the operation
        return op == "+" ? numbers.sum() : numbers.product()
    }
}

//
// Twelve Days of Code 2025 Day 3
//
// https://adventofcode.com/2025/day/3
//


import AoCTools

final class Day03: AdventOfCodeDay {
    let title = "Lobby"
    let banks: [[Int]]

    init(input: String) {
        // Parse each line as a bank of battery digits
        self.banks = input
            .split(separator: "\n")
            .map { line in
                line.compactMap { $0.wholeNumberValue }
            }
    }

    func part1() async -> Int {
        banks
            .map(maxJoltage)
            .sum()
    }

    func part2() async -> Int {
        banks
            .map { maxJoltageKDigits($0, keep: 12) }
            .sum()
    }

    // Part 1: One-pass algorithm - scan backwards maintaining max-so-far
    private func maxJoltage(_ bank: [Int]) -> Int {
        guard bank.count >= 2 else { return 0 }

        var maxJoltage = 0
        var maxSoFar = bank[bank.count - 1]  // Start with rightmost digit

        // Scan backwards from second-to-last to first
        for i in stride(from: bank.count - 2, through: 0, by: -1) {
            // At position i: use it as tens digit, maxSoFar is best ones digit
            let joltage = bank[i] * 10 + maxSoFar
            maxJoltage = max(maxJoltage, joltage)

            // Update maxSoFar to include this digit for next iteration
            maxSoFar = max(maxSoFar, bank[i])
        }

        return maxJoltage
    }

    // Part 2: Greedy selection - pick k digits to form maximum number
    // This is the "Remove K Digits" algorithm with monotonic stack
    private func maxJoltageKDigits(_ bank: [Int], keep: Int) -> Int {
        let n = bank.count

        // Edge case: bank has exactly k or fewer digits
        guard n > keep else {
            return bank.reduce(0) { $0 * 10 + $1 }
        }

        var skip = n - keep  // Number of digits we need to remove
        var stack: [Int] = []

        for digit in bank {
            // Remove smaller digits from stack while:
            // 1. We still have skips remaining
            // 2. Stack is not empty
            // 3. Top of stack is smaller than current digit
            while !stack.isEmpty && skip > 0 && stack.last! < digit {
                stack.removeLast()
                skip -= 1
            }

            stack.append(digit)
        }

        // If we still have skips remaining, remove from the end
        while skip > 0 {
            stack.removeLast()
            skip -= 1
        }

        // Convert stack to integer
        return stack.reduce(0) { $0 * 10 + $1 }
    }
}

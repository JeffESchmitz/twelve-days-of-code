//
// Twelve Days of Code 2025 Day 2: Gift Shop
//
// Problem: Find invalid product IDs in given ranges
// Part 1: IDs that are a pattern repeated exactly twice (e.g., 11, 6464, 123123)
// Part 2: IDs that are a pattern repeated at least twice (e.g., 111, 1212, 123123)
//
// https://adventofcode.com/2025/day/2
//

import AoCTools

// Precompute powers of 10 (10^0 through 10^18)
private let POW10: [Int] = {
    var powers = [Int](repeating: 1, count: 19)
    for i in 1..<powers.count {
        powers[i] = powers[i - 1] * 10
    }
    return powers
}()

/// Count the number of decimal digits in a positive integer
/// Example: digitsCount(123) = 3, digitsCount(7) = 1
private func digitsCount(_ number: Int) -> Int {
    var remaining = number
    var count = 0
    repeat {
        count += 1
        remaining /= 10
    } while remaining > 0
    return count
}

struct IDRange {
    let start: Int
    let end: Int
}

final class Day02: AdventOfCodeDay {
    let title = "Gift Shop"
    let ranges: [IDRange]

    init(input: String) {
        // Parse comma-separated ranges like "11-22,95-115,998-1012"
        self.ranges = input
            .split(whereSeparator: { $0 == "," || $0.isWhitespace })
            .compactMap { token -> IDRange? in
                let trimmed = token.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return nil }

                let parts = trimmed.split(separator: "-")
                guard parts.count == 2,
                      let start = Int(parts[0]),
                      let end = Int(parts[1]) else {
                    return nil
                }

                return IDRange(start: start, end: end)
            }
    }

    /// Check if a number is exactly a pattern repeated twice
    /// Examples: 11 (1+1), 6464 (64+64), 123123 (123+123)
    /// Algorithm: Uses pure arithmetic - no string conversion
    ///            If n = XX (two copies), then n = pattern × 10^k + pattern
    ///            where k is the number of digits in the pattern
    /// Example: 6464 = 64 × 100 + 64
    func isExactlyTwoCopies(_ number: Int) -> Bool {
        let totalDigits = digitsCount(number)

        // Must have even length (at least 2 digits)
        guard totalDigits >= 2, totalDigits % 2 == 0 else { return false }

        let patternLength = totalDigits / 2
        let divisor = POW10[patternLength]

        let upperHalf = number / divisor  // Extract upper pattern
        let lowerHalf = number % divisor  // Extract lower pattern

        return upperHalf == lowerHalf
    }

    func part1() async -> Int {
        ranges
            .flatMap { $0.start...$0.end }
            .filter(isExactlyTwoCopies)
            .sum()
    }

    /// Check if a number is a pattern repeated at least twice
    /// Examples: 1212 (12 twice), 111 (1 three times), 123123123 (123 three times)
    /// Algorithm: Uses pure arithmetic - no string conversion
    ///            Try all possible pattern lengths that evenly divide total digits
    ///            For each length k, extract the last k digits as the pattern
    ///            Reconstruct by repeating the pattern m times
    ///            Check if reconstruction matches original number
    func isRepeatedAtLeastTwice(_ number: Int) -> Bool {
        let totalDigits = digitsCount(number)

        // Need at least 2 digits to form a pattern
        guard totalDigits > 1 else { return false }

        // Try all possible pattern lengths (from 1 digit up to half the total)
        for patternLength in 1...(totalDigits / 2) {
            // Pattern length must evenly divide total digits
            guard totalDigits % patternLength == 0 else { continue }

            let repeatCount = totalDigits / patternLength
            guard repeatCount >= 2 else { continue }

            let divisor = POW10[patternLength]
            let pattern = number % divisor

            // Verify pattern has correct number of digits (no leading zeros)
            if patternLength > 1 && pattern < POW10[patternLength - 1] {
                continue  // Pattern would have leading zeros
            }

            // Reconstruct number by repeating pattern
            var reconstructed = 0
            for _ in 0..<repeatCount {
                reconstructed = reconstructed * divisor + pattern
            }

            if reconstructed == number {
                return true
            }
        }

        return false
    }

    func part2() async -> Int {
        ranges
            .flatMap { $0.start...$0.end }
            .filter(isRepeatedAtLeastTwice)
            .sum()
    }
}

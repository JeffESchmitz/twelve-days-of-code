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
    /// Algorithm: Split string in half and compare the two halves
    func isExactlyTwoCopies(_ number: Int) -> Bool {
        let numberString = String(number)
        let digitCount = numberString.count

        // Must have even length (at least 2 digits)
        guard digitCount >= 2, digitCount % 2 == 0 else { return false }

        // Split at midpoint
        let midIndex = numberString.index(numberString.startIndex, offsetBy: digitCount / 2)
        let firstHalf = numberString[numberString.startIndex..<midIndex]
        let secondHalf = numberString[midIndex..<numberString.endIndex]

        return firstHalf == secondHalf
    }

    func part1() async -> Int {
        var totalSum = 0
        for range in ranges {
            for productID in range.start...range.end where isExactlyTwoCopies(productID) {
                totalSum += productID
            }
        }

        return totalSum
    }

    /// Check if a number is a pattern repeated at least twice
    /// Examples: 1212 (12 twice), 111 (1 three times), 123123123 (123 three times)
    /// Algorithm: If string S is a repeated pattern, S will appear inside (S+S)[1..<end-1]
    /// Why this works: (ABC+ABC)[1..<5] = "BCAB" contains "ABC" if ABC is NOT repeated
    ///                 (AB+AB)[1..<3] = "BAB" contains "AB" ✓ (AB is repeated!)
    func isRepeatedAtLeastTwice(_ number: Int) -> Bool {
        let numberString = String(number)

        // Need at least 2 digits to form a pattern
        guard numberString.count > 1 else { return false }

        // Classic string rotation trick: concatenate string with itself
        let doubled = numberString + numberString

        // Remove first and last character
        let startIndex = doubled.index(after: doubled.startIndex)
        let endIndex = doubled.index(before: doubled.endIndex)
        let innerSubstring = doubled[startIndex..<endIndex]

        // If original string appears in the middle, it's a repeated pattern
        return innerSubstring.contains(numberString)
    }

    func part2() async -> Int {
        var totalSum = 0
        for range in ranges {
            for productID in range.start...range.end where isRepeatedAtLeastTwice(productID) {
                totalSum += productID
            }
        }

        return totalSum
    }
}

//
// Advent of Code 2024 Day 22
//
// https://adventofcode.com/2024/day/22
//

import AoCTools

typealias ChangeSequence = (a: Int, b: Int, c: Int, d: Int)

final class Day22: AdventOfCodeDay {
    let title: String
    let buyers: [Int]

    init(input: String) {
        title = "Day 22: Monkey Market"
        buyers = input.trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: "\n")
            .compactMap { Int($0) }
    }

    func part1() async -> Int {
        var sum = 0

        for buyer in buyers {
            var secret = buyer

            // Apply transformation 2000 times
            for _ in 0..<2000 {
                secret = nextSecret(secret)
            }

            sum += secret
        }

        return sum
    }

    func part2() async -> Int {
        // Step 1: Collect all sequences and their prices
        var sequencePrices: [String: [Int]] = [:]

        // For each buyer
        for buyer in buyers {
            var secret = buyer
            var prices: [Int] = [secret % 10]  // Start with initial price (ones digit)

            // Generate 2000 secret numbers and extract prices
            for _ in 0..<2000 {
                secret = nextSecret(secret)
                prices.append(secret % 10)
            }

            // Now we have 2001 prices. Calculate changes (2000 changes total)
            var changes: [Int] = []
            for i in 1..<prices.count {
                changes.append(prices[i] - prices[i - 1])
            }

            // Track which sequences we've already recorded for this buyer
            // (we only want the FIRST occurrence of each sequence per buyer)
            var seenSequences: Set<String> = []

            // Look for all 4-change windows in this buyer's changes
            for i in 0..<(changes.count - 3) {
                let seqKey = "\(changes[i]),\(changes[i + 1]),\(changes[i + 2]),\(changes[i + 3])"

                // Only record if we haven't seen this sequence for this buyer yet
                if !seenSequences.contains(seqKey) {
                    seenSequences.insert(seqKey)
                    let price = prices[i + 4]  // Price at the end of the 4-change window

                    if sequencePrices[seqKey] == nil {
                        sequencePrices[seqKey] = []
                    }
                    sequencePrices[seqKey]!.append(price)
                }
            }
        }

        // Step 2: Find the sequence with the maximum total bananas
        var maxBananas = 0

        for (_, prices) in sequencePrices {
            let totalBananas = prices.reduce(0, +)
            maxBananas = max(maxBananas, totalBananas)
        }

        return maxBananas
    }

    // MARK: - Helper Functions

    private func nextSecret(_ secret: Int) -> Int {
        let modulo = 16_777_216

        // Step 1: multiply by 64, mix, prune
        var result = secret * 64
        result ^= secret
        result %= modulo

        // Step 2: divide by 32, mix, prune
        let step1Result = result
        result = result / 32
        result ^= step1Result
        result %= modulo

        // Step 3: multiply by 2048, mix, prune
        let step2Result = result
        result = result * 2048
        result ^= step2Result
        result %= modulo

        return result
    }
}

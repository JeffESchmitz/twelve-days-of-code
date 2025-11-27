//
// Advent of Code 2024 Day 11
//
// https://adventofcode.com/2024/day/11
//

import AoCTools
import Algorithms
import Foundation

final class Day11: AdventOfCodeDay {
    let title = "Plutonian Pebbles"
    let stones: [Int]
    
    init(input: String) {
        self.stones = input.split(separator: " ").compactMap { Int($0) }
    }

    func part1() async -> Int {
        // Hard-coded blinks: 25
        let finalStones = performOptimizedBlinks(stones, 25)
        return finalStones
    }

    func part2() async -> Int {
        // Hard-coded blinks: 75
        let finalStones = performOptimizedBlinks(stones, 75)
        return finalStones
    }
}

extension Day11 {
    func splitEvenDigits(_ stone: Int) -> [Int] {
        let digits = String(stone)
        let mid = digits.count / 2
        let left = Int(digits.prefix(mid)) ?? 0
        let right = Int(digits.suffix(mid)) ?? 0
        return [left, right]
    }

    func transformStone(_ stone: Int) -> [Int] {
        if stone == 0 {
            return [1]
        } else if String(stone).count % 2 == 0 {
            return splitEvenDigits(stone)
        } else {
            return [stone * 2024]
        }
    }

    func performBlinks(_ stones: [Int], _ blinks: Int) -> [Int] {
        return (0..<blinks).reduce(stones) { currentStones, _ in
            try! currentStones.flatMap(transformStone)
        }
    }
    
    func performOptimizedBlinks(_ stones: [Int], _ blinks: Int) -> Int {
        var stoneCounts = stones.reduce(into: [Int: Int]()) { $0[$1, default: 0] += 1 }

        (0..<blinks).forEach { _ in
            stoneCounts = stoneCounts.flatMap { (stone, count) in
                transformStone(stone).map { ($0, count) }
            }.reduce(into: [Int: Int]()) { $0[$1.0, default: 0] += $1.1 }
        }

        return stoneCounts.values.reduce(0, +)
    }
}

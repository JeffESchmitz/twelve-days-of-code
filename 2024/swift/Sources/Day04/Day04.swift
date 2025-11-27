//
// Advent of Code 2024 Day 4
//
// https://adventofcode.com/2024/day/4
//

import AoCTools
import Foundation

final class Day04: AdventOfCodeDay, @unchecked Sendable {
    let title: String = "Ceres Search"
    let grid: Grid<Character>
//    let grid: [Point: Character]
    
    init(input: String) {
        self.grid = Grid.parse(input.lines)
    }

    func part1() async -> Int {
        return countWordOccurrences(grid: grid, word: "XMAS")
    }

    func part2() async -> Int {
        return countXMASPatterns(grid: grid)
    }


    private func countXMASPatterns(grid: Grid<Character>) -> Int {
        var total = 0

        for (center, letter) in grid.points {
            guard letter == "A" else { continue }

            var numMAS = 0

            // Check all diagonal neighbors for 'M'
            for diagonal in Direction.ordinal {
                let mPoint = center.moved(to: diagonal) // Neighboring M
                guard grid.points[mPoint] == "M" else { continue }

                // Find the opposite diagonal point for 'S'
                let sPoint = center.moved(to: diagonal.opposite)
                guard grid.points[sPoint] == "S" else { continue }

                numMAS += 1
            }

            // If exactly two valid MAS patterns are found, increment total
            if numMAS == 2 {
                total += 1
            }
        }

        return total
    }

    private func countWordOccurrences(grid: Grid<Character>, word: String) -> Int {
        // Same part 1 implementation
        let wordArray = Array(word)
        var total = 0

        for (point, letter) in grid.points {
            guard letter == wordArray.first else { continue }

            for direction in Direction.allCases {
                var match = true
                var current = point

                for nextLetter in wordArray.dropFirst() {
                    current = current.moved(to: direction)
                    if let nextChar = grid.points[current], nextChar == nextLetter {
                        continue
                    } else {
                        match = false
                        break
                    }
                }

                if match {
                    total += 1
                }
            }
        }

        return total
    }
}

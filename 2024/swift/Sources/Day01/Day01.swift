//
// Advent of Code 2024 Day 1
//
// https://adventofcode.com/2024/day/1
//

import AoCTools
import Foundation
import Parsing

struct Pair: Equatable {
    let left: Int
    let right: Int
}

struct PairParser: Parser {
    var body: some Parser<Substring, Pair> {
        Parse(Pair.init(left:right:)) {
            Int.parser()
            Whitespace()
            Int.parser()
        }
    }
}

final class Day01: AdventOfCodeDay {
    let title = "Historian Hysteria"
    let input: String

    init(input: String) {
        self.input = input
    }

    func part1() async -> Int {
        let (leftList, rightList) = parseInput()
        return totalDistance(leftList: leftList, rightList: rightList)
    }

    func part2() async -> Int {
        let (leftList, rightList) = parseInput()
        let rightCounts = countOccurrences(in: rightList)
        return leftList.reduce(0) { $0 + $1 * rightCounts[$1, default: 0] }
    }

    func parseInput() -> ([Int], [Int]) {
        let pairParser = PairParser()

        let pairs = input
            .split(separator: "\n")
            .compactMap { try? pairParser.parse($0[...]) }

        let leftList = pairs.map(\.left)
        let rightList = pairs.map(\.right)
        return (leftList, rightList)
    }

    private func countOccurrences(in list: [Int]) -> [Int: Int] {
        // Functional approach to count occurrences
        return list.reduce(into: [:]) { counts, number in
            counts[number, default: 0] += 1
        }
    }

    private func totalDistance(leftList: [Int], rightList: [Int]) -> Int {
        let sortedLeft = leftList.sorted()
        let sortedRight = rightList.sorted()
        return zip(sortedLeft, sortedRight).reduce(0) { $0 + abs($1.0 - $1.1) }
    }
}

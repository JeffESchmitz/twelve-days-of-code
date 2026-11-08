//
// Twelve Days of Code 2025 Day 7
//
// https://adventofcode.com/2025/day/7
//


import AoCTools

final class Day07: AdventOfCodeDay {
    let title = "Laboratories"

    let startColumn: Int
    let width: Int
    let rowCount: Int
    let splitters: [Set<Int>]  // Pre-parsed: splitter columns for each row

    init(input: String) {
        let lines = input.lines
        self.width = lines.first?.count ?? 0
        self.rowCount = lines.count

        // Find the starting column (where S is located)
        var foundColumn = 0
        for line in lines {
            if let colIndex = line.firstIndex(of: "S") {
                foundColumn = line.distance(from: line.startIndex, to: colIndex)
                break
            }
        }
        self.startColumn = foundColumn

        // Pre-parse all splitter positions
        self.splitters = lines.map { line in
            var cols = Set<Int>()
            for (idx, char) in line.enumerated() where char == "^" {
                cols.insert(idx)
            }
            return cols
        }
    }

    func part1() async -> Int {
        var activeBeams: Set<Int> = [startColumn]
        var splitCount = 0

        for row in 1..<rowCount {
            guard !activeBeams.isEmpty else { break }
            let rowSplitters = splitters[row]
            var newBeams: Set<Int> = []

            for col in activeBeams {
                guard col >= 0 && col < width else { continue }

                if rowSplitters.contains(col) {
                    splitCount += 1
                    newBeams.insert(col - 1)
                    newBeams.insert(col + 1)
                } else {
                    newBeams.insert(col)
                }
            }

            activeBeams = newBeams.filter { $0 >= 0 && $0 < width }
        }

        return splitCount
    }

    func part2() async -> Int {
        var timelines: [Int: Int] = [startColumn: 1]

        for row in 1..<rowCount {
            guard !timelines.isEmpty else { break }
            let rowSplitters = splitters[row]
            var newTimelines: [Int: Int] = [:]

            for (col, count) in timelines {
                guard col >= 0 && col < width else { continue }

                if rowSplitters.contains(col) {
                    if col - 1 >= 0 { newTimelines[col - 1, default: 0] += count }
                    if col + 1 < width { newTimelines[col + 1, default: 0] += count }
                } else {
                    newTimelines[col, default: 0] += count
                }
            }

            timelines = newTimelines
        }

        return timelines.values.reduce(0, +)
    }
}

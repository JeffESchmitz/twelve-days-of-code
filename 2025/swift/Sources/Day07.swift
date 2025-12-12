//
// Twelve Days of Code 2025 Day 7
//
// https://adventofcode.com/2025/day/7
//


import AoCTools

final class Day07: AdventOfCodeDay {
    let title = "Laboratories"
    
    let lines: [String]
    let startColumn: Int

    init(input: String) {
        self.lines = input.lines
        
        // Find the starting column (where S is located)
        var foundColumn = 0
        for (rowIndex, line) in lines.enumerated() {
            if let colIndex = line.firstIndex(of: "S") {
                foundColumn = line.distance(from: line.startIndex, to: colIndex)
                break
            }
        }
        self.startColumn = foundColumn
    }

    func part1() async -> Int {
        var activeBeams: Set<Int> = [startColumn]
        var splitCount = 0
        let width = lines.first?.count ?? 0
        
        // Process each row starting from the row after S
        for row in 1..<lines.count {
            let line = lines[row]
            var newBeams: Set<Int> = []
            
            for col in activeBeams {
                // Check the bounds
                guard col >= 0 && col < width else { continue }
                
                let charIndex = line.index(line.startIndex, offsetBy: col)
                let char = line[charIndex]
                
                if char == "^" {
                    // Beam hits a splitter - count it and spawn left/right beams
                    splitCount += 1
                    newBeams.insert(col - 1)
                    newBeams.insert(col + 1)
                } else {
                    // Beam continues downward
                    newBeams.insert(col)
                }
            }
            
            // Filter out beams that went off the edges
            activeBeams = newBeams.filter { $0 >= 0 && $0 < width }
            
            // Stop if no more active beams
            if activeBeams.isEmpty {
                break 
            }
        }
        
        return splitCount
    }

    func part2() async -> Int {
        // Part 2: Count timelines, not splits
        // Key difference: timelines in the same column DON'T merge
        // Use Dictionary<Int, Int> to track count of timelines at each column

        var timelines: [Int: Int] = [startColumn: 1]  // Start with 1 timeline at S
        let width = lines.first?.count ?? 0

        // Process each row starting from the row after S
        for row in 1..<lines.count {
            let line = lines[row]
            var newTimelines: [Int: Int] = [:]

            for (col, count) in timelines {
                // Check bounds
                guard col >= 0 && col < width else { continue }

                let charIndex = line.index(line.startIndex, offsetBy: col)
                let char = line[charIndex]

                if char == "^" {
                    // Each timeline at this column splits into 2
                    // Left and right each get the same count
                    newTimelines[col - 1, default: 0] += count
                    newTimelines[col + 1, default: 0] += count
                } else {
                    // Timelines continue downward
                    newTimelines[col, default: 0] += count
                }
            }

            // Filter out timelines that went off the edges
            timelines = newTimelines.filter { $0.key >= 0 && $0.key < width }

            // Stop if no more timelines
            if timelines.isEmpty { break }
        }

        // Sum up all timelines across all columns
        return timelines.values.reduce(0, +)
    }
}

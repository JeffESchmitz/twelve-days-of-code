//
//  Day09Tests.swift
//  AdventOfCode
//
//  Created by Jeff E. Schmitz on 11/16/25.
//


//
// Twelve Days of Code 2025 Day 9 Tests
//

import Testing
@testable import TwelveDaysOfCode

private let testInput = """
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
"""

@Suite("Day 9 Tests")
struct Day09Tests {
    @Test("Day 9 Part 1", .tags(.testInput))
    func testDay09_part1() async {
        let day = Day09(input: testInput)
        // Largest rectangle uses corners (2,5) and (11,1)
        // Area = (|11-2|+1) * (|5-1|+1) = 10 * 5 = 50 (inclusive of both corners as tiles)
        await #expect(day.part1() == 50)
    }

    @Test("Day 9 Part 1 Solution")
    func testDay09_part1_solution() async {
        let day = Day09(input: Day09.input)
        await #expect(day.part1() == 4746238001)
    }

    @Test("Day 9 Part 2", .tags(.testInput))
    func testDay09_part2() async {
        let day = Day09(input: testInput)
        // Part 2 not yet revealed
        await #expect(day.part2() == -1)
    }

    @Test("Day 9 Part 2 Solution")
    func testDay09_part2_solution() async {
        let day = Day09(input: Day09.input)
        // Part 2 not yet revealed
        await #expect(day.part2() == -1)
    }
}

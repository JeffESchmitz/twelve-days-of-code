//
//  Day05Tests.swift
//  AdventOfCode
//
//  Created by Jeff E. Schmitz on 11/16/25.
//

import Testing
@testable import TwelveDaysOfCode

fileprivate let testInput = """
3-5
10-14
16-20
12-18

1
5
8
11
17
32
"""

@Suite("Day 5 Tests")
struct Day05Tests {
    @Test("Day 5 Part 1", .tags(.testInput))
    func testDay05_part1() async {
        let day = Day05(input: testInput)
        await #expect(day.part1() == 3)  // IDs 5, 11, 17 are fresh
    }

    @Test("Day 5 Part 1 Solution")
    func testDay05_part1_solution() async {
        let day = Day05(input: Day05.input)
        await #expect(day.part1() == 789)
    }

    @Test("Day 5 Part 2", .tags(.testInput))
    func testDay05_part2() async {
        let day = Day05(input: testInput)
        await #expect(day.part2() == 14)  // Unique IDs: 3-5, 10-20 = 14 total
    }

    @Test("Day 5 Part 2 Solution")
    func testDay05_part2_solution() async {
        let day = Day05(input: Day05.input)
        await #expect(day.part2() == 343329651880509)
    }
}

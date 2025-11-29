//
//  Day05Tests.swift
//  AdventOfCode
//
//  Created by Jeff E. Schmitz on 11/16/25.
//


//
// Twelve Days of Code 2025 Day 5 Tests
//

import Testing
@testable import TwelveDaysOfCode

fileprivate let testInput = """
"""

@Suite("Day 5 Tests")
struct Day05Tests {
    @Test("Day 5 Part 1", .tags(.testInput))
    func testDay05_part1() async {
        let day = Day05(input: testInput)
        await #expect(day.part1() == 0)
    }

    @Test("Day 5 Part 1 Solution")
    func testDay05_part1_solution() async {
        let day = Day05(input: Day05.input)
        await #expect(day.part1() == 0)
    }

    @Test("Day 5 Part 2", .tags(.testInput))
    func testDay05_part2() async {
        let day = Day05(input: testInput)
        await #expect(day.part2() == 0)
    }

    @Test("Day 5 Part 2 Solution")
    func testDay05_part2_solution() async {
        let day = Day05(input: Day05.input)
        await #expect(day.part2() == 0)
    }
}

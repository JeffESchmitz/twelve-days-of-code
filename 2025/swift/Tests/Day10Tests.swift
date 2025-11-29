//
//  Day10Tests.swift
//  AdventOfCode
//
//  Created by Jeff E. Schmitz on 11/16/25.
//


//
// Twelve Days of Code 2025 Day 10 Tests
//

import Testing
@testable import TwelveDaysOfCode

fileprivate let testInput = """
"""

@Suite("Day 10 Tests")
struct Day10Tests {
    @Test("Day 10 Part 1", .tags(.testInput))
    func testDay10_part1() async {
        let day = Day10(input: testInput)
        await #expect(day.part1() == 0)
    }

    @Test("Day 10 Part 1 Solution")
    func testDay10_part1_solution() async {
        let day = Day10(input: Day10.input)
        await #expect(day.part1() == 0)
    }

    @Test("Day 10 Part 2", .tags(.testInput))
    func testDay10_part2() async {
        let day = Day10(input: testInput)
        await #expect(day.part2() == 0)
    }

    @Test("Day 10 Part 2 Solution")
    func testDay10_part2_solution() async {
        let day = Day10(input: Day10.input)
        await #expect(day.part2() == 0)
    }
}

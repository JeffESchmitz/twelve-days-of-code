//
//  Day01Tests.swift
//  AdventOfCode
//
//  Created by Jeff E. Schmitz on 11/16/25.
//


//
// Twelve Days of Code 2025 Day 1 Tests
//

import Testing
@testable import TwelveDaysOfCode

fileprivate let testInput = """
"""

@Suite("Day 1 Tests")
struct Day01Tests {
    @Test("Day 1 Part 1", .tags(.testInput))
    func testDay01_part1() async {
        let day = Day01(input: testInput)
        await #expect(day.part1() == 0)
    }

    @Test("Day 1 Part 1 Solution")
    func testDay01_part1_solution() async {
        let day = Day01(input: Day01.input)
        await #expect(day.part1() == 0)
    }

    @Test("Day 1 Part 2", .tags(.testInput))
    func testDay01_part2() async {
        let day = Day01(input: testInput)
        await #expect(day.part2() == 0)
    }

    @Test("Day 1 Part 2 Solution")
    func testDay01_part2_solution() async {
        let day = Day01(input: Day01.input)
        await #expect(day.part2() == 0)
    }
}

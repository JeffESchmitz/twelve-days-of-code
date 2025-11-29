//
//  Day02Tests.swift
//  AdventOfCode
//
//  Created by Jeff E. Schmitz on 11/16/25.
//


//
// Twelve Days of Code 2025 Day 2 Tests
//

import Testing
@testable import TwelveDaysOfCode

fileprivate let testInput = """
"""

@Suite("Day 2 Tests")
struct Day02Tests {
    @Test("Day 2 Part 1", .tags(.testInput))
    func testDay02_part1() async {
        let day = Day02(input: testInput)
        await #expect(day.part1() == 0)
    }

    @Test("Day 2 Part 1 Solution")
    func testDay02_part1_solution() async {
        let day = Day02(input: Day02.input)
        await #expect(day.part1() == 0)
    }

    @Test("Day 2 Part 2", .tags(.testInput))
    func testDay02_part2() async {
        let day = Day02(input: testInput)
        await #expect(day.part2() == 0)
    }

    @Test("Day 2 Part 2 Solution")
    func testDay02_part2_solution() async {
        let day = Day02(input: Day02.input)
        await #expect(day.part2() == 0)
    }
}

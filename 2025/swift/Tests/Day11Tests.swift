//
//  Day11Tests.swift
//  AdventOfCode
//
//  Created by Jeff E. Schmitz on 11/16/25.
//


//
// Twelve Days of Code 2025 Day 11 Tests
//

import Testing
@testable import TwelveDaysOfCode

fileprivate let testInput = """
"""

@Suite("Day 11 Tests")
struct Day11Tests {
    @Test("Day 11 Part 1", .tags(.testInput))
    func testDay11_part1() async {
        let day = Day11(input: testInput)
        await #expect(day.part1() == 0)
    }

    @Test("Day 11 Part 1 Solution")
    func testDay11_part1_solution() async {
        let day = Day11(input: Day11.input)
        await #expect(day.part1() == 0)
    }

    @Test("Day 11 Part 2", .tags(.testInput))
    func testDay11_part2() async {
        let day = Day11(input: testInput)
        await #expect(day.part2() == 0)
    }

    @Test("Day 11 Part 2 Solution")
    func testDay11_part2_solution() async {
        let day = Day11(input: Day11.input)
        await #expect(day.part2() == 0)
    }
}

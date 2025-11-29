//
//  Day12Tests.swift
//  AdventOfCode
//
//  Created by Jeff E. Schmitz on 11/16/25.
//


//
// Twelve Days of Code 2025 Day 12 Tests
//

import Testing
@testable import TwelveDaysOfCode

fileprivate let testInput = """
"""

@Suite("Day 12 Tests")
struct Day12Tests {
    @Test("Day 12 Part 1", .tags(.testInput))
    func testDay12_part1() async {
        let day = Day12(input: testInput)
        await #expect(day.part1() == 0)
    }

    @Test("Day 12 Part 1 Solution")
    func testDay12_part1_solution() async {
        let day = Day12(input: Day12.input)
        await #expect(day.part1() == 0)
    }

    @Test("Day 12 Part 2", .tags(.testInput))
    func testDay12_part2() async {
        let day = Day12(input: testInput)
        await #expect(day.part2() == 0)
    }

    @Test("Day 12 Part 2 Solution")
    func testDay12_part2_solution() async {
        let day = Day12(input: Day12.input)
        await #expect(day.part2() == 0)
    }
}

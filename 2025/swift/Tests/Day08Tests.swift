//
//  Day08Tests.swift
//  AdventOfCode
//
//  Created by Jeff E. Schmitz on 11/16/25.
//


//
// Twelve Days of Code 2025 Day 8 Tests
//

import Testing
@testable import TwelveDaysOfCode

fileprivate let testInput = """
"""

@Suite("Day 8 Tests")
struct Day08Tests {
    @Test("Day 8 Part 1", .tags(.testInput))
    func testDay08_part1() async {
        let day = Day08(input: testInput)
        await #expect(day.part1() == 0)
    }

    @Test("Day 8 Part 1 Solution")
    func testDay08_part1_solution() async {
        let day = Day08(input: Day08.input)
        await #expect(day.part1() == 0)
    }

    @Test("Day 8 Part 2", .tags(.testInput))
    func testDay08_part2() async {
        let day = Day08(input: testInput)
        await #expect(day.part2() == 0)
    }

    @Test("Day 8 Part 2 Solution")
    func testDay08_part2_solution() async {
        let day = Day08(input: Day08.input)
        await #expect(day.part2() == 0)
    }
}

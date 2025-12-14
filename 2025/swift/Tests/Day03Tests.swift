//
//  Day03Tests.swift
//  AdventOfCode
//
//  Created by Jeff E. Schmitz on 11/16/25.
//

import Testing
@testable import TwelveDaysOfCode

fileprivate let testInput = """
"""

@Suite("Day 3 Tests")
struct Day03Tests {
    @Test("Day 3 Part 1", .tags(.testInput))
    func testDay03_part1() async {
        let day = Day03(input: testInput)
        await #expect(day.part1() == 0)
    }

    @Test("Day 3 Part 1 Solution")
    func testDay03_part1_solution() async {
        let day = Day03(input: Day03.input)
        await #expect(day.part1() == 17613)
    }

    @Test("Day 3 Part 2", .tags(.testInput))
    func testDay03_part2() async {
        let day = Day03(input: testInput)
        await #expect(day.part2() == 0)
    }

    @Test("Day 3 Part 2 Solution")
    func testDay03_part2_solution() async {
        let day = Day03(input: Day03.input)
        await #expect(day.part2() == 175304218462560)
    }
}

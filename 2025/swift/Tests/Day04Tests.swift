//
//  Day04Tests.swift
//  AdventOfCode
//
//  Created by Jeff E. Schmitz on 11/16/25.
//

import Testing
@testable import TwelveDaysOfCode

fileprivate let testInput = """
"""

@Suite("Day 4 Tests")
struct Day04Tests {
    @Test("Day 4 Part 1", .tags(.testInput))
    func testDay04_part1() async {
        let day = Day04(input: testInput)
        await #expect(day.part1() == 0)
    }

    @Test("Day 4 Part 1 Solution")
    func testDay04_part1_solution() async {
        let day = Day04(input: Day04.input)
        await #expect(day.part1() == 0)
    }

    @Test("Day 4 Part 2", .tags(.testInput))
    func testDay04_part2() async {
        let day = Day04(input: testInput)
        await #expect(day.part2() == 0)
    }

    @Test("Day 4 Part 2 Solution")
    func testDay04_part2_solution() async {
        let day = Day04(input: Day04.input)
        await #expect(day.part2() == 0)
    }
}

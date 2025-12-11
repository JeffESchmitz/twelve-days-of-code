//
//  Day06Tests.swift
//  AdventOfCode
//
//  Created by Jeff E. Schmitz on 11/16/25.
//


//
// Twelve Days of Code 2025 Day 6 Tests
//

import Testing
@testable import TwelveDaysOfCode

fileprivate let testInput = """
123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +
"""

@Suite("Day 6 Tests")
struct Day06Tests {
    @Test("Day 6 Part 1", .tags(.testInput))
    func testDay06_part1() async {
        let day = Day06(input: testInput)
        await #expect(day.part1() == 4277556)
    }

    @Test("Day 6 Part 1 Solution")
    func testDay06_part1_solution() async {
        let day = Day06(input: Day06.input)
        await #expect(day.part1() == 4309240495780)
    }

    @Test("Day 6 Part 2", .tags(.testInput))
    func testDay06_part2() async {
        let day = Day06(input: testInput)
        await #expect(day.part2() == 3263827)
    }

    @Test("Day 6 Part 2 Solution")
    func testDay06_part2_solution() async {
        let day = Day06(input: Day06.input)
        await #expect(day.part2() == 9170286552289)
    }
}

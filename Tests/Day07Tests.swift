//
//  Day07Tests.swift
//  AdventOfCode
//
//  Created by Jeff E. Schmitz on 11/16/25.
//

import Testing
@testable import TwelveDaysOfCode

fileprivate let testInput = """
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
"""

@Suite("Day 7 Tests")
struct Day07Tests {
    @Test("Day 7 Part 1", .tags(.testInput))
    func testDay07_part1() async {
        let day = Day07(input: testInput)
        await #expect(day.part1() == 21)
    }

    @Test("Day 7 Part 1 Solution")
    func testDay07_part1_solution() async {
        let day = Day07(input: Day07.input)
        await #expect(day.part1() == 1626)
    }

    @Test("Day 7 Part 2", .tags(.testInput))
    func testDay07_part2() async {
        let day = Day07(input: testInput)
        await #expect(day.part2() == 40)
    }

    @Test("Day 7 Part 2 Solution")
    func testDay07_part2_solution() async {
        let day = Day07(input: Day07.input)
        await #expect(day.part2() == 48989920237096)
    }
}

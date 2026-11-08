//
//  Day10Tests.swift
//  AdventOfCode
//
//  Created by Jeff E. Schmitz on 11/16/25.
//

import Testing
@testable import TwelveDaysOfCode

private let testInput = """
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
"""

@Suite("Day 10 Tests")
struct Day10Tests {
    @Test("Day 10 Part 1", .tags(.testInput))
    func testDay10_part1() async {
        let day = Day10(input: testInput)
        // Machine 1: 2 presses, Machine 2: 3 presses, Machine 3: 2 presses
        // Total: 2 + 3 + 2 = 7
        await #expect(day.part1() == 7)
    }

    @Test("Day 10 Part 1 Solution")
    func testDay10_part1_solution() async {
        let day = Day10(input: Day10.input)
        await #expect(day.part1() == 409)
    }

    @Test("Day 10 Part 2", .tags(.testInput))
    func testDay10_part2() async {
        let day = Day10(input: testInput)
        // Machine 1: 10 presses, Machine 2: 12 presses, Machine 3: 11 presses
        // Total: 10 + 12 + 11 = 33
        await #expect(day.part2() == 33)
    }

    @Test("Day 10 Part 2 Solution")
    func testDay10_part2_solution() async {
        let day = Day10(input: Day10.input)
        await #expect(day.part2() == 15489)
    }
}

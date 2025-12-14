//
//  Day03Tests.swift
//  AdventOfCode
//
//  Created by Jeff E. Schmitz on 11/16/25.
//

import Testing
@testable import TwelveDaysOfCode

fileprivate let testInput = """
13579
97531
"""

@Suite("Day 3 Tests")
struct Day03Tests {
    @Test("Day 3 Part 1", .tags(.testInput))
    func testDay03_part1() async {
        let day = Day03(input: testInput)
        // Bank [1,3,5,7,9]: max joltage = 79 (7 as tens, 9 as ones)
        // Bank [9,7,5,3,1]: max joltage = 97 (9 as tens, 7 as ones after)
        // Total: 79 + 97 = 176
        await #expect(day.part1() == 176)
    }

    @Test("Day 3 Part 1 Solution")
    func testDay03_part1_solution() async {
        let day = Day03(input: Day03.input)
        await #expect(day.part1() == 17613)
    }

    @Test("Day 3 Part 2", .tags(.testInput))
    func testDay03_part2() async {
        let day = Day03(input: testInput)
        // Banks have only 5 digits each (< 12), so all digits kept
        // 13579 + 97531 = 111110
        await #expect(day.part2() == 111110)
    }

    @Test("Day 3 Part 2 Solution")
    func testDay03_part2_solution() async {
        let day = Day03(input: Day03.input)
        await #expect(day.part2() == 175304218462560)
    }
}

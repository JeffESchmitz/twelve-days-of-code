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
11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
"""

@Suite("Day 2 Tests")
struct Day02Tests {
    @Test("Day 2 Part 1", .tags(.testInput))
    func testDay02_part1() async {
        let day = Day02(input: testInput)
        await #expect(day.part1() == 1227775554)
    }

    @Test("Day 2 Part 1 Solution")
    func testDay02_part1_solution() async {
        let day = Day02(input: Day02.input)
        await #expect(day.part1() == 24043483400)
    }

    @Test("Day 2 Part 2", .tags(.testInput))
    func testDay02_part2() async {
        let day = Day02(input: testInput)
        await #expect(day.part2() == 4174379265)
    }

    @Test("Day 2 Part 2 Solution")
    func testDay02_part2_solution() async {
        let day = Day02(input: Day02.input)
        await #expect(day.part2() == 38262920235)
    }
}

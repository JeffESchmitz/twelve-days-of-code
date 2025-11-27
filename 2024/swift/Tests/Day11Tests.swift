//
// Advent of Code 2024 Day 11 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
125 17
"""

@Suite("Day 11 Tests")
struct Day11Tests {
    @MainActor @Test("Day 11 Part 1")
    func testDay11_part1() async {
        let day = Day11(input: testInput)
        #expect(await day.part1() == 55312)
    }

    @MainActor @Test("Day 11 Part 1 Solution")
    func testDay11_part1_solution() async {
        let day = Day11(input: Day11.input)
        #expect(await day.part1() == 193607)
    }

    @MainActor @Test("Day 11 Part 2")
    func testDay11_part2() async {
        let day = Day11(input: testInput)
        #expect(await day.part2() == 65601038650482)
    }

    @MainActor @Test("Day 11 Part 2 Solution")
    func testDay11_part2_solution() async {
        let day = Day11(input: Day11.input)
        #expect(await day.part2() == 229557103025807)
    }
}

//
// Advent of Code 2024 Day 24 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
"""

@Suite("Day 24 Tests")
struct Day24Tests {
    @MainActor @Test("Day 24 Part 1", .disabled())
    func testDay24_part1() async {
        let day = Day24(input: testInput)
        #expect(await day.part1() == -1)
    }

    @MainActor @Test("Day 24 Part 1 Solution", .disabled())
    func testDay24_part1_solution() async {
        let day = Day24(input: Day24.input)
        #expect(await day.part1() == -1)
    }

    @MainActor @Test("Day 24 Part 2", .disabled())
    func testDay24_part2() async {
        let day = Day24(input: testInput)
        #expect(await day.part2() == -1)
    }

    @MainActor @Test("Day 24 Part 2 Solution", .disabled())
    func testDay24_part2_solution() async {
        let day = Day24(input: Day24.input)
        #expect(await day.part2() == -1)
    }
}

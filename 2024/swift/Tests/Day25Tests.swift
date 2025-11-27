//
// Advent of Code 2024 Day 25 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
"""

@Suite("Day 25 Tests")
struct Day25Tests {
    @MainActor @Test("Day 25 Part 1", .disabled())
    func testDay25_part1() async {
        let day = Day25(input: testInput)
        #expect(await day.part1() == -1)
    }

    @MainActor @Test("Day 25 Part 1 Solution", .disabled())
    func testDay25_part1_solution() async {
        let day = Day25(input: Day25.input)
        #expect(await day.part1() == -1)
    }
}

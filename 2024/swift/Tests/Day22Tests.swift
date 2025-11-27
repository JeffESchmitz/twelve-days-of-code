//
// Advent of Code 2024 Day 22 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
1
10
100
2024
"""

@Suite("Day 22 Tests")
struct Day22Tests {
    @MainActor @Test("Day 22 Part 1")
    func testDay22_part1() async {
        let day = Day22(input: testInput)
        #expect(await day.part1() == 37_327_623)
    }

    @MainActor @Test("Day 22 Part 1 Solution")
    func testDay22_part1_solution() async {
        let day = Day22(input: Day22.input)
        #expect(await day.part1() == 18_941_802_053)
    }

    @MainActor @Test("Day 22 Part 2")
    func testDay22_part2() async {
        let day = Day22(input: testInput)
        let result = await day.part2()
        #expect(result == 24)
    }

    @MainActor @Test("Day 22 Part 2 Solution")
    func testDay22_part2_solution() async {
        let day = Day22(input: Day22.input)
        let result = await day.part2()
        #expect(result == 2218)
    }
}

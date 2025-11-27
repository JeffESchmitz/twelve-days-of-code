//
// Advent of Code 2024 Day 9 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
2333133121414131402
"""

@Suite("Day 9 Tests")
struct Day09Tests {
    @MainActor @Test("Day 9 Part 1")
    func testDay09_part1() async {
        let day = Day09(input: testInput)
        #expect(await day.part1() == 1928)
    }

    @MainActor @Test("Day 9 Part 1 Solution")
    func testDay09_part1_solution() async {
        let day = Day09(input: Day09.input)
        #expect(await day.part1() == 6421128769094)
    }

    @MainActor @Test("Day 9 Part 2")
    func testDay09_part2() async {
        let day = Day09(input: testInput)
        #expect(await day.part2() == 2858)
    }

    @MainActor @Test("Day 9 Part 2 Solution")
    func testDay09_part2_solution() async {
        let day = Day09(input: Day09.input)
        #expect(await day.part2() == 6448168620520)
    }
}

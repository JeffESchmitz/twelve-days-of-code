//
// Advent of Code 2024 Day 20 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############
"""

@Suite("Day 20 Tests")
struct Day20Tests {
    @MainActor @Test("Day 20 Part 1")
    func testDay20_part1() async {
        let day = Day20(input: testInput)
        #expect(await day.part1() == 0)  // Example: no cheats save >= 100ps
    }

    @MainActor @Test("Day 20 Part 1 Solution")
    func testDay20_part1_solution() async {
        let day = Day20(input: Day20.input)
        #expect(await day.part1() == 1323)
    }

    @MainActor @Test("Day 20 Part 2")
    func testDay20_part2() async {
        let day = Day20(input: testInput)
        #expect(await day.part2() == 0)  // Example: no cheats with 20-step max save >= 100ps
    }

    @MainActor @Test("Day 20 Part 2 Solution")
    func testDay20_part2_solution() async {
        let day = Day20(input: Day20.input)
        #expect(await day.part2() == 983905)
    }
}

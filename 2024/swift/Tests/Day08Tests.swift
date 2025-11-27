//
// Advent of Code 2024 Day 8 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
"""


@Suite("Day 8 Tests")
struct Day08Tests {
    @MainActor @Test("Day 8 Part 1")
    func testDay08_part1() async {
        let day = Day08(input: testInput)

        #expect(await day.part1() == 14)
    }

    @MainActor @Test("Day 8 Part 1 Solution")
    func testDay08_part1_solution() async {
        let day = Day08(input: Day08.input)
        #expect(await day.part1() == 313)
    }

    @MainActor @Test("Day 8 Part 2")
    func testDay08_part2() async {
        let day = Day08(input: testInput)
        #expect(await day.part2() == 34)
    }

    @MainActor @Test("Day 8 Part 2 Solution")
    func testDay08_part2_solution() async {
        let day = Day08(input: Day08.input)
        #expect(await day.part2() == 1064)
    }
}

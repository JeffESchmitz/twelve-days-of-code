//
// Advent of Code 2024 Day 4 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"""

fileprivate let testInput2 = """
.M.S......
..A..MSMS.
.M.S.MAA..
..A.ASMSM.
.M.S.M....
..........
S.S.S.S.S.
.A.A.A.A..
M.M.M.M.M.
..........
"""


@Suite("Day 4 Tests")
@MainActor
struct Day04Tests {
    @Test("Day 4 Part 1")
    func testDay04_part1() async {
        let day = Day04(input: testInput)
        #expect(await day.part1() == 18)
    }

     @Test("Day 4 Part 1 Solution")
    func testDay04_part1_solution() async {
        let day = Day04(input: Day04.input)
        #expect(await day.part1() == 2434)
    }

     @Test("Day 4 Part 2")
    func testDay04_part2() async {
        let day = Day04(input: testInput2)
        #expect(await day.part2() == 9)
    }

     @Test("Day 4 Part 2 Solution")
    func testDay04_part2_solution() async {
        let day = Day04(input: Day04.input)
        #expect(await day.part2() == 1835)
    }
}

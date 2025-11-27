//
// Advent of Code 2024 Day 21 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
029A
980A
179A
456A
379A
"""

@Suite("Day 21 Tests")
struct Day21Tests {
    @MainActor @Test("Day 21 Part 1 Example")
    func testDay21_part1() async {
        let day = Day21(input: testInput)
        #expect(await day.part1() == 126384)
    }

    @MainActor @Test("Day 21 Part 1 Solution")
    func testDay21_part1_solution() async {
        let day = Day21(input: Day21.input)
        let result = await day.part1()
        #expect(result == 242484)
    }

    @MainActor @Test("Day 21 Part 2 Example")
    func testDay21_part2() async {
        let day = Day21(input: testInput)
        let result = await day.part2()
        // Example with 25 robots (depth=25)
        // 029A: 2,379,451,789,590
        // 980A: 70,797,185,862,200
        // 179A: 14,543,936,021,812
        // 456A: 36,838,581,189,648
        // 379A: 29,556,553,253,044
        #expect(result == 154115708116294)
    }

    @MainActor @Test("Day 21 Part 2 Solution")
    func testDay21_part2_solution() async {
        let day = Day21(input: Day21.input)
        let result = await day.part2()
        // Solution with 25 robots (depth=25)
        #expect(result == 294209504640384)
    }
}

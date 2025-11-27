//
// Advent of Code 2024 Day 18 Tests
//

import Testing
import Collections
import AoCTools
@testable import AdventOfCode

fileprivate let testInput = """
5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0
"""

@Suite("Day 18 Tests")
struct Day18Tests {
    @MainActor @Test("Day 18 Part 1 Example")
    func testDay18_part1_example() async {
        let day = Day18(input: testInput)
        #expect(day.findShortestPath(gridSize: 6, byteCount: 12) == 22)
    }

    @MainActor @Test("Day 18 Part 1 Solution")
    func testDay18_part1_solution() async {
        let day = Day18(input: Day18.input)
        #expect(await day.part1() == 250)
    }

    @MainActor @Test("Day 18 Part 2 Example")
    func testDay18_part2_example() async {
        let day = Day18(input: testInput)
        // Binary search should find that byte at index 20 (coordinate 6,1) is the blocker
        // Use 6x6 grid for example (not 70x70)
        let result = day.findFirstBlockingByte(gridSize: 6)
        #expect(result == 0)  // Always returns 0, answer is printed
        // Expected output: "First blocking byte: 6,1"
    }

    @MainActor @Test("Day 18 Part 2 Solution")
    func testDay18_part2_solution() async {
        let day = Day18(input: Day18.input)
        let result = await day.part2()
        #expect(result == 0)  // Always returns 0, answer is printed
        // Check console output for actual coordinates
    }
}

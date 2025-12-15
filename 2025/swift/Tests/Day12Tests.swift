//
// Twelve Days of Code 2025 Day 12 Tests
//

import Testing
@testable import TwelveDaysOfCode

fileprivate let testInput = """
0:
###
##.
##.

1:
###
##.
.##

2:
.##
###
##.

3:
##.
###
##.

4:
###
#..
###

5:
###
.#.
###

4x4: 0 0 0 0 2 0
12x5: 1 0 1 0 2 2
12x5: 1 0 1 0 3 2
"""

@Suite("Day 12 Tests")
struct Day12Tests {
    @Test("Day 12 Part 1 Example", .tags(.testInput))
    func testDay12_part1() async {
        let day = Day12(input: testInput)
        #expect(await day.part1() == 2)
    }

    @Test("Day 12 Part 1 Solution")
    func testDay12_part1_solution() async {
        let day = Day12(input: Day12.input)
        let result = await day.part1()
        print("Day 12 Part 1: \(result)")
        #expect(result > 0)
    }

    // Day 12 has no Part 2 puzzle - just story/flavor text celebrating completion
}

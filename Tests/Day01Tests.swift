//
// Twelve Days of Code 2025 Day 1 Tests
//
//  Created by Jeff E. Schmitz on 12/01/25.
//

import Testing
@testable import TwelveDaysOfCode

fileprivate let testInput = """
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
"""

@Suite("Day 1 Tests")
struct Day01Tests {
    @Test("Day 1 Part 1", .tags(.testInput))
    func testDay01_part1() async {
        let day = Day01(input: testInput)
        await #expect(day.part1() == 3)
    }

    @Test("Day 1 Part 1 Solution")
    func testDay01_part1_solution() async {
        let day = Day01(input: Day01.input)
        await #expect(day.part1() == 1145)
    }

    @Test("Day 1 Part 2", .tags(.testInput))
    func testDay01_part2() async {
        let day = Day01(input: testInput)
        await #expect(day.part2() == 6)
    }

    @Test("Day 1 Part 2 Solution")
    func testDay01_part2_solution() async {
        let day = Day01(input: Day01.input)
        await #expect(day.part2() == 6561)
    }
}

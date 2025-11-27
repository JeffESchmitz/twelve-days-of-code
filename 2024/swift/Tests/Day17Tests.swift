//
// Advent of Code 2024 Day 17 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0
"""

@Suite("Day 17 Tests")
struct Day17Tests {
    @MainActor @Test("Day 17 Part 1")
    func testDay17_part1() async {
        let day = Day17(input: testInput)
        var computer = day.parseInput()
        computer.run()
        // Expected output: 4,6,3,5,6,3,5,2,1,0
        #expect(computer.outputString() == "4,6,3,5,6,3,5,2,1,0")
    }

    @MainActor @Test("Day 17 Part 1 Solution", .disabled())
    func testDay17_part1_solution() async {
        let day = Day17(input: Day17.input)
        // We'll need to check the actual output manually
        await day.part1()
        // Placeholder - will need actual expected value
        #expect(true)
    }

    @MainActor @Test("Day 17 Part 2")
    func testDay17_part2() async {
        // Example from problem: program 0,3,5,4,3,0 should have A=117440
        let exampleInput = """
        Register A: 2024
        Register B: 0
        Register C: 0

        Program: 0,3,5,4,3,0
        """
        let day = Day17(input: exampleInput)
        #expect(await day.part2() == 117440)
    }

    @MainActor @Test("Day 17 Part 2 Solution", .disabled())
    func testDay17_part2_solution() async {
        let day = Day17(input: Day17.input)
        #expect(await day.part2() == -1)
    }
}

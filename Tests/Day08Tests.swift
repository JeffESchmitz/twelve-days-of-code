//
//  Day08Tests.swift
//  AdventOfCode
//
// Twelve Days of Code 2025 Day 8 Tests
//

import Testing
@testable import TwelveDaysOfCode

private let testInput = """
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689
"""

@Suite("Day 8 Tests")
struct Day08Tests {
    @Test("Day 8 Part 1", .tags(.testInput))
    func testDay08_part1() async {
        let day = Day08(input: testInput)
        // 20 boxes, process up to 1000 pairs (only 190 exist)
        // All boxes end up in one circuit of size 20
        // Top 3 sizes: [20, 0, 0] but we only have 1 circuit
        await #expect(day.part1() == 20)  // 20 * 1 * 1 (only 1 circuit exists)
    }

    @Test("Day 8 Part 1 Solution")
    func testDay08_part1_solution() async {
        let day = Day08(input: Day08.input)
        await #expect(day.part1() == 54600)
    }

    @Test("Day 8 Part 2", .tags(.testInput))
    func testDay08_part2() async {
        let day = Day08(input: testInput)
        // Last merge: 216,146,977 <-> 117,168,530 → 216 * 117 = 25272
        await #expect(day.part2() == 25272)
    }

    @Test("Day 8 Part 2 Solution")
    func testDay08_part2_solution() async {
        let day = Day08(input: Day08.input)
        await #expect(day.part2() == 107256172)
    }
}

//
// Advent of Code 2024 Day 2 Tests
//

import Testing
@testable import AdventOfCode

fileprivate let testInput = """
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"""

@Suite("Day 2 Tests")
@MainActor
struct Day02Tests {
    @Test("Day 2 Part 1")
    func testDay02_part1() async {
        let day = Day02(input: testInput)
        #expect(await day.part1() == 2)
    }

    @Test("Single-Level Report")
    func testSingleLevel() {
        let day = Day02(input: testInput)
        let report = Report(levels: [1])
        let foo = day.isSafeReport(report: report)
        #expect(foo == true)
    }

    @Test("Repeated Values")
    func testRepeatedValues() {
        let day = Day02(input: testInput)
        let report = Report(levels: [1, 1, 1])
        let result = day.isSafeReport(report: report)
        #expect(result == false)
    }

    @Test("Mixed Trends")
    func testMixedTrends() {
        let day = Day02(input: testInput)
        let report = Report(levels: [1, 2, 3, 2, 3])
        let result = day.isSafeReport(report: report)
        #expect(result == false)
    }

    @Test("Boundary Differences")
    func testBoundaryDifferences() {
        let day = Day02(input: testInput)
        let report = Report(levels: [1, 2, 3, 6, 9])
        let result = day.isSafeReport(report: report)
        #expect(result == true)
    }

    @Test("Empty Report", .disabled())
    func testEmptyReport() {
        let day = Day02(input: testInput)
        let report = Report(levels: [])
        let result = day.isSafeReport(report: report)
        #expect(result == true)
    }

    @Test("Day 2 Part 1 Solution")
    func testDay02_part1_solution() async {
        let day = Day02(input: Day02.input)
        #expect(await day.part1() == 663)
    }

    @Test("Day 2 Part 2")
    func testDay02_part2() async {
        let day = Day02(input: testInput)
        #expect(await day.part2() == 4)
    }

    @Test("Day 2 Part 2 Solution")
    func testDay02_part2_solution() async {
        let day = Day02(input: Day02.input)
        #expect(await day.part2() == 692)
    }
}

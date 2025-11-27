//
// Advent of Code 2024 Day 2
//
// https://adventofcode.com/2024/day/2
//

import AoCTools
import Parsing

struct Report: Equatable {
    let levels: [Int]
}

struct ReportParser: Parser {
    var body: some Parser<Substring, Report> {
        Parse(Report.init(levels:)) {
            Many {
                Int.parser()
            } separator: {
                Whitespace()
            }
        }
    }
}

final class Day02: AdventOfCodeDay {
    let title = "Red-Nosed Reactor"
    let input: String
    
    
    init(input: String) {
        self.input = input
    }
    
    func part1() async -> Int {
        let reports = parseInput()
        let filtered = reports.filter { report in
            isSafeReport(report: report)
        }
        return filtered.count
    }
    
    func part2() async -> Int {
        let reports = parseInput()
        let safeReports = reports.filter { report in
            isSafeReport(report: report) || isSafeReportWithRemoval_v2(report: report)
        }
        return safeReports.count
    }
    
    func parseInput() -> [Report] {
        let reportParser = ReportParser()
        
        return input
            .split(separator: "\n")
            .compactMap { line in
                try? reportParser.parse(line[...]) // Automatically handle errors
            }
    }
    
    func isSafeReport(report: Report) -> Bool {
        let differences = zip(report.levels, report.levels.dropFirst()).map { $1 - $0 }
        
        let areDifferencesValid = differences.allSatisfy { abs($0) >= 1 && abs($0) <= 3 }

        let isIncreasing = differences.allSatisfy { $0 > 0 }
        let isDecreasing = differences.allSatisfy { $0 < 0 }

        return areDifferencesValid && (isIncreasing || isDecreasing)
    }

    func isSafeReportWithRemoval_v2(report: Report) -> Bool {
        // If the report is already safe, return true
        if isSafeReport(report: report) {
            return true
        }

        // Check if removing any level makes the report safe
        return report.levels.enumerated().contains { index, _ in
            let reducedLevels = report
                .levels
                .enumerated()
                .filter { $0.offset != index } // Remove the current level
                .map { $0.element } // Extract the level values
            return isSafeReport(report: Report(levels: reducedLevels))
        }
    }
}

//import Testing
//@testable import AdventOfCode
//
//fileprivate let testInput = """
//7 6 4 2 1
//1 2 7 8 9
//9 7 6 2 1
//1 3 2 4 5
//8 6 4 4 1
//1 3 6 7 9
//"""
//
//@Suite("Day 2 Tests")
//@MainActor
//struct Day02Tests {
//    @Test("Day 2 Part 1")
//    func testDay02_part1() {
//        let day = Day02(input: testInput)
//        #expect(await day.part1() == 2)
//    }
//
//    @Test("Single-Level Report")
//    func testSingleLevel() {
//        let day = Day02(input: testInput)
//        let report = Report(levels: [1])
//        let foo = day.isSafeReport(report: report)
//        #expect(foo == true)
//    }
//
//    @Test("Repeated Values")
//    func testRepeatedValues() {
//        let day = Day02(input: testInput)
//        let report = Report(levels: [1, 1, 1])
//        let result = day.isSafeReport(report: report)
//        #expect(result == false)
//    }
//
//    @Test("Mixed Trends")
//    func testMixedTrends() {
//        let day = Day02(input: testInput)
//        let report = Report(levels: [1, 2, 3, 2, 3])
//        let result = day.isSafeReport(report: report)
//        #expect(result == false)
//    }
//
//    @Test("Boundary Differences")
//    func testBoundaryDifferences() {
//        let day = Day02(input: testInput)
//        let report = Report(levels: [1, 2, 3, 6, 9])
//        let result = day.isSafeReport(report: report)
//        #expect(result == true)
//    }
//
//    @Test("Empty Report")
//    func testEmptyReport() {
//        let day = Day02(input: testInput)
//        let report = Report(levels: [])
//        let result = day.isSafeReport(report: report)
//        #expect(result == true)
//    }
//
//    @Test("Day 2 Part 1 Solution")
//    func testDay02_part1_solution() {
//        let day = Day02(input: Day02.input)
//        #expect(await day.part1() == 663)
//    }
//
//    @Test("Day 2 Part 2")
//    func testDay02_part2() {
//        let day = Day02(input: testInput)
//        #expect(await day.part2() == 4)
//    }
//
//    @Test("Day 2 Part 2 Solution")
//    func testDay02_part2_solution() {
//        let day = Day02(input: Day02.input)
//        #expect(await day.part2() == 692)
//    }
//}

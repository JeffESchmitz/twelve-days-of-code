#!/bin/bash
# Script to create template files for a new TDOC day

if [ -z "$1" ]; then
    echo "Usage: ./new_day.sh <day_number>"
    echo "Example: ./new_day.sh 5"
    exit 1
fi

DAY=$1
DAY_PADDED=$(printf "%02d" $DAY)
YEAR=$(date +%Y)

# Create Day source file
cat > "Sources/Day${DAY_PADDED}.swift" << EOF
//
// Twelve Days of Code ${YEAR} Day ${DAY}
//
// https://adventofcode.com/${YEAR}/day/${DAY}
//

import AoCTools

final class Day${DAY_PADDED}: AdventOfCodeDay {
    let title = "Day ${DAY}"

    init(input: String) {
        // Parse input here
    }

    func part1() async -> Int {
        return -1
    }

    func part2() async -> Int {
        return -1
    }
}
EOF

# Create Day input file
cat > "Sources/Day${DAY_PADDED}+Input.swift" << EOF
//
// Twelve Days of Code ${YEAR} Day ${DAY} - Input
//

extension Day${DAY_PADDED} {
    static let input = """
"""
}
EOF

# Create Day test file
cat > "Tests/Day${DAY_PADDED}Tests.swift" << EOF
//
// Twelve Days of Code ${YEAR} Day ${DAY} Tests
//

import Testing
@testable import TwelveDaysOfCode

fileprivate let testInput = """
"""

@Suite("Day ${DAY} Tests")
struct Day${DAY_PADDED}Tests {
    @Test("Day ${DAY} Part 1", .tags(.testInput))
    func testDay${DAY_PADDED}_part1() async {
        let day = Day${DAY_PADDED}(input: testInput)
        await #expect(day.part1() == 0)
    }

    @Test("Day ${DAY} Part 1 Solution")
    func testDay${DAY_PADDED}_part1_solution() async {
        let day = Day${DAY_PADDED}(input: Day${DAY_PADDED}.input)
        await #expect(day.part1() == 0)
    }

    @Test("Day ${DAY} Part 2", .tags(.testInput))
    func testDay${DAY_PADDED}_part2() async {
        let day = Day${DAY_PADDED}(input: testInput)
        await #expect(day.part2() == 0)
    }

    @Test("Day ${DAY} Part 2 Solution")
    func testDay${DAY_PADDED}_part2_solution() async {
        let day = Day${DAY_PADDED}(input: Day${DAY_PADDED}.input)
        await #expect(day.part2() == 0)
    }
}
EOF

echo "✅ Created files for Day ${DAY}:"
echo "   - Sources/Day${DAY_PADDED}.swift"
echo "   - Sources/Day${DAY_PADDED}+Input.swift"
echo "   - Tests/Day${DAY_PADDED}Tests.swift"
echo ""
echo "Next steps:"
echo "1. Add your puzzle input to Day${DAY_PADDED}+Input.swift"
echo "2. Update the title in Day${DAY_PADDED}.swift"
echo "3. Add test input to Day${DAY_PADDED}Tests.swift"
echo "4. Implement your solution!"

//
// Twelve Days of Code 2025 Day 11 Tests
//

import Testing
@testable import TwelveDaysOfCode

fileprivate let testInput = """
aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out
"""

fileprivate let testInput2 = """
svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out
"""

@Suite("Day 11 Tests")
struct Day11Tests {
    @Test("Day 11 Part 1 Example", .tags(.testInput))
    func testDay11_part1() async {
        let day = Day11(input: testInput)
        await #expect(day.part1() == 5)
    }

    @Test("Day 11 Part 1 Solution")
    func testDay11_part1_solution() async {
        let day = Day11(input: Day11.input)
        let result = await day.part1()
        print("Day 11 Part 1 result: \(result)")
        await #expect(result > 0)
    }

    @Test("Day 11 Part 2 Example", .tags(.testInput))
    func testDay11_part2() async {
        let day = Day11(input: testInput2)
        await #expect(day.part2() == 2)
    }

    @Test("Day 11 Part 2 Solution")
    func testDay11_part2_solution() async {
        let day = Day11(input: Day11.input)
        let result = await day.part2()
        print("Day 11 Part 2 result: \(result)")
        await #expect(result > 0)
    }
}

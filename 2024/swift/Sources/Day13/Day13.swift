//
// Advent of Code 2024 Day 13
//
// https://adventofcode.com/2024/day/13
//

import AoCTools

struct Machine {
    let buttonA: Point
    let buttonB: Point
    let prize: Point
}

final class Day13: AdventOfCodeDay {
    let title = "Claw Contraption"
    let machines: [Machine]
    
    init(input: String) {
        // Split input into groups of non-empty lines
        let groups = input.lines.grouped(by: \.isEmpty)

        // Parse each group into a Machine instance
        machines = groups.compactMap { group in
            guard group.count == 3 else {
                fatalError("Unexpected group size: \(group.count). Expected 3 lines per group.")
            }

            // Extract integers from each line
            let btnA = group[0].integers()
            let btnB = group[1].integers()
            let prize = group[2].integers()

            // Ensure proper structure
            guard btnA.count == 2, btnB.count == 2, prize.count == 2 else {
                fatalError("Invalid line format in group: \(group)")
            }

            // Create a Machine instance
            return Machine(
                buttonA: Point(btnA[0], btnA[1]),
                buttonB: Point(btnB[0], btnB[1]),
                prize: Point(prize[0], prize[1])
            )
        }
    }

    func part1() async -> Int {
        return machines
            .compactMap { solveMachine($0) }
            .reduce(0, +)

    }

    func part2() async -> Int {
        let offset = 10_000_000_000_000
        return machines
            .compactMap {
                solveMachine($0, offset: offset)
            }
            .reduce(0, +)
    }
}

extension Day13 {
    func solveMachine(
        _ machine: Machine,
        offset: Int = 0
    ) -> Int? {
        let prize = machine.prize + Point(offset, offset)

        // Solve the system of equations
        guard let (a, b) = solveDiophantine(
            a1: machine.buttonA.x, b1: machine.buttonB.x, c1: prize.x,
            a2: machine.buttonA.y, b2: machine.buttonB.y, c2: prize.y
        ) else {
            return nil
        }

        // Return the token cost
        return 3 * a + b
    }

    func solveDiophantine(
        a1: Int, b1: Int, c1: Int,
        a2: Int, b2: Int, c2: Int
    ) -> (Int, Int)? {
        let det = a1 * b2 - a2 * b1
        
        // No unique solution
        guard det != 0 else { return nil }

        // Solve using Cramer's rule
        let x = (c1 * b2 - c2 * b1) / det
        let y = (a1 * c2 - a2 * c1) / det

        // Validate solution
        if a1 * x + b1 * y == c1 && a2 * x + b2 * y == c2 {
            return (x, y)
        } else {
            return nil
        }
    }
}

//
// Advent of Code 2024 Day 17
//
// https://adventofcode.com/2024/day/17
//

import AoCTools
import Foundation
import Collections

struct Computer {
    var registerA: Int
    var registerB: Int
    var registerC: Int
    var program: [Int]
    var instructionPointer: Int = 0
    var output: [Int] = []

    mutating func run() {
        while instructionPointer < program.count - 1 {
            let opcode = program[instructionPointer]
            let operand = program[instructionPointer + 1]

            switch opcode {
            case 0: adv(operand)
            case 1: bxl(operand)
            case 2: bst(operand)
            case 3: jnz(operand)
            case 4: bxc(operand)
            case 5: out(operand)
            case 6: bdv(operand)
            case 7: cdv(operand)
            default: break
            }

            // Only increment if we didn't jump
            if opcode != 3 || registerA == 0 {
                instructionPointer += 2
            }
        }
    }

    // Get combo operand value
    func comboValue(_ operand: Int) -> Int {
        switch operand {
        case 0...3: return operand
        case 4: return registerA
        case 5: return registerB
        case 6: return registerC
        default: return 0 // Invalid
        }
    }

    // Opcode 0: adv - divide A by 2^combo, store in A
    mutating func adv(_ operand: Int) {
        let denominator = 1 << comboValue(operand) // 2^combo
        registerA = registerA / denominator
    }

    // Opcode 1: bxl - B XOR literal
    mutating func bxl(_ operand: Int) {
        registerB = registerB ^ operand
    }

    // Opcode 2: bst - combo % 8 -> B
    mutating func bst(_ operand: Int) {
        registerB = comboValue(operand) % 8
    }

    // Opcode 3: jnz - jump if A != 0
    mutating func jnz(_ operand: Int) {
        if registerA != 0 {
            instructionPointer = operand
        }
        // Note: If we don't jump, the main loop will increment by 2
    }

    // Opcode 4: bxc - B XOR C -> B (operand ignored)
    mutating func bxc(_ operand: Int) {
        registerB = registerB ^ registerC
    }

    // Opcode 5: out - output combo % 8
    mutating func out(_ operand: Int) {
        output.append(comboValue(operand) % 8)
    }

    // Opcode 6: bdv - like adv but store in B
    mutating func bdv(_ operand: Int) {
        let denominator = 1 << comboValue(operand)
        registerB = registerA / denominator
    }

    // Opcode 7: cdv - like adv but store in C
    mutating func cdv(_ operand: Int) {
        let denominator = 1 << comboValue(operand)
        registerC = registerA / denominator
    }

    func outputString() -> String {
        output.map(String.init).joined(separator: ",")
    }
}

final class Day17: AdventOfCodeDay {
    let title = "Chronospatial Computer"
    let input: String

    init(input: String) {
        self.input = input
    }

    func parseInput() -> Computer {
        let lines = input.split(separator: "\n").map(String.init)

        let registerA = Int(lines[0].split(separator: ": ")[1])!
        let registerB = Int(lines[1].split(separator: ": ")[1])!
        let registerC = Int(lines[2].split(separator: ": ")[1])!

        // split() skips empty lines, so Program is at index 3, not 4
        let programLine = lines[3].split(separator: ": ")[1]
        let program = programLine.split(separator: ",").compactMap { Int($0) }

        return Computer(
            registerA: registerA,
            registerB: registerB,
            registerC: registerC,
            program: program
        )
    }

    func part1() async -> Int {
        var computer = parseInput()
        computer.run()

        // The problem wants a string output, but we return Int
        // For now, just return the first output value as a placeholder
        // The real answer is: computer.outputString()
        print("Part 1 output: \(computer.outputString())")
        return computer.output.first ?? 0
    }

    func part2() async -> Int {
        let computer = parseInput()
        let target = computer.program

        // Use BFS to find the smallest A that produces the target output
        // Work backwards: start with A values that produce the last output,
        // then extend to produce the last 2 outputs, etc.
        var queue = Deque<Int>()
        queue.append(0)

        // Work backwards through the target outputs
        for outputIndex in (0..<target.count).reversed() {
            var nextQueue = Deque<Int>()

            while let currentA = queue.popFirst() {
                // Try all possible 3-bit values to prepend to currentA
                for bits in 0..<8 {
                    let candidateA = (currentA << 3) | bits

                    if candidateA == 0 {
                        continue
                    }

                    // Test if this A produces the expected suffix of outputs
                    var testComputer = Computer(registerA: candidateA, registerB: 0, registerC: 0, program: computer.program)
                    testComputer.run()

                    // Check if output matches the suffix of target starting at outputIndex
                    let expectedSuffix = Array(target.suffix(from: outputIndex))
                    if testComputer.output == expectedSuffix {
                        nextQueue.append(candidateA)
                    }
                }
            }

            queue = nextQueue
        }

        // Return the smallest valid A
        return queue.min() ?? -1
    }
}

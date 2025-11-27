//
// Advent of Code 2024 Day 3
//
// https://adventofcode.com/2024/day/3
//

import AoCTools
import Parsing
import Foundation
import RegexBuilder

final class Day03: AdventOfCodeDay {
    let title = "Mull It Over"
    
    let input: String
    let lines: [String]
    
    init(input: String) {
        
        self.input = input
        self.lines = input.lines
    }

    func part1() async -> Int {
        calculateMulSum(from: lines)
    }

    func part2() async -> Int {
        calculateMulSumWithConditions(from: input)
    }

    // - MARK: Day 3 functions -

    func calculateMulSum(from inputLines: [String]) -> Int {

        // This regex matches the pattern "mul(X,Y)" where X and Y are one or more digits
        let mulRegex = Regex {
            "mul("                     // Match the literal string "mul("
            Capture {
                OneOrMore(.digit)      // Capture X: one or more digit characters
            }
            ","                        // Match the literal comma
            Capture {
                OneOrMore(.digit)      // Capture Y: one or more digit characters
            }
            ")"                        // Match the literal closing parenthesis
        }

        // Find all matches and compute the sum of valid products
        return inputLines
            .flatMap { line in  // Flatten the array of matches across all lines
                line.matches(of: mulRegex)
            }
            .compactMap { match -> Int? in  // Process each match to compute the product of X and Y
                guard let x = Int(match.output.1), let y = Int(match.output.2) else {
                    return nil  // Exclude invalid matches
                }
                print("\(x) * \(y) = \(x * y)")
                return x * y
            }
            .reduce(0, +)  // Sum all the computed products
    }

    func calculateMulSumWithConditions(from memory: String) -> Int {
        // Regular expressions for all patterns
        let mulPattern = #"mul\((\d{1,3}),(\d{1,3})\)"#
        let doPattern = #"do\(\)"#
        let dontPattern = #"don't\(\)"#
        let combinedPattern = "\(mulPattern)|\(doPattern)|\(dontPattern)"

        var total = 0
        var enabled = true  // Multiplications start enabled

        do {
            // Create a combined regex
            let regex = try NSRegularExpression(pattern: combinedPattern)

            // Find all matches in the memory
            let matches = regex.matches(in: memory, range: NSRange(memory.startIndex..., in: memory))

            // Process matches in order of appearance
            for match in matches {
                // Handle `don't()` matches
                if let dontRange = Range(match.range(at: 0), in: memory), memory[dontRange] == "don't()" {
                    enabled = false
                }
                // Handle `do()` matches
                else if let doRange = Range(match.range(at: 0), in: memory), memory[doRange] == "do()" {
                    enabled = true
                }
                // Handle `mul(X,Y)` matches
                else if let xRange = Range(match.range(at: 1), in: memory),
                        let yRange = Range(match.range(at: 2), in: memory),
                        enabled {
                    let x = Int(memory[xRange]) ?? 0
                    let y = Int(memory[yRange]) ?? 0
                    total += x * y
                }
            }
        } catch {
            print("Invalid regular expression: \(error)")
        }

        return total
    }
}


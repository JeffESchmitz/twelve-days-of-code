//
// Twelve Days of Code 2025 Day 10
//
// https://adventofcode.com/2025/day/10
//

import AoCTools
import Collections
import Foundation

final class Day10: AdventOfCodeDay {
    let title = "Factory"

    struct Machine {
        let pattern: [Bool]       // Target light states (true = on)
        let buttons: [Set<Int>]   // Each button toggles these light indices
        let joltages: [Int]       // Saved for Part 2
    }

    let machines: [Machine]

    init(input: String) {
        self.machines = input.lines.compactMap { line -> Machine? in
            guard let patternStart = line.firstIndex(of: "["),
                  let patternEnd = line.firstIndex(of: "]") else { return nil }
            let patternStr = String(line[line.index(after: patternStart)..<patternEnd])
            let pattern = patternStr.map { $0 == "#" }

            var buttons: [Set<Int>] = []
            var searchStart = line.startIndex
            while let openParen = line[searchStart...].firstIndex(of: "("),
                  let closeParen = line[openParen...].firstIndex(of: ")") {
                let buttonStr = String(line[line.index(after: openParen)..<closeParen])
                let indices = buttonStr.split(separator: ",").compactMap { Int($0) }
                buttons.append(Set(indices))
                searchStart = line.index(after: closeParen)
            }

            let joltages: [Int] = {
                guard let openBrace = line.firstIndex(of: "{"),
                      let closeBrace = line.firstIndex(of: "}") else { return [] }
                let joltageStr = String(line[line.index(after: openBrace)..<closeBrace])
                return joltageStr.split(separator: ",").compactMap { Int($0) }
            }()

            return Machine(pattern: pattern, buttons: buttons, joltages: joltages)
        }
    }

    func part1() async -> Int {
        machines.map(minimumPresses).sum()
    }

    /// BFS to find minimum button presses to reach target state
    private func minimumPresses(_ machine: Machine) -> Int {
        let target = machine.pattern.enumerated().reduce(0) { acc, pair in
            pair.element ? acc | (1 << pair.offset) : acc
        }

        guard target != 0 else { return 0 }

        let buttonMasks = machine.buttons.map { $0.reduce(0) { $0 | (1 << $1) } }

        var visited = Set<Int>([0])
        var queue = Deque<(state: Int, presses: Int)>([(0, 0)])

        while let (state, presses) = queue.popFirst() {
            for mask in buttonMasks {
                let newState = state ^ mask
                if newState == target {
                    return presses + 1
                }
                if visited.insert(newState).inserted {
                    queue.append((newState, presses + 1))
                }
            }
        }

        return -1
    }

    func part2() async -> Int {
        await withTaskGroup(of: Int.self, returning: Int.self) { group in
            machines.forEach { machine in
                group.addTask { self.minimumJoltagePresses(machine) }
            }
            return await group.reduce(0, +)
        }
    }

    // MARK: - Rational Arithmetic

    private typealias Rational = (num: Int, den: Int)

    private func gcd(_ a: Int, _ b: Int) -> Int { b == 0 ? abs(a) : gcd(b, a % b) }

    private func reduce(_ r: Rational) -> Rational {
        guard r.num != 0 else { return (0, 1) }
        let g = gcd(r.num, r.den)
        let (num, den) = (r.num / g, r.den / g)
        return den < 0 ? (-num, -den) : (num, den)
    }

    private func sub(_ a: Rational, _ b: Rational) -> Rational {
        reduce((a.num * b.den - b.num * a.den, a.den * b.den))
    }

    private func mul(_ a: Rational, _ b: Rational) -> Rational {
        reduce((a.num * b.num, a.den * b.den))
    }

    private func div(_ a: Rational, _ b: Rational) -> Rational {
        reduce((a.num * b.den, a.den * b.num))
    }

    private func lcm(_ a: Int, _ b: Int) -> Int {
        let (a, b) = (abs(a), abs(b))
        guard a != 0 && b != 0 else { return 0 }
        return (a / gcd(a, b)) * b
    }

    // MARK: - Part 2 Solver

    /// Optimized: Rational Gaussian Elimination -> Integer Grid Search
    private func minimumJoltagePresses(_ machine: Machine) -> Int {
        let target = machine.joltages
        let numCounters = target.count
        let numButtons = machine.buttons.count

        // 1. Build augmented matrix [A | b] with rational arithmetic
        var matrix: [[Rational]] = (0..<numCounters).map { row in
            (0...numButtons).map { col in
                if col == numButtons {
                    return (target[row], 1)
                } else {
                    return machine.buttons[col].contains(row) ? (1, 1) : (0, 1)
                }
            }
        }

        // 2. Gaussian Elimination to reduced row echelon form
        var pivotRow = 0
        var pivotCol = 0
        var pivotCols: [Int] = []

        while pivotRow < numCounters && pivotCol < numButtons {
            guard let foundPivot = (pivotRow..<numCounters).first(where: { matrix[$0][pivotCol].num != 0 }) else {
                pivotCol += 1
                continue
            }

            if foundPivot != pivotRow {
                matrix.swapAt(pivotRow, foundPivot)
            }

            pivotCols.append(pivotCol)
            let scale = matrix[pivotRow][pivotCol]

            // Normalize pivot row
            (pivotCol...numButtons).forEach { col in
                matrix[pivotRow][col] = div(matrix[pivotRow][col], scale)
            }

            // Eliminate column in other rows
            (0..<numCounters).filter { $0 != pivotRow }.forEach { row in
                let factor = matrix[row][pivotCol]
                guard factor.num != 0 else { return }
                (pivotCol...numButtons).forEach { col in
                    matrix[row][col] = sub(matrix[row][col], mul(factor, matrix[pivotRow][col]))
                }
            }
            pivotRow += 1
            pivotCol += 1
        }

        // 3. Consistency check - if any row has 0 = nonzero, no solution
        let isInconsistent = (pivotRow..<numCounters).contains { matrix[$0][numButtons].num != 0 }
        guard !isInconsistent else { return 0 }

        // 4. Identify free variables (columns without pivots)
        let pivotSet = Set(pivotCols)
        let freeVars = (0..<numButtons).filter { !pivotSet.contains($0) }

        // 5. If no free variables, unique solution - sum the pivot values
        if freeVars.isEmpty {
            return (0..<pivotCols.count).reduce(0) { total, row in
                let val = matrix[row][numButtons]
                guard val.den != 0, val.num % val.den == 0 else { return Int.max }
                let intVal = val.num / val.den
                guard intVal >= 0, total != Int.max else { return Int.max }
                return total + intVal
            }.clamped(to: Int.max, fallback: 0)
        }

        // 6. Calculate "Net Cost" for each free variable and sort by most negative first
        let sortedFreeVars = freeVars
            .map { colIdx -> (colIndex: Int, netCost: Double) in
                let costSum = (0..<pivotCols.count).reduce(1.0) { sum, row in
                    sum - Double(matrix[row][colIdx].num) / Double(matrix[row][colIdx].den)
                }
                return (colIdx, costSum)
            }
            .sorted { $0.netCost < $1.netCost }

        // 7. Convert to integer arithmetic via LCM scaling
        let commonDenom = (0..<pivotCols.count).reduce(1) { denom, i in
            let rhsDenom = lcm(denom, matrix[i][numButtons].den)
            return freeVars.reduce(rhsDenom) { lcm($0, matrix[i][$1].den) }
        }

        // Pre-compute scaled integer coefficients for search
        let pivotRowsInt = (0..<pivotCols.count).map { i in
            let rhsScaled = (matrix[i][numButtons].num * commonDenom) / matrix[i][numButtons].den
            let coeffsScaled = sortedFreeVars.map { fv in
                (matrix[i][fv.colIndex].num * commonDenom) / matrix[i][fv.colIndex].den
            }
            return (rhsScaled: rhsScaled, coeffsScaled: coeffsScaled)
        }

        // 8. Grid search with mutable backtracking (performance-critical)
        let safeMax = target.max() ?? 100
        var bestTotal = Int.max
        var currentPivotTerms = [Int](repeating: 0, count: pivotRowsInt.count)

        func search(_ idx: Int, _ currentFreeSum: Int) {
            if idx == sortedFreeVars.count {
                // Evaluate pivot variables - all must be non-negative integers
                let pivotSum = pivotRowsInt.enumerated().reduce(0) { sum, item in
                    guard sum != Int.max else { return Int.max }
                    let numerator = item.element.rhsScaled - currentPivotTerms[item.offset]
                    guard numerator % commonDenom == 0 else { return Int.max }
                    let xP = numerator / commonDenom
                    guard xP >= 0 else { return Int.max }
                    return sum + xP
                }

                if pivotSum != Int.max {
                    bestTotal = min(bestTotal, currentFreeSum + pivotSum)
                }
                return
            }

            let info = sortedFreeVars[idx]
            let (start, end, step) = info.netCost < 0
                ? (safeMax, 0, -1)
                : (0, safeMax, 1)

            var val = start
            while step > 0 ? val <= end : val >= end {
                if info.netCost > 0 && currentFreeSum + val >= bestTotal { break }

                // Forward: accumulate terms
                for i in 0..<pivotRowsInt.count {
                    currentPivotTerms[i] += pivotRowsInt[i].coeffsScaled[idx] * val
                }

                search(idx + 1, currentFreeSum + val)

                // Backtrack: restore terms
                for i in 0..<pivotRowsInt.count {
                    currentPivotTerms[i] -= pivotRowsInt[i].coeffsScaled[idx] * val
                }

                val += step
            }
        }

        search(0, 0)

        return bestTotal == Int.max ? 0 : bestTotal
    }
}

// MARK: - Helper Extension

private extension Int {
    func clamped(to maxValue: Int, fallback: Int) -> Int {
        self == maxValue ? fallback : self
    }
}

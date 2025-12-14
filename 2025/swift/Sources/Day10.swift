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
            // Extract pattern between [ and ]
            guard let patternStart = line.firstIndex(of: "["),
                  let patternEnd = line.firstIndex(of: "]") else { return nil }
            let patternStr = String(line[line.index(after: patternStart)..<patternEnd])
            let pattern = patternStr.map { $0 == "#" }

            // Extract all button groups between ( and )
            var buttons: [Set<Int>] = []
            var searchStart = line.startIndex
            while let openParen = line[searchStart...].firstIndex(of: "("),
                  let closeParen = line[openParen...].firstIndex(of: ")") {
                let buttonStr = String(line[line.index(after: openParen)..<closeParen])
                let indices = buttonStr.split(separator: ",").compactMap { Int($0) }
                buttons.append(Set(indices))
                searchStart = line.index(after: closeParen)
            }

            // Extract joltages between { and }
            var joltages: [Int] = []
            if let openBrace = line.firstIndex(of: "{"),
               let closeBrace = line.firstIndex(of: "}") {
                let joltageStr = String(line[line.index(after: openBrace)..<closeBrace])
                joltages = joltageStr.split(separator: ",").compactMap { Int($0) }
            }

            return Machine(pattern: pattern, buttons: buttons, joltages: joltages)
        }
    }

    func part1() async -> Int {
        machines.map(minimumPresses).sum()
    }

    /// BFS to find minimum button presses to reach target state
    private func minimumPresses(_ machine: Machine) -> Int {
        // Convert pattern to bitmask (bit i = 1 if light i is ON)
        let target = machine.pattern.enumerated().reduce(0) { acc, pair in
            pair.element ? acc | (1 << pair.offset) : acc
        }

        if target == 0 { return 0 }

        let buttonMasks = machine.buttons.map { button in
            button.reduce(0) { $0 | (1 << $1) }
        }

        var visited = Set<Int>([0])
        var queue = Deque<(state: Int, presses: Int)>([(0, 0)])

        while let (state, presses) = queue.popFirst() {
            for mask in buttonMasks {
                let newState = state ^ mask
                if newState == target {
                    return presses + 1
                }
                if !visited.contains(newState) {
                    visited.insert(newState)
                    queue.append((newState, presses + 1))
                }
            }
        }

        return -1
    }

    func part2() async -> Int {
        await withTaskGroup(of: Int.self) { group in
            for machine in machines {
                group.addTask {
                    self.minimumJoltagePresses(machine)
                }
            }
            var total = 0
            for await result in group {
                total += result
            }
            return total
        }
    }

    /// Optimized: Rational Gaussian Elimination -> Integer Grid Search
    private func minimumJoltagePresses(_ machine: Machine) -> Int {
        let target = machine.joltages
        let numCounters = target.count
        let numButtons = machine.buttons.count

        // 1. Build augmented matrix (Rational Arithmetic)
        // Matrix[row][col] stores (numerator, denominator)
        var matrix: [[(Int, Int)]] = (0..<numCounters).map { row in
            var rowData = [(Int, Int)](repeating: (0, 1), count: numButtons + 1)
            for col in 0..<numButtons {
                if machine.buttons[col].contains(row) {
                    rowData[col] = (1, 1)
                }
            }
            rowData[numButtons] = (target[row], 1)
            return rowData
        }

        // --- Rational Helper Functions (Inlined for performance context) ---
        func gcd(_ a: Int, _ b: Int) -> Int { b == 0 ? abs(a) : gcd(b, a % b) }
        func reduce(_ r: (Int, Int)) -> (Int, Int) {
            if r.0 == 0 { return (0, 1) }
            let g = gcd(r.0, r.1)
            let num = r.0 / g
            let den = r.1 / g
            return den < 0 ? (-num, -den) : (num, den)
        }
        func add(_ a: (Int, Int), _ b: (Int, Int)) -> (Int, Int) {
            reduce((a.0 * b.1 + b.0 * a.1, a.1 * b.1))
        }
        func sub(_ a: (Int, Int), _ b: (Int, Int)) -> (Int, Int) {
            reduce((a.0 * b.1 - b.0 * a.1, a.1 * b.1))
        }
        func mul(_ a: (Int, Int), _ b: (Int, Int)) -> (Int, Int) {
            reduce((a.0 * b.0, a.1 * b.1))
        }
        func div(_ a: (Int, Int), _ b: (Int, Int)) -> (Int, Int) {
            reduce((a.0 * b.1, a.1 * b.0))
        }
        func toDouble(_ r: (Int, Int)) -> Double { Double(r.0) / Double(r.1) }

        // 2. Gaussian Elimination
        var pivotRow = 0
        var pivotCol = 0
        var pivotCols: [Int] = []

        while pivotRow < numCounters && pivotCol < numButtons {
            var foundPivot = -1
            for row in pivotRow..<numCounters {
                if matrix[row][pivotCol].0 != 0 {
                    foundPivot = row
                    break
                }
            }

            if foundPivot == -1 {
                pivotCol += 1
                continue
            }

            if foundPivot != pivotRow {
                matrix.swapAt(pivotRow, foundPivot)
            }

            pivotCols.append(pivotCol)
            let scale = matrix[pivotRow][pivotCol]

            for col in pivotCol...numButtons {
                matrix[pivotRow][col] = div(matrix[pivotRow][col], scale)
            }

            for row in 0..<numCounters where row != pivotRow {
                let factor = matrix[row][pivotCol]
                if factor.0 != 0 {
                    for col in pivotCol...numButtons {
                        matrix[row][col] = sub(matrix[row][col], mul(factor, matrix[pivotRow][col]))
                    }
                }
            }
            pivotRow += 1
            pivotCol += 1
        }

        // 3. Consistency Check
        for row in pivotRow..<numCounters {
            if matrix[row][numButtons].0 != 0 { return 0 } // Inconsistent = 0 contribution
        }

        // 4. Identify Free Variables
        let pivotSet = Set(pivotCols)
        let freeVars = (0..<numButtons).filter { !pivotSet.contains($0) }

        // 5. If no free variables, unique solution
        if freeVars.isEmpty {
            var total = 0
            for row in 0..<pivotCols.count {
                let val = matrix[row][numButtons]
                guard val.1 != 0, val.0 % val.1 == 0 else { return 0 }
                let intVal = val.0 / val.1
                guard intVal >= 0 else { return 0 }
                total += intVal
            }
            return total
        }

        // 6. Calculate "Net Cost" for each Free Variable
        struct FreeVarInfo {
            let colIndex: Int
            let netCost: Double
        }

        let freeVarInfos = freeVars.map { colIdx -> FreeVarInfo in
            var costSum: Double = 1.0
            for row in 0..<pivotCols.count {
                let coeff = matrix[row][colIdx]
                costSum -= toDouble(coeff)
            }
            return FreeVarInfo(colIndex: colIdx, netCost: costSum)
        }

        // Sort Free Vars: Process "most negative cost" first
        let sortedFreeVars = freeVarInfos.sorted { $0.netCost < $1.netCost }

        // 7. Convert to Integer Arithmetic
        // Find LCM of all relevant denominators to eliminate fractions
        func lcm(_ a: Int, _ b: Int) -> Int {
            let a = abs(a), b = abs(b)
            if a == 0 || b == 0 { return 0 }
            return (a / gcd(a, b)) * b
        }

        var commonDenom = 1
        for i in 0..<pivotCols.count {
            commonDenom = lcm(commonDenom, matrix[i][numButtons].1) // RHS
            for freeVar in freeVars {
                commonDenom = lcm(commonDenom, matrix[i][freeVar].1) // Coeffs
            }
        }

        // Pre-compute integer coefficients for search
        struct PivotRowInt {
            let rhsScaled: Int
            let coeffsScaled: [Int] // mapped to sortedFreeVars
        }

        var pivotRowsInt: [PivotRowInt] = []
        pivotRowsInt.reserveCapacity(pivotCols.count)

        for i in 0..<pivotCols.count {
            let rhs = matrix[i][numButtons]
            let rhsScaled = (rhs.0 * commonDenom) / rhs.1

            var rowCoeffs: [Int] = []
            rowCoeffs.reserveCapacity(sortedFreeVars.count)
            for fv in sortedFreeVars {
                let r = matrix[i][fv.colIndex]
                let cScaled = (r.0 * commonDenom) / r.1
                rowCoeffs.append(cScaled)
            }
            pivotRowsInt.append(PivotRowInt(rhsScaled: rhsScaled, coeffsScaled: rowCoeffs))
        }

        // 8. Grid Search (Integer Arithmetic)
        let safeMax = target.max() ?? 100
        var bestTotal = Int.max

        // Mutable state array for recursion
        var currentPivotTerms = [Int](repeating: 0, count: pivotRowsInt.count)

        func search(_ idx: Int, _ currentFreeSum: Int) {
            if idx == sortedFreeVars.count {
                var pivotSum = 0
                for i in 0..<pivotRowsInt.count {
                    let numerator = pivotRowsInt[i].rhsScaled - currentPivotTerms[i]
                    if numerator % commonDenom != 0 { return }
                    let xP = numerator / commonDenom
                    if xP < 0 { return }
                    pivotSum += xP
                }

                let total = currentFreeSum + pivotSum
                if total < bestTotal {
                    bestTotal = total
                }
                return
            }

            let info = sortedFreeVars[idx]
            let start = info.netCost < 0 ? safeMax : 0
            let end = info.netCost < 0 ? 0 : safeMax
            let step = info.netCost < 0 ? -1 : 1

            var val = start
            while (step > 0 ? val <= end : val >= end) {
                if info.netCost > 0 && (currentFreeSum + val >= bestTotal) { break }

                for i in 0..<pivotRowsInt.count {
                    currentPivotTerms[i] += pivotRowsInt[i].coeffsScaled[idx] * val
                }

                search(idx + 1, currentFreeSum + val)

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

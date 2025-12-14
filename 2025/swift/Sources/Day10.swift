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

        // Early exit if already at target
        if target == 0 { return 0 }

        // Precompute button masks
        let buttonMasks = machine.buttons.map { button in
            button.reduce(0) { $0 | (1 << $1) }
        }

        // BFS from state 0 to target
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

        return -1  // No solution found
    }

    func part2() async -> Int {
        machines.map { minimumJoltagePresses($0) }.sum()
    }

    /// Solve using rational Gaussian elimination then smart grid search over free variables
    private func minimumJoltagePresses(_ machine: Machine, debug: Bool = false) -> Int {
        let target = machine.joltages
        let numCounters = target.count
        let numButtons = machine.buttons.count

        // 1. Build augmented matrix (Rational Arithmetic)
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

        // --- Rational Helper Functions ---
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
                let temp = matrix[pivotRow]
                matrix[pivotRow] = matrix[foundPivot]
                matrix[foundPivot] = temp
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
            if matrix[row][numButtons].0 != 0 { return -1 }
        }

        // 4. Identify Free Variables
        let pivotSet = Set(pivotCols)
        let freeVars = (0..<numButtons).filter { !pivotSet.contains($0) }

        // 5. If no free variables, unique solution
        if freeVars.isEmpty {
            var total = 0
            for row in 0..<pivotCols.count {
                let val = matrix[row][numButtons]
                guard val.1 != 0, val.0 % val.1 == 0 else { return -1 }
                let intVal = val.0 / val.1
                guard intVal >= 0 else { return -1 }
                total += intVal
            }
            return total
        }

        // 6. Calculate "Net Cost" for each Free Variable
        // NetCost = 1 (for the button itself) - sum(coefficients in pivot rows)
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

        // 7. Sort Free Vars: Process "most negative cost" first
        let sortedFreeVars = freeVarInfos.sorted { $0.netCost < $1.netCost }

        // 8. Grid Search
        let safeMax = target.max() ?? 100
        var bestTotal = Int.max

        // Precompute pivot rows for speed
        let pivotRows = pivotCols.indices.map { i -> (rhs: (Int, Int), coeffs: [(Int, Int)]) in
            let rhs = matrix[i][numButtons]
            let coeffs = sortedFreeVars.map { matrix[i][$0.colIndex] }
            return (rhs, coeffs)
        }

        func search(_ idx: Int, _ currentFreeSum: Int, _ currentPivotUpdates: [(Int, Int)]) {
            if idx == sortedFreeVars.count {
                var pivotSum = 0
                for (rowIndex, rowData) in pivotRows.enumerated() {
                    let val = sub(rowData.rhs, currentPivotUpdates[rowIndex])

                    guard val.1 != 0, val.0 % val.1 == 0 else { return }
                    let intVal = val.0 / val.1
                    guard intVal >= 0 else { return }

                    pivotSum += intVal
                }

                let total = currentFreeSum + pivotSum
                if total < bestTotal {
                    bestTotal = total
                }
                return
            }

            let info = sortedFreeVars[idx]
            let range = 0...safeMax
            // If cost is negative, larger values first; if positive, smaller values first
            let strideOrder = info.netCost < 0
                ? Array(range.reversed())
                : Array(range)

            for val in strideOrder {
                // Pruning: if we're over budget and cost is positive, break
                if currentFreeSum + val >= bestTotal && info.netCost > 0 { break }

                var nextPivotUpdates = currentPivotUpdates
                for i in 0..<pivotRows.count {
                    let contribution = mul(pivotRows[i].coeffs[idx], (val, 1))
                    nextPivotUpdates[i] = add(nextPivotUpdates[i], contribution)
                }

                search(idx + 1, currentFreeSum + val, nextPivotUpdates)
            }
        }

        let initialUpdates = [(Int, Int)](repeating: (0, 1), count: pivotRows.count)
        search(0, 0, initialUpdates)

        return bestTotal == Int.max ? -1 : bestTotal
    }
}

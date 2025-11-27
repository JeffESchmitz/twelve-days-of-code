//
// Advent of Code 2024 Day 7
//
// https://adventofcode.com/2024/day/7
//

import AoCTools

final class Day07: AdventOfCodeDay {
    let title = "Bridge Repair"

    let equations: [[Int]]
    init(input: String) {
        equations = input.lines.map { $0.integers() }
    }

    func part1() async -> Int {
        equations
            .compactMap { solve($0) }
            .reduce(0, +)
    }

    func part2() async -> Int {
        equations
            .compactMap { solve($0, part2: true) }
            .reduce(0, +)
    }

    private func solve(_ equation: [Int], part2: Bool = false) -> Int? {
        solve(
            equation,
            expected: equation[0],
            index: 2,
            partial: equation[1],
            part2: part2
        )
    }

    private func solve(_ equation: [Int], expected: Int, index: Int, partial: Int, part2: Bool) -> Int? {
        if partial > expected {
            return nil
        }
        if index == equation.count {
            return expected == partial ? partial : nil
        }

        if part2, let result = solve(equation, expected: expected, index: index + 1, partial: cat(partial, equation[index]), part2: part2) {
            return result
        }
        if let result = solve(equation, expected: expected, index: index + 1, partial: partial + equation[index], part2: part2) {
            return result
        }
        return solve(equation, expected: expected, index: index + 1, partial: partial * equation[index], part2: part2)
    }

    private func cat(_ a: Int, _ b: Int) -> Int {
        var a = a
        var tmp = b
        while tmp > 0 {
            a *= 10
            tmp /= 10
        }
        return a + b
    }
}


//import Parsing
//
//// Enum to represent operators
//enum Operator {
//    case add, multiply, concatenate
//
//    // Apply the operator to two integers
//    func apply(_ lhs: Int, _ rhs: Int) -> Int {
//        switch self {
//        case .add:
//            return lhs + rhs
//        case .concatenate:
//            return Int(lhs.description + rhs.description)! // Concatenation logic
//        case .multiply:
//            return lhs * rhs
//        }
//    }
//}
//
//final class Day07: AdventOfCodeDay {
//    let title = "Bridge Repair"
//    let input: String
//    let equations: [[Int]]
//    private let parser = InputParser()
//
//    // Lazy property to parse input once and reuse it
//    private lazy var parsedData: [(Int, [Int])] = {
//        var inputCopy = input[...]
//        do {
//            return try parser.parse(&inputCopy)
//        } catch {
//            fatalError("Failed to parse input: \(error)")
//        }
//    }()
//
//    init(input: String) {
//        self.input = input
//        equations = input.lines.map { $0.integers() }
//    }
//
//    func part1() async -> Int {
//        await calculateTotalCalibrationParallel(parsedData: parsedData, includeConcat: false)
//    }
//
//    func part2() async -> Int {
//        await calculateTotalCalibrationParallel(parsedData: parsedData, includeConcat: true)
//    }
//}
//
//extension Day07 {
//    nonisolated func calculateTotalCalibrationParallel(parsedData: [(Int, [Int])], includeConcat: Bool) async -> Int {
//        let tasks = parsedData
//        let includeConcatFlag = includeConcat
//
//        return await withTaskGroup(of: Int.self) { group in
//            for line in tasks {
//                let target = line.0
//                let numbers = line.1
//
//                group.addTask { [self] in
//                    self.processLineParallel(target: target, numbers: numbers, includeConcat: includeConcatFlag)
//                }
//            }
//
//            return await group.reduce(0, +)
//        }
//    }
//
//    nonisolated func processLineParallel(target: Int, numbers: [Int], includeConcat: Bool) -> Int {
//        let operatorCombinations = generateOperatorCombinations(count: numbers.count - 1, includeConcat: includeConcat)
//        for operators in operatorCombinations {
//            if evaluateExpression(numbers: numbers, operators: operators) == target {
//                return target
//            }
//        }
//        return 0
//    }
//
//    nonisolated func generateOperatorCombinations(count: Int, includeConcat: Bool) -> [[Operator]] {
//        guard count > 0 else { return [[]] }
//        let baseOperators: [Operator] = includeConcat ? [.add, .multiply, .concatenate] : [.add, .multiply]
//        return baseOperators.flatMap { op in
//            generateOperatorCombinations(count: count - 1, includeConcat: includeConcat).map { [op] + $0 }
//        }
//    }
//
//    nonisolated func evaluateExpression(numbers: [Int], operators: [Operator]) -> Int {
//        var result = numbers[0]
//        for (index, op) in operators.enumerated() {
//            result = op.apply(result, numbers[index + 1])
//        }
//        return result
//    }
//}
//
//// Parser for a single line of input
//struct LineParser: Parser {
//    typealias Input = Substring
//    typealias Output = (Int, [Int])
//
//    func parse(_ input: inout Substring) throws -> (Int, [Int]) {
//        try Parse {
//            Int.parser(of: Substring.self) // Parse the target integer
//            StartsWith(": ") // Match the colon and space
//            Many {
//                Int.parser(of: Substring.self) // Parse each number after the colon
//            } separator: {
//                StartsWith(" ")
//            }
//        }.parse(&input)
//    }
//}
//
//// Parser for the entire input
//struct InputParser: Parser {
//    typealias Input = Substring
//    typealias Output = [(Int, [Int])]
//
//    func parse(_ input: inout Substring) throws -> [(Int, [Int])] {
//        try Many {
//            LineParser()
//        } separator: {
//            StartsWith("\n")
//        }.parse(&input)
//    }
//}
//
//
////@MainActor
//public protocol AsyncAOCDay: Runnable {
//    var day: String { get }
//    var title: String { get }
//
//    associatedtype Solution1: Sendable
//    func part1() async -> Solution1
//
//    
//    associatedtype Solution2: Sendable
//    func part2() async -> Solution2
//}
//
//extension AsyncAOCDay {
//    public static var input: String { "" }
//    public var day: String { "\(Int("\(Self.self)".suffix(2))!)" }
//    public var title: String { "Day \(day)" }
//
//    @MainActor
//    public func run() {
//        Task {
//            await run(part: 1, part1)
//            await run(part: 2, part2)
//        }
//    }
//
//    @MainActor
//    private func run<T: Sendable>(part: Int, _ fun: () async -> T) async {
//        let timer = Timer(day, fun: "'\(title)' part \(part)")
//        let solution = await fun()
//        timer.show()
//        print("Solution for day \(day) '\(title)' part \(part): \(solution)")
//    }
//}

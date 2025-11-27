//
// Advent of Code 2024 Day 6
//
// https://adventofcode.com/2024/day/6
//

import AoCTools
import Algorithms // For combinations and median calculation
import Parsing
import Foundation

struct GridParser: Parser {
    typealias Input = String
    typealias Output = ([Point: Character], Point, String)

    func parse(_ input: inout String) throws -> ([Point: Character], Point, String) {
        var grid: [Point: Character] = [:]
        var guardStart: Point?
        var guardDirection: String?

        let directions: [Character: String] = ["^": "up", "v": "down", "<": "left", ">": "right"]

        for (y, line) in input.lines.enumerated() {
            for (x, char) in line.enumerated() {
                let point = Point(x, y)
                if char == "#" || char == "." {
                    grid[point] = char
                } else if let dir = directions[char] {
                    guardStart = point
                    guardDirection = dir
                    grid[point] = "." // Replace guard's position with open space
                }
            }
        }

        guard let start = guardStart, let direction = guardDirection else {
            throw GridParsingError.missingGuardDetails(message: "Failed to find the guard's starting position or direction.")
        }

        return (grid, start, direction)
    }
}

enum GridParsingError: Error {
    case missingGuardDetails(message: String)
}

final class Day06: AdventOfCodeDay {
    let title = "Guard Gallivant"
    let input: String

    // Create the parser once
    private let parser = GridParser()

    init(input: String) {
        self.input = input
    }

    func part1() async -> Int {
        do {
            var inputCopy = input
            let (grid, start, direction) = try parser.parse(&inputCopy)
            return simulateGuardMovement(grid: grid, start: start, direction: direction)
        } catch {
            print("Error parsing input: \(error)")
            return 0
        }
    }

    func part2() async -> Int {
        do {
            var inputCopy = input
            let (grid, start, direction) = try parser.parse(&inputCopy)
            return countObstructionPositions(grid: grid, start: start, direction: direction)
        } catch {
            print("Error parsing input: \(error)")
            return 0
        }
    }
    
    func simulateGuardMovement(grid: [Point: Character], start: Point, direction: String) -> Int {
        let directionOrder = ["up", "right", "down", "left"]
        let moves: [String: Point] = [
            "up": Point(0, -1),
            "down": Point(0, 1),
            "left": Point(-1, 0),
            "right": Point(1, 0)
        ]

        var position = start
        var currentDirection = direction
        var visitedPositions: Set<Point> = [position]

        while true {
            let move = moves[currentDirection]!
            let nextPosition = position + move

            // Check if the guard leaves the grid bounds
            if grid[nextPosition] == nil {
                break
            }

            if grid[nextPosition] == "#" {
                // Turn right 90 degrees
                if let currentIndex = directionOrder.firstIndex(of: currentDirection) {
                    currentDirection = directionOrder[(currentIndex + 1) % 4]
                }
            } else {
                // Move forward to the next position
                position = nextPosition
                visitedPositions.insert(position)
            }
        }

        return visitedPositions.count
    }
    
    private func countObstructionPositions(grid: [Point: Character], start: Point, direction: String) -> Int {
        let directionOrder = ["up", "right", "down", "left"]
        let moves: [String: Point] = [
            "up": Point(0, -1),
            "down": Point(0, 1),
            "left": Point(-1, 0),
            "right": Point(1, 0)
        ]

        var possibleObstructionLocations = 0
        var grid = grid

        // Simulate movement with obstructions
        for (loc, value) in grid where value == "." && loc != start {
            grid[loc] = "#" // Add obstruction
            if simulateLoopDetection(grid: grid, start: start, direction: direction, moves: moves, directionOrder: directionOrder) {
                possibleObstructionLocations += 1
            }
            grid[loc] = "." // Remove obstruction
        }

        return possibleObstructionLocations
    }

    private func simulateLoopDetection(
        grid: [Point: Character],
        start: Point,
        direction: String,
        moves: [String: Point],
        directionOrder: [String]
    ) -> Bool {
        var position = start
        var currentDirection = direction
        var visitedStates: Set<GuardState> = [GuardState(position: position, direction: currentDirection)]

        while true {
            let move = moves[currentDirection]!
            let nextPosition = position + move

            if grid[nextPosition] == nil {
                return false // Guard exits the grid
            }

            if grid[nextPosition] == "#" {
                // Turn right 90 degrees
                if let currentIndex = directionOrder.firstIndex(of: currentDirection) {
                    currentDirection = directionOrder[(currentIndex + 1) % 4]
                }
            } else {
                let state = GuardState(position: nextPosition, direction: currentDirection)
                if visitedStates.contains(state) {
                    return true
                }

                visitedStates.insert(state)
                position = nextPosition
            }
        }
    }
}

struct GuardState: Hashable {
    let position: Point
    let direction: String
}

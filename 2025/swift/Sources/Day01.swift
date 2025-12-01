//
// Twelve Days of Code 2025 Day 1
//
// https://adventofcode.com/2025/day/1
//

import AoCTools

// Represents a single dial rotation instruction
struct Rotation {
    let direction: Character  // 'L' or 'R'
    let distance: Int
}

final class Day01: AdventOfCodeDay {
    let title = "Secret Entrance"
    let input: String

    init(input: String) {
        self.input = input
    }

    // Parse input lines into Rotation structs
    func parseInput() -> [Rotation] {
        return input
            .split(separator: "\n")
            .compactMap { line -> Rotation? in
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                guard !trimmed.isEmpty else { return nil }

                // First character is direction (L or R)
                let direction = trimmed.first!

                // Rest is the distance number
                let distanceString = trimmed.dropFirst()
                guard let distance = Int(distanceString) else { return nil }

                return Rotation(direction: direction, distance: distance)
            }
    }

    func part1() async -> Int {
        let rotations = parseInput()

        // Empty input edge case
        guard !rotations.isEmpty else { return 0 }

        var position = 50  // Dial starts at 50
        var count = 0      // Count times we land on 0

        for rotation in rotations {
            // Apply movement based on direction
            if rotation.direction == "L" {
                position -= rotation.distance
            } else {  // direction == "R"
                position += rotation.distance
            }

            // Handle wraparound with modulo arithmetic for large jumps
            // Formula: ((position % 100) + 100) % 100 ensures result is in [0, 99]
            position = ((position % 100) + 100) % 100

            // Check if we landed on zero
            if position == 0 {
                count += 1
            }
        }

        return count
    }

    func part2() async -> Int {
        let rotations = parseInput()
        guard !rotations.isEmpty else { return 0 }

        var position = 50
        var count = 0

        for rotation in rotations {
            let isLeft = rotation.direction == "L"

            // Count how many times we cross/land on 0 during this rotation
            let crossings = countZeroCrossings(
                start: position,
                distance: rotation.distance,
                isLeft: isLeft
            )
            count += crossings

            // Update position for next rotation
            if isLeft {
                position -= rotation.distance
            } else {
                position += rotation.distance
            }
            position = ((position % 100) + 100) % 100
        }

        return count
    }

    private func countZeroCrossings(start: Int, distance: Int, isLeft: Bool) -> Int {
        if distance == 0 { return 0 }

        if isLeft {
            // Going left: distance to 0 is just our current position
            let distanceToZero = start

            if distanceToZero == 0 {
                // Already at 0, count full circles only
                return distance / 100
            } else if distance >= distanceToZero {
                // We reach 0, plus maybe more circles after
                return 1 + (distance - distanceToZero) / 100
            } else {
                // Don't reach 0
                return 0
            }
        } else {
            // Going right: distance to 0 is how far to wrap around
            let distanceToZero = 100 - start

            if distanceToZero == 100 {
                // Already at 0, count full circles only
                return distance / 100
            } else if distance >= distanceToZero {
                // We reach 0, plus maybe more circles after
                return 1 + (distance - distanceToZero) / 100
            } else {
                // Don't reach 0
                return 0
            }
        }
    }
}

//
// Advent of Code 2024 Day 14
//
// https://adventofcode.com/2024/day/14
//

import AoCTools

/// A simple data model representing a robot, storing only position + velocity.
struct Robot {
    let position: Point
    let velocity: Point
}

final class Day14: AdventOfCodeDay {
    let title = "Restroom Redoubt"
    
    private let robots: [Robot]
    let width: Int
    let height: Int
    
    // convenience init uses default puzzle dimensions
    convenience init(input: String) {
        self.init(input: input, width: 101, height: 103)
    }
    
    // main init
    init(input: String, width: Int, height: Int) {
        self.width = width
        self.height = height

        // parse input lines into Robot data
        robots = input.lines
            .map { $0.integers() }
            .map {
                Robot(position: Point($0[0], $0[1]), velocity: Point($0[2], $0[3]))
            }
    }

    func part1() async -> Int {
        return quadrantProduct(at: 100)
    }

    func part2() async -> Int {
        // Find the second where the total distance of all robots to the grid's center is the lowest
        let mid = Point(width / 2, height / 2)

        return (1...width * height)
            .map { sec -> (Int, Int) in
                let robots = robots.map { move($0, seconds: sec) }
                let distance = robots.map { $0.position.distance(to: mid) }.reduce(0, +)
                return (sec, distance)
            }
            .min(by: { $0.1 < $1.1 })?
            .0 ?? 0
    }
}

extension Day14 {
    /// Calculates how many robots land in each quadrant at a given time `t`, then returns their product.
    private func quadrantProduct(at t: Int) -> Int {
        let newPositions = robots.map { positionOf($0, at: t) }

        let q1 = newPositions.filter { $0.x < width / 2 && $0.y < height / 2 }.count
        let q2 = newPositions.filter { $0.x > width / 2 && $0.y < height / 2 }.count
        let q3 = newPositions.filter { $0.x < width / 2 && $0.y > height / 2 }.count
        let q4 = newPositions.filter { $0.x > width / 2 && $0.y > height / 2 }.count

        return q1 * q2 * q3 * q4
    }

    // MARK: - Movement & Wrapping
    
    private func move(_ robot: Robot, seconds: Int) -> Robot {
        let newX = robot.position.x + seconds * robot.velocity.x
        let newY = robot.position.y + seconds * robot.velocity.y

        return Robot(
            position: Point(
                wrap(newX, max: width),
                wrap(newY, max: height)
            ),
            velocity: robot.velocity
        )
    }

    /// Returns the position of a robot after `t` seconds, wrapping on a `width×height` grid.
    private func positionOf(_ robot: Robot, at t: Int) -> Point {
        let rawX = robot.position.x + t * robot.velocity.x
        let rawY = robot.position.y + t * robot.velocity.y
        let wrappedX = wrap(rawX, max: width)
        let wrappedY = wrap(rawY, max: height)
        return Point(wrappedX, wrappedY)
    }

    /// Wraps an integer coordinate into [0 ..< max) range, handling negative values.
    /// The expression `(value % max + max) % max` is a common trick to handle negatives.
    private func wrap(_ value: Int, max: Int) -> Int {
        return (value % max + max) % max
    }
}

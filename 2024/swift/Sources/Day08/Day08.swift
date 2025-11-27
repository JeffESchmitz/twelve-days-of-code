//
// Advent of Code 2024 Day 8
//
// https://adventofcode.com/2024/day/8
//

import AoCTools
import Algorithms
import Foundation
import Parsing

final class Day08: AdventOfCodeDay {
    let title = "Resonant Collinearity"
    let antenna: Antenna

    init(input: String) {
        self.antenna = Antenna(input: input)
    }

    func part1() async -> Int {
        let frequencies = antenna.frequencies
        var antinodeLocations = Set<Point>()

        for freq in frequencies {
            let locations = antenna.locations(for: freq)

            // For each pair of antennas with the same frequency:
            // Add the potential antinodes if they fall within the grid.
            for pair in locations.combinations(ofCount: 2) {
                let (l, r) = (pair[0], pair[1])
                let slope = l - r

                // The candidate antinodes are at l+slope and r-slope.
                for candidate in [l + slope, r - slope] {
                    if antenna.grid[candidate] != nil {
                        antinodeLocations.insert(candidate)
                    }
                }
            }
        }

        return antinodeLocations.count
    }

    func part2() async -> Int {
        let frequencies = antenna.frequencies
        var antinodeLocations = Set<Point>()

        for freq in frequencies {
            let locations = antenna.locations(for: freq)

            // If there's more than one antenna of this frequency,
            // each antenna position can be an antinode.
            if locations.count > 1 {
                antinodeLocations.formUnion(locations)
            }

            // For each pair of antennas with the same frequency:
            // Walk along the line between them in both directions.
            for pair in locations.combinations(ofCount: 2) {
                let (l, r) = (pair[0], pair[1])
                let step = (r - l).normalized()

                // Walk from l outward
                antinodeLocations.formUnion(walkLine(start: l, step: step))
                // Walk from r outward (in the opposite direction)
                antinodeLocations.formUnion(walkLine(start: r, step: -step))
            }
        }

        return antinodeLocations.count
    }

    /// Walks along a line starting from `start` in the direction of `step` until out of grid bounds.
    private func walkLine(start: Point, step: Point) -> Set<Point> {
        var visited = Set<Point>()
        var current = start
        while antenna.grid[current] != nil {
            visited.insert(current)
            current = current + step
        }
        return visited
    }
}

struct Antenna {
    let grid: [Point: Character]

    init(input: String) {
        let lines = input.lines
        grid = Dictionary(
            uniqueKeysWithValues: lines.enumerated().flatMap { y, line in
                line.enumerated().map { x, ch in (Point(x, y), ch) }
            }
        )
    }

    var frequencies: Set<Character> {
        return Set(grid.values).subtracting(["."])
    }

    func locations(for frequency: Character) -> [Point] {
        return grid.compactMap { $0.value == frequency ? $0.key : nil }
    }
}

extension Point {
    static func gcd(_ a: Int, _ b: Int) -> Int {
        b == 0 ? a : gcd(b, a % b)
    }

    func normalized() -> Point {
        guard !(x == 0 && y == 0) else { return self }
        let g = Point.gcd(abs(x), abs(y))
        return Point(x / g, y / g)
    }
}

// Define unary minus operator for Point
prefix func -(point: Point) -> Point {
    return Point(-point.x, -point.y)
}

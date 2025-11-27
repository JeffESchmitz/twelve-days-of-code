//
// Advent of Code 2024 Day 9
//
// https://adventofcode.com/2024/day/9
//

import AoCTools

final class Day09: AdventOfCodeDay {
    let title = "Disk Fragmenter"
    let diskMap: String
    let diskLength: Int // Store total length of the entire disk
    
    init(input: String) {
        self.diskMap = input
        // Build once to obtain disk length
        let (_, length) = Self.buildDiskLayout(Self.parseDiskMap(input))
        self.diskLength = length
    }

    func part1() async -> Int {
        let parsed = Self.parseDiskMap(diskMap)
        var disk = Self.buildDiskLayout(parsed).disk
        Self.compactDisk(&disk)
        return Self.calculateChecksum(disk)
    }

    func part2() async -> Int {
        let parsed = Self.parseDiskMap(diskMap)
        var disk = Self.buildDiskLayout(parsed).disk
        Self.compactDiskWholeFiles(&disk, diskLength: diskLength)
        return Self.calculateChecksum(disk)
    }
}

extension Day09 {
    // Parse the input into a list of (fileSize, gapSize) pairs
    static func parseDiskMap(_ input: String) -> [(Int, Int)] {
        var result: [(Int, Int)] = []
        let digits = input.compactMap { Int(String($0)) }

        for i in stride(from: 0, to: digits.count, by: 2) {
            let fileSize = digits[i]
            let gapSize = (i + 1 < digits.count) ? digits[i + 1] : 0
            result.append((fileSize, gapSize))
        }

        return result
    }

    // Build the initial sparse disk layout and return both the disk and total length
    static func buildDiskLayout(_ parsedDisk: [(Int, Int)]) -> (disk: [Int: Int], length: Int) {
        var disk: [Int: Int] = [:]
        var index = 0
        var fileID = 0

        for (fileSize, gapSize) in parsedDisk {
            // Add file blocks
            for _ in 0..<fileSize {
                disk[index] = fileID
                index += 1
            }
            // Skip gap blocks
            index += gapSize
            fileID += 1
        }

        // 'index' now represents the total length of the disk
        return (disk, index)
    }

    // Compact by moving individual blocks from the end to fill gaps
    static func compactDisk(_ disk: inout [Int: Int]) {
        var writer = 0
        var reader = disk.keys.max() ?? 0

        while true {
            while disk[writer] != nil { writer += 1 }
            while reader >= 0 && disk[reader] == nil { reader -= 1 }

            if writer >= reader { break }

            disk[writer] = disk[reader]
            disk[reader] = nil
        }
    }

    // Compact the disk by moving entire files into the earliest suitable gap before their current position
    static func compactDiskWholeFiles(_ disk: inout [Int: Int], diskLength: Int) {
        let maxFileID = disk.values.max() ?? 0

        // Move files in reverse order of file ID
        for fileID in (0...maxFileID).reversed() {
            let filePositions = disk.filter { $0.value == fileID }.keys.sorted()
            guard !filePositions.isEmpty else { continue }

            let fileSize = filePositions.count
            let fileStartIndex = filePositions.first!

            // Find a contiguous free block before fileStartIndex
            var freeStart: Int? = nil
            var currentFreeCount = 0
            for i in 0..<fileStartIndex {
                if disk[i] == nil {
                    currentFreeCount += 1
                    if currentFreeCount == fileSize {
                        freeStart = i - fileSize + 1
                        break
                    }
                } else {
                    currentFreeCount = 0
                }
            }

            // If no suitable gap found before file's start position, skip
            guard let start = freeStart else {
                continue
            }

            // Move the file blocks to the new location
            for pos in filePositions {
                disk[pos] = nil
            }

            for i in start..<start + fileSize {
                disk[i] = fileID
            }
        }
    }

    // Calculate the checksum
    static func calculateChecksum(_ disk: [Int: Int]) -> Int {
        var checksum = 0
        for (index, fileID) in disk {
            checksum += index * fileID
        }
        return checksum
    }
}


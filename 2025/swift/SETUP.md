# Twelve Days of Code Setup Guide

## Swift Version Requirements

This project requires **Swift 6.0** or later for cross-platform compatibility between macOS and Ubuntu.

### macOS Setup

You have multiple Swift versions installed via `swiftly`:
- Swift 6.2.1
- Swift 6.2.0
- Swift 6.1.2
- Swift 6.0.3 (default)

To use Swift 6.0.3 (already set as default):
```bash
swiftly use 6.0.3
```

### Ubuntu Setup

#### Check Current Swift Version
```bash
swift --version
```

#### Install Swift 6.0 on Ubuntu (if needed)

1. Download Swift 6.0 for Ubuntu from [swift.org](https://www.swift.org/download/)
2. Or use `swiftly` if installed:
```bash
swiftly install 6.0.3
swiftly use 6.0.3
```

#### Installing `swiftly` on Ubuntu
If you don't have `swiftly` on Ubuntu yet:
```bash
curl -L https://swift-server.github.io/swiftly/swiftly-install.sh | bash
```

Then install Swift 6.0:
```bash
swiftly install 6.0.3
swiftly use 6.0.3
```

## Building and Running

### On macOS (Xcode or Terminal)

**In Xcode:**
- Open: `xed .` or double-click `Package.swift`
- Build and Run: `Cmd-R`
- Run Tests: `Cmd-U`

**From Terminal:**
```bash
# Build
swift build

# Run (debug)
swift run

# Run (release/optimized)
swift run -c release

# Run specific day
swift run TwelveDaysOfCode 1

# Run all days
swift run TwelveDaysOfCode all

# Run tests
swift test
```

### On Ubuntu (VSCode or Terminal)

**From Terminal (same commands as macOS):**
```bash
# Build
swift build

# Run
swift run

# Run with optimizations
swift run -c release

# Run specific day
swift run TwelveDaysOfCode 5

# Run all days
swift run TwelveDaysOfCode all

# Run tests
swift test
```

**In VSCode:**
1. Install the Swift extension
2. Open the project folder
3. Use the terminal within VSCode with the commands above

## Quick Compatibility Check

Run this on both systems to verify compatibility:

```bash
# Check Swift version
swift --version

# Should show "swift-tools-version:6.0"
head -1 Package.swift

# Try building
swift build

# Try running tests
swift test
```

## Troubleshooting

### If Ubuntu has only Swift 6.2
The project is currently set to require Swift 6.0 minimum. If you want to use Swift 6.2 on both platforms:

1. Update `Package.swift` first line to: `// swift-tools-version:6.2`
2. Make sure macOS is using 6.2: `swiftly use 6.2.1`

### If you prefer to keep things separate
You can use different Swift versions, but keep `Package.swift` at the **lowest common version** (e.g., `6.0`).

## Platform Notes

Both macOS and Ubuntu should build and run identically since:
- We're using pure Swift code
- AoCTools is cross-platform
- No platform-specific APIs are used (no UIKit, AppKit, etc.)
- All code runs in the Terminal/console

## Current Date: December 1-12, 2025

During December 1-12, running `swift run` (without arguments) will automatically run the puzzle for the current day. Outside this date range, it runs all puzzles sequentially.

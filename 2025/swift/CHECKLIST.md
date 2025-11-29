# TDOC 2025 Setup Checklist

## ✅ What's Been Done

Your TDOC project is now set up with the following changes:

### Core Updates
- [x] **Swift version changed** from 6.2 → 6.0 for cross-platform compatibility
- [x] **Day ranges updated** from 25 → 12 days (TDOC specific)
- [x] **README updated** with TDOC-specific information
- [x] **Swift version locked** via `.swiftly.env` file

### New Files Created
- [x] **SETUP.md** - Complete setup guide for macOS and Ubuntu
- [x] **QUICKSTART.md** - Quick reference and tips
- [x] **new_day.sh** - Script to generate day templates
- [x] **.gitignore** - Protect puzzle inputs from being committed
- [x] **.swiftly.env** - Lock Swift version to 6.0.3
- [x] **.vscode/settings.json** - VSCode configuration for Ubuntu
- [x] **CHECKLIST.md** - This file!

---

## 📋 What You Need To Do

### On macOS (if not already done)

```bash
# 1. Switch to Swift 6.0.3
swiftly use 6.0.3

# 2. Verify it works
swift --version  # Should show 6.0.3

# 3. Build the project
cd /path/to/TwelveDaysOfCode
swift build

# 4. Run tests
swift test

# 5. Make new_day.sh executable
chmod +x new_day.sh
```

### On Ubuntu

```bash
# 1. Install swiftly (if not installed)
curl -L https://swift-server.github.io/swiftly/swiftly-install.sh | bash

# 2. Restart your shell or source the profile
source ~/.bashrc  # or ~/.zshrc

# 3. Install Swift 6.0.3
swiftly install 6.0.3
swiftly use 6.0.3

# 4. Verify
swift --version  # Should show 6.0.3

# 5. Clone/sync your project
cd /path/to/TwelveDaysOfCode

# 6. Build
swift build

# 7. Run tests
swift test

# 8. Make new_day.sh executable
chmod +x new_day.sh
```

### VSCode on Ubuntu (Optional but Recommended)

```bash
# 1. Install Swift extension
# Open VSCode → Extensions → Search "Swift"
# Install: "Swift" by Swift Server Work Group

# 2. Install Swift Language Server
swiftly install latest

# 3. Reload VSCode
# The .vscode/settings.json file is already configured
```

---

## 🎯 Before December 1st

### Test Everything Works

1. **Generate a test day** (use Day 1 since it exists):
   ```bash
   swift run TwelveDaysOfCode 1
   ```

2. **Run existing tests**:
   ```bash
   swift test --filter Day01Tests
   ```

3. **Try creating a new day** (test the script):
   ```bash
   ./new_day.sh 13  # Just for testing
   # Then delete the files if you don't need them yet
   ```

### Prepare Your Workflow

1. **Bookmark useful sites**:
   - Advent of Code 2025: https://adventofcode.com/2025
   - Your TDOC repo
   - AoCTools docs: https://codeberg.org/gereon/AoCTools

2. **Set up your environment**:
   - Have both macOS and Ubuntu ready
   - Test that you can sync code between them (git, rsync, etc.)
   - Verify both can build and run

3. **Plan your approach**:
   - Will you start on macOS or Ubuntu?
   - How will you sync your progress?
   - When will you commit/push code?

---

## 🏁 First Day Workflow (December 1st)

When the first puzzle drops, here's what to do:

### 1. Get the Puzzle
```bash
# Visit https://adventofcode.com/2025/day/1
# Read the puzzle and example
```

### 2. Create Day Files
```bash
./new_day.sh 1
# This creates:
# - Sources/Day01.swift
# - Sources/Day01+Input.swift
# - Tests/Day01Tests.swift
```

### 3. Add Test Input
```swift
// Edit Tests/Day01Tests.swift
fileprivate let testInput = """
paste example input from puzzle here
"""
```

### 4. Add Your Puzzle Input
```swift
// Edit Sources/Day01+Input.swift
extension Day01 {
    static let input = """
paste your personal puzzle input here
"""
}
```

### 5. Update Title
```swift
// Edit Sources/Day01.swift
let title = "Actual Puzzle Title"  // Replace "Day 1"
```

### 6. Implement Solution
```swift
// In Sources/Day01.swift
init(input: String) {
    // Parse the input
}

func part1() async -> Int {
    // Solve part 1
    return yourAnswer
}

// Part 2 comes after you solve Part 1
func part2() async -> Int {
    // Solve part 2
    return yourAnswer
}
```

### 7. Test and Run
```bash
# Test with example input
swift test --filter Day01Tests

# Run with your input
swift run TwelveDaysOfCode 1

# If it's slow, use release mode
swift run -c release TwelveDaysOfCode 1
```

### 8. Submit Answer
- Copy the answer from terminal
- Paste into AoC website
- If correct, implement part 2
- Update tests with your actual answers

---

## 🔄 Cross-Platform Workflow

### Option A: Git-based
```bash
# On macOS (after solving)
git add .
git commit -m "Day 1 solution"
git push

# On Ubuntu (to verify)
git pull
swift test
```

### Option B: Direct Sync
```bash
# From macOS to Ubuntu
rsync -av --exclude .build/ . user@ubuntu:~/TwelveDaysOfCode/

# From Ubuntu to macOS  
rsync -av --exclude .build/ user@ubuntu:~/TwelveDaysOfCode/ .
```

### Option C: Work on One, Verify on Other
- Do all development on your preferred platform
- Occasionally test on the other to ensure compatibility
- Since it's pure Swift, it should always work the same

---

## 🐛 Common Issues

### Issue: "Cannot find 'DayXX' in scope"
**Solution**: Make sure TDOC.swift includes the day in the `days` array:
```swift
private static let days: [any AdventOfCodeDay.Type] = [
    Day01.self,
    Day02.self,
    // ... add new days here
]
```

### Issue: Different line endings
**Solution**: Configure git to handle line endings:
```bash
git config --global core.autocrlf input
```

### Issue: Permission denied on new_day.sh
**Solution**: 
```bash
chmod +x new_day.sh
```

### Issue: Swift version mismatch
**Solution**:
```bash
# Check version
swift --version

# Switch to 6.0.3
swiftly use 6.0.3

# Verify
swift --version
```

---

## 📚 Resources

- **QUICKSTART.md** - Quick reference for commands and patterns
- **SETUP.md** - Detailed setup instructions
- **README.md** - Project overview
- **AoCTools** - https://codeberg.org/gereon/AoCTools

---

## 🎉 You're Ready!

Everything is set up and ready for TDOC 2025! 

**Next steps:**
1. ✅ Follow the macOS and Ubuntu setup sections above
2. ✅ Test that everything builds and runs
3. ✅ Wait for December 1st
4. ✅ Have fun solving puzzles!

Good luck with Twelve Days of Code! 🎄✨

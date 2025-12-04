# 🎄 Twelve Days of Code

> *A multi-year, multi-language journey through festive coding challenges — learning, solving, and celebrating the art of problem-solving.*

---

## 🎁 What's Inside

This repository contains solutions for **Twelve Days of Code** (formerly Advent of Code), organized by year and language. Each solution is crafted not just to solve puzzles, but to **learn deeply** — understanding patterns, algorithms, and the "why" behind every approach.

```
📂 2024/
   ├── 🦅 swift/     23/25 days complete (46⭐)
   └── 🐍 python/    Day 1 ported (learning track)
📂 2025/
   └── 🦅 swift/     4/12 days complete (8⭐) — In progress!
```

### Languages & Progress
- **Swift**: Primary language — full solutions with detailed learnings
- **Python**: Secondary track — porting select days to learn Python idioms
- **Future**: Kotlin and additional languages planned

---

## 🚀 Quick Start

### Swift (2024)
```bash
cd 2024/swift
swift test          # run all tests
./run 22            # run a single day
./run all           # run everything
```

### Python (2024)
```bash
cd 2024/python
./test 1            # test day 1
./run 1             # run day 1 solution
```

### Swift (2025)
```bash
cd 2025/swift
swift test          # run all tests
./test.sh 1         # test day 1
./run.sh 1          # run day 1 solution
```

See language-specific READMEs for setup details and additional commands.

---

## 🧠 Learning Approach

This isn't just about getting stars ⭐ — it's about **mastering problem-solving patterns**.

With the help of **Claude Code** and specialized AI agents:
- 🤖 **Agent Architecture**: Purpose-built agents (Explore, Plan, Task) systematically break down problems, search codebases, and plan implementations
- 🔍 **Deep Understanding**: Break down each problem into fundamental components
- 📊 **Pattern Recognition**: Identify when to use BFS, binary search, memoization, etc.
- ⚡ **Performance Analysis**: Understand time/space complexity and optimization opportunities
- 📝 **Documentation**: Capture insights for future reference

Each day includes:
- Clean, tested solutions
- Algorithm pattern identification
- Performance notes and trade-offs
- Detailed learnings documentation (see `2024/swift/AoC-2024-Learnings.md`)

---

## 🎯 Core Patterns We've Mastered

**Algorithm Selection**
- Shortest path problems → **BFS/Dijkstra**
- "First X that..." → **Binary search**
- "Count all ways" → **Dynamic programming + memoization**
- Grid traversal → **BFS/DFS/Flood fill**

**Data Structure Wisdom**
- `Set.contains()` O(1) vs `Array.contains()` O(n) = **1000x difference**
- `Deque.popFirst()` O(1) vs `Array.removeFirst()` O(n)
- Dictionary-based memoization for scaling to massive inputs

**Three-Phase Architecture**
1. **Precompute**: Do expensive work once
2. **Optimize**: Select the best approach
3. **Scale**: Use caching/memoization for massive inputs

---

## 📚 Learning Resources

### 2024 Archive
- **[2024 Swift Deep Dive](2024/swift/README.md)**: The journey, breakthroughs, and "aha!" moments
- **[8-Step Problem Framework](2024/swift/AoC-2024-Learnings.md)**: Systematic approach to solving any problem
- **Day-Specific Learnings**: See `2024/swift/Sources/DayXX/*-learnings.md` for individual deep dives

### 2025 In Progress
- **[2025 Learning Tracker](2025/swift/TwelveDaysOfCode-2025-Learnings.md)**: Comprehensive guide with patterns, frameworks, and Day 1-2 deep dives
- **Day-Specific Learnings**: See `2025/swift/Sources/DayXX-learnings.md` for detailed walkthroughs

---

## 🎅 Contributing

This is a personal learning repository, but feel free to explore, learn from, or fork for your own journey!

---

*Built with Swift, Python, and the power of AI-assisted learning. Not just solving puzzles — building mastery.*

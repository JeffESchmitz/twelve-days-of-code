# 🎄 Advent of Code 2024: The Journey

> *A Swift programmer's journey through 23 days of festive puzzles, algorithmic breakthroughs, and problem-solving mastery.*

---

## The Adventure So Far

```
23 days conquered  |  46 stars earned  |  2 days remaining  |  92% complete
```

This repository captures not just solutions, but the **insights and patterns** learned along the way.

---

## 📖 A Story of Discovery

### Act I: Foundations (Days 1-16)
Mastering fundamentals: sorting, searching, data structures, grid navigation, and parsing.

### Act II: The Plot Thickens (Days 17-22)
Real challenges that forced different thinking:

**Day 17 - Reverse Engineering** 💡
> Problem: Build a VM and find input that produces specific output
- **Insight**: Work *backward* from the desired output using reverse BFS
- **Key Lesson**: Sometimes the best path forward is backward

**Day 18 - Optimization Breakthrough** 💨
> Problem: Find when pathfinding becomes impossible among hundreds of obstacles
- **Naive**: Linear search (17+ seconds) | **Optimized**: Binary search (60ms)
- **Key Lesson**: Algorithm choice matters more than implementation

**Day 21 - Scaling to 10^14** 🏔️
> Problem: Multi-layer keypad simulation with 25 depth levels
- **Naive**: Impossible to brute force | **Solution**: Nested memoization
- **Key Lesson**: Right data structure + caching = elegant scaling

**Day 22 - Pre-computation Insight** 🎯
> Problem: Find best 4-change sequence among 130,321 possibilities
- **Naive**: Try all 130k × 2.2k combinations | **Smart**: Only process sequences that exist
- **Key Lesson**: Understand your problem before optimizing

### Act III: Graph Theory & The Final Push (Days 23-25)

**Day 23 - LAN Party** 🔗
> Problem: Find all triangles (3-cliques) in a network, then discover the largest clique
- **Insight**: Follow connections, don't check all combinations (3,000x faster)
- **Key Lesson**: Data structure choice (Set vs Array) can make algorithm 1000x faster
- **Result**: Found 1,108 triangles with 't' nodes, 13-node maximum clique

🎄 *Two days remain. The finale awaits.*

---

## 🎓 What I Learned

**1. Pattern Recognition**
- Shortest path → BFS
- "First X that" → Binary search
- "Count all ways" → Dynamic programming
- Grid traversal → BFS/DFS/Flood fill

**2. Data Structure Selection is Critical**
- `Array.contains()` O(n) vs `Set.contains()` O(1) = 1000x difference
- `Deque.popFirst()` O(1) vs `Array.removeFirst()` O(n)
- Dictionary keys for memoization vs recalculating

**3. Clean Code First, Optimize Later**
- Part 2 changes often reused Part 1's code
- Tests caught bugs early
- Refactoring was trivial

**4. The Three-Phase Architecture**
1. **Precompute**: Do expensive work once
2. **Optimize**: Select the best choice
3. **Scale**: Use memoization/caching for massive scale

---

## 📚 Learning Resources

- **[AoC-2024-Learnings.md](AoC-2024-Learnings.md)**: 8-step problem decomposition framework, algorithm patterns, performance analysis
- **[Day-Specific Deep Dives](Sources/)**:
  - [Day 17](Sources/Day17/Day17-learnings.md): VM design & reverse BFS
  - [Day 18](Sources/Day18/Day18-learnings.md): Search optimization
  - [Day 21](Sources/Day21/Day21-learnings.md): Multi-layer simulation
  - [Day 22](Sources/Day22/Day22-learnings.md): Algorithm design
  - [Day 23](Sources/Day23/Day23-learnings.md): Graph theory & clique detection

---

## 🚀 Quick Start

```bash
swift build
./run 22          # Run Day 22
./test 22         # Test a day
./run all         # Run all solutions
cat AoC-2024-Learnings.md
```

See [CLAUDE.md](CLAUDE.md) for full setup details.

---

## 📊 The Results

**By the Numbers**
- 23 Days Completed ✅
- 46 Stars Earned ⭐⭐
- 10+ Algorithms Mastered
- 2 Days Remaining 🎄

**Performance Highlights**
| Challenge | Solution | Speedup | Day |
|-----------|----------|---------|-----|
| Reverse Engineer Output | BFS Backward | — | 17 |
| Shortest Path + Blocking | Binary Search on BFS | **280x** | 18 |
| Multi-layer Scaling | Nested Memoization | **10^14 scale** | 21 |
| Sequence Optimization | Pre-computation | **100x+** | 22 |
| Graph Traversal | Common Neighbors Pattern | **3,000x** | 23 |

---

## 💭 Reflections

What made this journey unique:
1. **Learning-First Approach**: Understanding patterns, not just chasing stars
2. **Comprehensive Documentation**: Reference library built day-by-day
3. **Socratic Questioning**: Deepening understanding, not just solving
4. **Pattern Connection**: Seeing relationships across problems

What I'm taking to 2025:
- 8-step problem breakdown framework
- Catalog of algorithm patterns
- Data structure selection criteria
- Optimization insights and trade-offs
- **Confidence**: Any problem can be solved systematically

---

## 🏆 Current Progress

```
███████████████████░░░░░░  Days (23/25)
███████████████████░░░░░░░  Stars (46/50)
```

---

## 🔗 Credits

Built on [Gereon Steffens' AoC2024 template](https://github.com/gereons/AoC2024).

---

*This journey isn't just about 25 stars. It's about the patterns learned and the problem-solver developed along the way.*

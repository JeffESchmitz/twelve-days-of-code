# Twelve Days of Code

Multi-year solutions for Twelve Days of Code (formerly Advent of Code), kept in `YYYY/<language>/`.

## What's here
- `2024/swift`: Full Swift package (ex-AoC2024) with solutions, tests, and detailed learnings.
- `2024/python`: Python port starting with Day 1 (pytest + simple CLI).
- `2025/swift`: Prepared starter kit for the upcoming season (templates, scripts, and day stubs).
- Placeholders for future `kotlin/` and `python/` tracks under each year.

## Quick start
```bash
# Swift (2024)
cd 2024/swift
swift test          # run all tests
./run 22            # run a single day
./run all           # run everything
```
See the per-language README for additional commands or editor tooling (`2024/swift/README.md`).

## Learning resources
- `2024/swift/AoC-2024-Learnings.md`: 8-step problem breakdown, algorithm patterns, and performance notes.
- Day-by-day deep dives under `2024/swift/Sources/DayXX/*-learnings.md` for specific puzzles.

## Patterns we emphasize
- Choose the right tool: BFS/DFS for grids, binary search for “first X that…”, memoization for “count all ways”.
- Data structures matter: prefer `Set`/`Deque` over linear scans when complexity matters.
- Three-phase flow: precompute expensive pieces, optimize selection, then scale with caching.

## Progress
- 2024 Swift: 23/25 days solved (46/50 stars) — see `2024/swift/README.md` for story and highlights.

## History
- Repository renamed from `advent-of-code` to reflect the new event name; old links redirect.

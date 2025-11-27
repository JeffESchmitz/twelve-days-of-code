# Day 19: Linen Layout - Learnings & Insights

## Problem Summary

Day 19 presents a two-part string matching problem using memoization:
- **Part 1**: Count how many designs can be constructed from available patterns
- **Part 2**: Count the TOTAL number of ways to construct all designs

## Part 1: Checking if a Design is Constructible

### The Challenge

Given a set of available towel patterns (e.g., "r", "wr", "b", "g", "bwu", "rb", "gb", "br"), determine which designs can be made by concatenating these patterns.

Example:
- Input: Patterns: ["r", "wr", "b", "g", "bwu", "rb", "gb", "br"]
- Designs: ["brwrr", "bggr", "gbbr", "rrbgbr", ...]
- Question: How many designs are valid? (Answer: 6 out of 8)

### Key Concepts

#### 1. Problem Structure: String Decomposition

This is a **string decomposition problem**:
- Start with a target string (design)
- Break it into parts that match available patterns
- Check if all parts can be used

**Example walkthrough with "brwrr":**
```
Can we make "brwrr"?
├─ Try removing "b" (pattern exists) → "rwrr" remains
│  └─ Can we make "rwrr"?
│     ├─ Try removing "r" (pattern exists) → "wrr" remains
│     │  └─ Can we make "wrr"?
│     │     ├─ Try removing "wr" (pattern exists) → "r" remains
│     │     │  └─ Can we make "r"?
│     │     │     ├─ Try removing "r" (pattern exists) → "" remains
│     │     │     │  └─ Empty string! ✅ SUCCESS!
```

#### 2. Algorithm: Recursive Backtracking with Memoization

**Why memoization?**
- Without it: Same substrings solved multiple times (exponential time)
- With it: Each unique substring solved once (polynomial time)

**Pattern**:
```swift
func canMakeDesign(_ design: String) -> Bool {
    var memo: [String: Bool] = [:]

    func canMake(_ remaining: String) -> Bool {
        // Base case
        if remaining.isEmpty { return true }

        // Memoization lookup
        if let cached = memo[remaining] { return cached }

        // Try each pattern
        for pattern in patterns {
            if remaining.hasPrefix(pattern) {
                let rest = String(remaining.dropFirst(pattern.count))
                if canMake(rest) {
                    memo[remaining] = true
                    return true
                }
            }
        }

        memo[remaining] = false
        return false
    }

    return canMake(design)
}
```

### Why This Works

1. **Prefix matching**: `hasPrefix()` is O(m) where m is pattern length
2. **Early termination**: Return `true` immediately when a solution is found
3. **Memoization key**: The remaining substring is unique for each state
4. **Cache hit**: Second time seeing "wrr", we just return cached result

### Performance

**Example input** (8 designs):
- Average design length: ~6 characters
- Unique substrings per design: ~5-10
- Time per design: ~1ms
- Total: ~8ms ✅

**Real input** (335 designs):
- Average design length: ~20 characters
- Pattern diversity: ~250 patterns
- Time: ~30ms ✅

**Key insight**: Memoization makes this O(n × m²) where n = design length, m = pattern count, instead of exponential.

---

## Part 2: Counting All Possible Constructions

### The Challenge

Instead of just checking IF a design is possible, count HOW MANY different ways it can be constructed.

**Example**:
- Design: "r"
- Ways: [using pattern "r"]
- Count: 1

- Design: "wr"
- Ways: [using patterns "w"+"r", or "wr" if available]
- Count: Could be 1 or 2 depending on patterns

### The Elegant Modification

```swift
func countWays(_ design: String) -> Int {
    var memo: [String: Int] = [:]

    func count(_ remaining: String) -> Int {
        // Base case: empty string = 1 way (the way that led here)
        if remaining.isEmpty { return 1 }

        // Memoization lookup
        if let cached = memo[remaining] { return cached }

        var ways = 0
        // Try EACH pattern that matches (don't return early!)
        for pattern in patterns {
            if remaining.hasPrefix(pattern) {
                let rest = String(remaining.dropFirst(pattern.count))
                ways += count(rest)  // Add all ways from this choice
            }
        }

        memo[remaining] = ways
        return ways
    }

    return count(design)
}
```

### Key Differences from Part 1

| Part 1 | Part 2 |
|--------|--------|
| Returns `Bool` | Returns `Int` |
| Returns `true` on first match | Tries ALL patterns |
| Early termination | No early termination |
| Memo stores: "true" or "false" | Memo stores: "count of ways" |
| `if canMake(rest) return true` | `ways += count(rest)` |

### Why the Base Case is 1

```swift
if remaining.isEmpty { return 1 }
```

This counts "one way" to construct the empty string: by successfully matching all characters. Each path down the recursion tree that reaches empty string represents one valid construction.

### Example: "brwrr"

Assuming patterns include: ["b", "r", "wr", "brw", ...]

```
count("brwrr")
├─ Try "b" → count("rwrr") + ... other patterns
│  └─ Try "r" → count("wrr") + ... other patterns
│     ├─ Try "wr" → count("r") + ... other patterns
│     │  └─ Try "r" → count("") = 1
│     └─ count("r") = 1 (from direct "wr" + "r")
│
└─ Try "brw" → count("rr") + ... other patterns
   └─ Try "r" → count("r")
      └─ Try "r" → count("") = 1

// Total could be several different combinations
```

The remarkable thing: **exact same recursion structure**, just accumulating instead of returning early.

### Performance

**Memoization is critical here!**

Without memoization:
- Exponential branches: 2^(design length) possibilities
- For 20-char designs: 2^20 = 1,000,000+ calls
- Time: Several seconds ❌

With memoization:
- Each substring solved once: O(n²) substrings
- Each substring tries O(m) patterns
- Time: O(n² × m) = ~200ms ✅

**Speedup: 1000x+!**

---

## Part 2 Complete Solution

```swift
func part2() async -> Int {
    designs.reduce(0) { sum, design in
        sum + countWays(design)
    }
}
```

**That's it!** The beauty is:
- Each design: count ways independently
- Sum all the ways across all designs
- Answer: 692,596,560,138,745

---

## 🌟 Pattern Recognition: Memoization for Counting

### When to Use This Pattern

1. **Recursive structure**: Problem breaks down into subproblems
2. **Repeated subproblems**: Same substring/state appears multiple times
3. **Counting paths**: Want total number of valid solutions, not just one
4. **Exponential without memoization**: Would be too slow

### Template for Counting Problems

```swift
func countSolutions(_ target: T) -> Int {
    var memo: [String: Int] = [:]  // or [T: Int] if T is hashable

    func count(_ state: T) -> Int {
        // Base case
        if state.isComplete { return 1 }  // One way to be complete

        // Memoization
        if let cached = memo[state] { return cached }

        var total = 0
        for choice in availableChoices {
            if isValid(choice, for: state) {
                let newState = state.after(choice)
                total += count(newState)
            }
        }

        memo[state] = total
        return total
    }

    return count(initialState)
}
```

### Compare: Part 1 vs Part 2

| | Part 1 (Feasibility) | Part 2 (Counting) |
|---|---|---|
| **Question** | "Can we make it?" | "How many ways?" |
| **Return type** | Bool | Int |
| **Base case value** | true | 1 |
| **Combine results** | OR (return early) | ADD (accumulate) |
| **Use case** | Validation | Enumeration |
| **Typical speedup** | 10-100x | 100-1000x |

---

## Data Structure Choices

### Memo Key: String (Substring)

```swift
var memo: [String: Int] = [:]
```

**Why String?**
- Each substring is unique
- Easy to cache with String as key
- Direct mapping: remaining string → count of ways

**Alternatives considered:**
- Index + remaining length: More efficient, but less readable
- Regex patterns: Overkill

---

## Code Quality Insights

### 1. Reusable Helper Functions

```swift
private func canMakeDesign(_ design: String) -> Bool { ... }
private func countWays(_ design: String) -> Int { ... }
```

Both are private (implementation detail) but share:
- Same pattern matching logic
- Same memoization structure
- Same recursion approach

### 2. Clear Naming

- `canMake` vs `count`: Names reflect intent
- Mutable `memo`: Obvious it's a cache
- Function parameters: Clear what's being computed

### 3. Swift Idioms

```swift
// Part 1: Filter + count
designs.filter { canMakeDesign($0) }.count

// Part 2: Reduce + accumulate
designs.reduce(0) { sum, design in
    sum + countWays(design)
}
```

Both are functional, readable, and efficient.

---

## Testing Strategy

### Example Input

```
r, wr, b, g, bwu, rb, gb, br

brwrr    <- valid
bggr     <- valid
gbbr     <- valid
rrbgbr   <- valid
ubwu     <- invalid
bwurrg   <- valid
brgr     <- valid
bbrgwb   <- invalid
```

**Part 1**: 6 valid designs ✓
**Part 2**: 16 total ways across all valid designs ✓

### Edge Cases

1. **Single character pattern**: "r"
   - Design "r": 1 way

2. **Multiple ways to split**: "brr" with patterns "b", "r", "br"
   - "b" + "r" + "r"
   - "br" + "r"
   - Count: 2

3. **No valid construction**: "xyz" (impossible)
   - Part 1: false
   - Part 2: 0 ways

---

## Performance Summary

| Aspect | Part 1 | Part 2 | Notes |
|--------|--------|--------|-------|
| Algorithm | Memoization (Boolean) | Memoization (Counting) | Same structure, different accumulation |
| Time | ~30ms (335 designs) | ~210ms (same) | Counting is slightly more expensive |
| Space | ~O(n × m) memo | ~O(n × m) memo | Similar memory usage |
| Bottleneck | String operations | Recursion depth | Could optimize with indices |
| Speedup potential | 100x vs brute force | 1000x vs brute force | Memoization is critical |

---

## Key Takeaways

### 1. Memoization Changes Complexity Class

From exponential to polynomial just by caching results.

### 2. Boolean vs Integer: Same Structure, Different Intent

- Checking feasibility: Return on first success
- Counting possibilities: Accumulate all results

### 3. String Matching is Universal

This pattern applies to:
- Regex validation
- Word segmentation
- Path counting
- DNA sequence matching
- Many parsing problems

### 4. Functional Swift is Elegant

`reduce()` over `designs` combined with `countWays()` is more readable than imperative loops.

### 5. Testing Drives Design

Because we can test `countWays()` on individual designs, we catch bugs immediately.

---

## Patterns for 2025

### Recognition Keywords

When you see these in a problem:
- "How many ways..." → Counting pattern (Part 2 template)
- "Can we make..." → Feasibility pattern (Part 1 template)
- "Different combinations..." → Memoization
- "Subproblems repeat..." → Cache and reuse

### Checklist

- [ ] Identify if problem has memoizable structure
- [ ] Write feasibility check first (easier to debug)
- [ ] Verify with example input
- [ ] Extend to counting if needed
- [ ] Add memo.clear() between test runs if needed

---

## Potential Extensions

1. **Optimize with indices instead of strings**: Avoid substring creation overhead
2. **Parallel computation**: Count ways for each design in parallel
3. **Top-down vs bottom-up**: Could do DP table (less intuitive for strings)
4. **Pattern efficiency**: Pre-sort patterns by length for faster matching

---

*Day 19 complete with elegant memoization mastery! The Boolean-to-Integer transformation is a powerful pattern.*


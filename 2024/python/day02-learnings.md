# Day 02: Red-Nosed Reactor - Python Learnings

## Problem Summary
- Parse reports (lines of space-separated integers)
- Part 1: Count "safe" reports (all increasing OR decreasing, differences 1-3)
- Part 2: Count reports safe OR made safe by removing one level

## Python Patterns Learned

### 1. List Comprehensions
Building new lists from existing data:
```python
differences = [levels[i+1] - levels[i] for i in range(len(levels) - 1)]
```

**Syntax breakdown:**
- `[expression for variable in iterable]` - basic form
- `expression`: What to compute (`levels[i+1] - levels[i]`)
- `variable`: Loop variable (`i`)
- `iterable`: What to loop over (`range(len(levels) - 1)`)

**Mathematical set-builder notation:**
- Math: `{ f(x) | x ∈ S }`
- Python: `[f(x) for x in S]`

### 2. The `all()` Function
Check if all items satisfy a condition:
```python
all_increasing = all(diff > 0 for diff in differences)
all_decreasing = all(diff < 0 for diff in differences)
```

- Takes an iterable (list, generator, etc.)
- Returns `True` if all elements are truthy
- Short-circuits (stops at first `False`)

**Generator expression inside `all()`:**
```python
all(1 <= abs(diff) <= 3 for diff in differences)
```
Memory efficient - doesn't build intermediate list.

### 3. List Slicing
Extract portions of lists:
```python
# Remove element at index i
reduced = levels[:i] + levels[i+1:]
```

**Slicing syntax:**
- `levels[:i]` - Everything before index i
- `levels[i+1:]` - Everything after index i
- `levels[i:j]` - Elements from i to j-1
- `levels[:]` - Shallow copy of entire list

### 4. Generator Expressions with `sum()`
Count items matching a condition:
```python
sum(1 for report in reports if is_safe_report(report))
```

**Why `sum(1 for ...)`?**
- Counts items without building intermediate list
- Equivalent to: `len([r for r in reports if is_safe_report(r)])`
- But more memory efficient

**Breakdown:**
- `1 for report in reports` - Yields 1 for each report
- `if is_safe_report(report)` - Filter condition
- `sum(...)` - Add up all the 1s

### 5. Chained Comparisons
Pythonic range checking:
```python
1 <= abs(diff) <= 3  # Instead of: abs(diff) >= 1 and abs(diff) <= 3
```

Python allows chaining: `a <= b <= c` reads like math notation.

## Python vs Swift Mental Models

**Swift (Pipeline/Graph thinking):**
```swift
levels.map { transform($0) }.filter { condition($0) }
```
Left-to-right flow: data → transform → filter

**Python (Set-builder thinking):**
```python
[transform(x) for x in levels if condition(x)]
```
Result-first: "Build this... from this source... with this filter"

### Why It Feels "Backwards"
If you think in graphs/pipelines:
- Swift: Follow the data flow (node → edge → node)
- Python: Declare the destination, then specify the source

**When to use each:**
- List comprehensions: Simple transforms/filters
- Loops: Complex logic, graph traversal (BFS/DFS)
- Generator expressions: Large datasets, memory constraints

## Key Functions Recap

| Function | Purpose | Example |
|----------|---------|---------|
| `all(iterable)` | Check if all True | `all(x > 0 for x in nums)` |
| `any(iterable)` | Check if any True | `any(x > 0 for x in nums)` |
| `sum(iterable)` | Add up values | `sum(1 for x in items if condition(x))` |
| `range(n)` | Generate 0 to n-1 | `range(len(levels) - 1)` |

## Part 2 Strategy
**Problem Dampener:** Remove one level to make report safe

**Approach:**
1. Try removing each index
2. Check if reduced list is safe
3. Return `True` if any removal works

**Implementation:**
```python
for i in range(len(levels)):
    reduced = levels[:i] + levels[i+1:]
    if is_safe_report(reduced):
        return True
```

Brute force but clear and correct. AoC datasets are small enough that O(n²) is fine.

## Key Takeaway
List comprehensions and generator expressions are Python's idiomatic way of expressing transforms and filters. They feel "backwards" compared to method chaining, but they're declarative (what you want) vs procedural (how to get it). With practice, both mental models become natural.

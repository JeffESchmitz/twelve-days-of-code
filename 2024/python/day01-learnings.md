# Day 01: Historian Hysteria - Python Learnings

## Problem Summary
- Parse two-column input into separate lists
- Part 1: Sort both lists, sum absolute differences
- Part 2: Similarity score - multiply each left value by its count in right list

## Python Patterns Learned

### 1. Built-in Parsing
Python's standard library handles most AoC parsing needs:
```python
parts = line.split()  # Split on whitespace
a, b = map(int, parts)  # Convert to integers
```

No external parsing framework needed for simple cases.

### 2. Tuple Unpacking
Clean way to handle multiple return values:
```python
left, right = parse(input_str)  # Returns tuple[list[int], list[int]]
```

### 3. `zip()` for Pairing
Elegant way to iterate over two lists simultaneously:
```python
sum(abs(a - b) for a, b in zip(left_sorted, right_sorted))
```

### 4. Collections.Counter
Perfect for counting occurrences:
```python
from collections import Counter
counts = Counter(right)  # dict-like: {value: count}
```

Counter provides:
- Automatic zero-default for missing keys
- Clean frequency counting
- Dictionary-like access

### 5. Generator Expressions
Memory-efficient iteration without building intermediate lists:
```python
sum(value * counts[value] for value in left)
```

vs building a list first:
```python
sum([value * counts[value] for value in left])  # Less efficient
```

## Python vs Swift Comparison

**Parsing:**
- Swift: PointFree Parsing library (powerful, compositional, learning curve)
- Python: `str.split()` + built-ins (simple, direct)

**Counting:**
- Swift: Manual dictionary or filter/reduce
- Python: `Counter` from standard library

**Iteration:**
- Swift: `zip(left, right).map { abs($1 - $0) }`
- Python: `(abs(b - a) for a, b in zip(left, right))`

## Type Hints
Modern Python 3.13 type hints:
```python
def parse(input_str: str) -> tuple[list[int], list[int]]:
```

- `list[int]` instead of `typing.List[int]`
- `tuple[...]` instead of `typing.Tuple[...]`
- Cleaner, built-in to Python 3.9+

## Key Takeaway
Python excels at quick, readable solutions for straightforward problems. The standard library provides most tools needed for AoC without external dependencies.

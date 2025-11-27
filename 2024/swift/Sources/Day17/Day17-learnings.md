# Day 17: Chronospatial Computer - Learnings

## Problem Summary

Day 17 presented a two-part challenge involving a 3-bit virtual machine:
- **Part 1**: Implement a VM with 8 opcodes and execute a program
- **Part 2**: Reverse engineer to find the initial register value that makes the program output itself (a quine)

## Part 1: Building the Virtual Machine

### The Challenge
Create a 3-bit computer simulator with:
- 3 registers (A, B, C) holding integers
- 8 instructions (opcodes 0-7)
- An instruction pointer
- Output buffer for results

### Key Concepts

#### 1. Combo Operands
The most important concept was understanding two operand types:
- **Literal operands**: Use the value as-is
- **Combo operands**:
  - 0-3 → literal values
  - 4 → register A
  - 5 → register B
  - 6 → register C

#### 2. The 8 Opcodes

| Opcode | Name | Operation | Operand Type |
|--------|------|-----------|--------------|
| 0 | adv | A = A / 2^combo | Combo |
| 1 | bxl | B = B XOR literal | Literal |
| 2 | bst | B = combo % 8 | Combo |
| 3 | jnz | Jump if A ≠ 0 | Literal |
| 4 | bxc | B = B XOR C | Ignored |
| 5 | out | Output combo % 8 | Combo |
| 6 | bdv | B = A / 2^combo | Combo |
| 7 | cdv | C = A / 2^combo | Combo |

### Implementation Approach

1. **Struct-based design**: Created a `Computer` struct to encapsulate VM state
2. **Instruction dispatch**: Used Swift's `switch` statement for clean opcode handling
3. **Jump handling**: Special care for `jnz` - only increment IP when NOT jumping

### Challenges Faced

#### Challenge 1: Index Out of Bounds
**Problem**: Initial loop condition `while instructionPointer < program.count` caused crashes
```swift
// ❌ Wrong - can access program[ip+1] out of bounds
while instructionPointer < program.count {
    let operand = program[instructionPointer + 1] // CRASH!
```

**Solution**: Check that we have both opcode AND operand available
```swift
// ✅ Correct
while instructionPointer < program.count - 1 {
    let opcode = program[instructionPointer]
    let operand = program[instructionPointer + 1]
```

#### Challenge 2: Jump Instruction Double-Increment
**Problem**: The `jnz` instruction was incrementing IP, then the main loop also incremented
```swift
// ❌ Wrong - double increment when not jumping
mutating func jnz(_ operand: Int) {
    if registerA != 0 {
        instructionPointer = operand
    } else {
        instructionPointer += 2  // Main loop also adds 2!
    }
}
```

**Solution**: Only set IP on jump, let main loop handle the increment when not jumping
```swift
// ✅ Correct
mutating func jnz(_ operand: Int) {
    if registerA != 0 {
        instructionPointer = operand
    }
    // Main loop will increment by 2 if we didn't jump
}
```

#### Challenge 3: Input Parsing
**Problem**: `split(separator: "\n")` skips empty lines
```swift
// Input has empty line between registers and program
let lines = input.split(separator: "\n")
// lines[3] is program, not lines[4]!
```

**Solution**: Account for the fact that split() omits empty lines
```swift
let programLine = lines[3].split(separator: ": ")[1]  // Not lines[4]
```

### Part 1 Result
✅ Successfully outputs: `5,0,3,5,7,6,1,5,4`

---

## Part 2: Finding the Quine

### The Challenge
Find the lowest positive initial value for register A that makes the program output a copy of itself.

Example: Program `[0,3,5,4,3,0]` outputs itself when A = 117440

### Key Insights

#### Insight 1: The Program Structure
Looking at most AoC Day 17 programs, they follow a pattern:
1. Process A in chunks of 3 bits (division by 8)
2. Output one value per iteration
3. Loop until A = 0

This means:
- Each output consumes roughly 3 bits of A
- For N outputs, we need approximately 3×N bits
- We can work **backwards** from the desired output

#### Insight 2: Working Backwards
Instead of trying random values of A forward, we can:
1. Start with values that produce the **last** output correctly
2. Extend those by prepending 3 bits to produce the **last 2** outputs
3. Continue until we produce **all** outputs

### Algorithm: Breadth-First Search with Deque

```swift
import Collections

func part2() async -> Int {
    var queue = Deque<Int>()
    queue.append(0)  // Start with A=0

    // Work backwards through target outputs
    for outputIndex in (0..<target.count).reversed() {
        var nextQueue = Deque<Int>()

        while let currentA = queue.popFirst() {
            // Try all possible 3-bit values to prepend
            for bits in 0..<8 {
                let candidateA = (currentA << 3) | bits

                // Test if this produces the right suffix
                var testComputer = Computer(registerA: candidateA, ...)
                testComputer.run()

                let expectedSuffix = Array(target.suffix(from: outputIndex))
                if testComputer.output == expectedSuffix {
                    nextQueue.append(candidateA)
                }
            }
        }
        queue = nextQueue
    }

    return queue.min() ?? -1
}
```

### Why Use Deque?

Swift's `Deque` from the Collections package provides:
- **O(1) append and prepend** operations
- **O(1) popFirst()** for BFS queue operations
- **Clear intent**: Using a queue data structure makes the algorithm obvious

Alternative approaches considered:
- **Recursive backtracking**: Works but harder to find the *minimum* A
- **Array as queue**: `removeFirst()` is O(n), much slower
- **DFS**: Could work but BFS naturally finds smaller solutions first

### The Build Pattern

The key operation is:
```swift
let candidateA = (currentA << 3) | bits
```

This **prepends** 3 bits to A:
- `currentA << 3` shifts existing bits left
- `| bits` adds new 3-bit value in the low bits
- Example: `0b1010 << 3 | 0b101 = 0b1010101`

### Why This Works

Working backwards ensures we:
1. Only explore A values that can produce correct suffixes
2. Prune the search space dramatically
3. Build from small A to large A naturally
4. Find the minimum valid A (BFS property)

### Part 2 Result
✅ Answer: `164516454365621`

---

## Key Takeaways

### 1. Virtual Machine Implementation
- **Struct mutability**: Using `mutating func` for state changes is clean
- **Opcode dispatch**: Swift's switch statement is perfect for this
- **Edge cases matter**: Array bounds, instruction pointer management

### 2. Reverse Engineering Approach
- **Work backwards**: When output depends on input in a sequential way
- **BFS for minimum**: Breadth-first naturally finds smallest solutions
- **Bit manipulation**: Understanding how bits are consumed helps reverse the process

### 3. Swift Collections
- **Deque**: Essential for efficient queue operations
- **Array methods**: `suffix(from:)`, `prefix(_:)` are handy for sequence matching

### 4. Problem-Solving Strategy
1. **Implement forward solution** first (Part 1)
2. **Understand the mechanics** deeply
3. **Identify the pattern** in how input affects output
4. **Reverse the process** systematically
5. **Use appropriate data structures** (Deque for BFS)

### 5. Debugging Tips
- **Start with example inputs**: The provided test cases caught bugs early
- **Print intermediate states**: Watching register values helps understand VM behavior
- **Test boundary conditions**: Empty programs, single instructions, etc.

---

## Performance Notes

- **Part 1**: ~0.1ms (simple simulation)
- **Part 2**: ~7ms (BFS with pruning)

The BFS approach is efficient because:
- We prune invalid A values immediately
- We only explore ~8^16 states (much less than brute force)
- Each VM execution is fast (~0.001ms)

## Potential Extensions

Ideas for further exploration:
1. **Optimize Part 2**: Analyze program structure to skip impossible bit patterns
2. **Generalize VM**: Support different bit widths or instruction sets
3. **Static analysis**: Detect program properties (loops, outputs, etc.) without execution
4. **Visualization**: Show how A evolves through execution

---

## Code Organization

```
Day17/
├── Day17.swift          # Main implementation
├── Day17+Input.swift    # Puzzle input
└── Day17-learnings.md   # This file
```

The final implementation is clean, well-tested, and demonstrates both simulation and reverse engineering techniques.

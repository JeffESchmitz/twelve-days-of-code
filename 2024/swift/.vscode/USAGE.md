# VSCode Setup Guide for AoC 2024

## ✅ Setup Complete

Your VSCode environment is now configured for Swift development with this AoC project!

### Installed Extensions:
- Swift for Visual Studio Code (swiftlang.swift-vscode)
- Apple Swift Format (vknabel.vscode-apple-swift-format)
- SwiftFormat (vknabel.vscode-swiftformat)
- SwiftLint (vknabel.vscode-swiftlint)

## How to Use

### 🏃 Running Code

**Option 1: Run using tasks**
1. Press `Cmd+Shift+P` (Command Palette)
2. Type "Tasks: Run Task"
3. Select "swift: Run AdventOfCode" or "Run Specific Day"

**Option 2: Run from terminal**
- Open integrated terminal: `` Ctrl+` ``
- Run: `./run <day-number>` (e.g., `./run 1`)
- Run all: `./run all`

### 🐛 Debugging Code

**Step-by-step debugging:**
1. Open a day file (e.g., `Sources/Day01/Day01.swift`)
2. Click in the gutter to set breakpoints (red dots)
3. Press `F5` or go to Run → Start Debugging
4. Select "Debug AdventOfCode"
5. The debugger will stop at your breakpoints

**Debug Controls:**
- `F5` - Start/Continue debugging
- `F10` - Step over (execute line, don't go into functions)
- `F11` - Step into (go into function calls)
- `Shift+F11` - Step out (exit current function)
- `Shift+F5` - Stop debugging

**Passing arguments to debugger:**
- Edit `.vscode/launch.json`
- Add day number to `args` array: `"args": ["1"]`

### 🧪 Testing Code

**Option 1: Run all tests**
1. Press `Cmd+Shift+P`
2. Type "Tasks: Run Task"
3. Select "swift: Test All"

**Option 2: Run specific day tests**
1. Press `Cmd+Shift+P`
2. Type "Tasks: Run Task"
3. Select "Test Specific Day"
4. Enter day number when prompted

**Option 3: Terminal**
- All tests: `./test`
- Specific day: `./test 1`

**Option 4: Swift Testing UI**
- Click the beaker icon (🧪) in the left sidebar
- Browse and run individual tests
- View test results inline

### 🔨 Building Code

**Manual build:**
1. Press `Cmd+Shift+B` for default build task
2. Or: `Cmd+Shift+P` → "Tasks: Run Build Task"

**Build variants:**
- Debug: `swift build`
- Release: `swift build --configuration release`

### 🔍 Code Navigation

- `Cmd+Click` on symbol - Go to definition
- `Shift+F12` - Find all references
- `Cmd+Shift+O` - Go to symbol in file
- `Cmd+T` - Go to symbol in workspace
- `F12` - Go to definition
- `Cmd+Shift+F` - Search across all files

### 💡 IntelliSense

- Type to get autocomplete suggestions
- `Ctrl+Space` - Trigger suggestions manually
- `Cmd+.` - Show quick fixes and refactoring options

### 📝 Useful Shortcuts

- `` Ctrl+` `` - Toggle integrated terminal
- `Cmd+B` - Toggle sidebar
- `Cmd+Shift+E` - Open file explorer
- `Cmd+Shift+F` - Search in files
- `Cmd+P` - Quick open file
- `Cmd+/` - Toggle line comment
- `Option+Shift+F` - Format document

## Configuration Files

### `.vscode/launch.json`
Debug configurations for running/debugging the executable.

### `.vscode/tasks.json`
Build and test tasks for quick execution.

### `.vscode/settings.json`
Swift-specific settings including:
- Xcode 26.1 path
- LLDB configuration
- Test UI preferences

## Troubleshooting

**If debugging doesn't work:**
1. Ensure you've built the project first (`Cmd+Shift+B`)
2. Check that Xcode 26.1 is installed at the path in settings.json
3. Verify LLDB path is correct

**If tests don't appear:**
1. Build the project to generate test targets
2. Check the Testing sidebar (beaker icon)
3. Refresh tests: `Cmd+Shift+P` → "Test: Refresh Tests"

**If IntelliSense is slow:**
1. Let SourceKit finish indexing (check status bar)
2. Restart Swift language server: `Cmd+Shift+P` → "Swift: Restart Language Server"

## Quick Start Workflow

1. **Start coding**: Open or create a day file
2. **Set breakpoint**: Click line number gutter
3. **Run with debugger**: Press `F5`
4. **Step through code**: Use `F10`, `F11`
5. **Run tests**: `Cmd+Shift+P` → "Tasks: Run Task" → "Test Specific Day"
6. **Check results**: View in terminal or Testing UI

Enjoy solving AoC 2024! 🎄

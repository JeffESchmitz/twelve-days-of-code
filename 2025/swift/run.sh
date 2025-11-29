#!/bin/bash

set -euo pipefail

TARGET_ARGS="${*:-}"

if [ -z "$TARGET_ARGS" ]; then
    echo "🎅 Running all days (release)…"
else
    echo "🎄 Running with args: $TARGET_ARGS (release)…"
fi

swift run --configuration release TwelveDaysOfCode $TARGET_ARGS
echo "✅ Done."

#!/bin/bash

set -euo pipefail

if [ ! -z "${1:-}" ]; then
    DAY=$(printf "%02d" "$1")
    FILTER="--filter TDOCTests.Day$DAY"
    echo "🎄 Running tests for Day $DAY (release configuration)…"
else
    echo "🎅 Running all tests (release configuration)…"
fi

echo "🛠️  Building in release mode…"
swift test --configuration release $FILTER
echo "✅ Done."

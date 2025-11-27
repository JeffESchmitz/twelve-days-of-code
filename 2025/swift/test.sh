#!/bin/bash

if [ ! -z "$1" ]; then
    DAY=$(printf "%02d" $1)
    FILTER="--filter TDOCTests.Day$DAY"
fi
swift test --configuration release $FILTER

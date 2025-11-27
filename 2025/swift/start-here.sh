#!/bin/bash

# Set Swift version using swiftly
echo "Setting Swift version to 6.2.0..."
swiftly use 6.2.0

# Verify the Swift version was set correctly
echo "Current Swift version:"
swift --version

# Open the package in Xcode
echo "Opening package in Xcode..."
xed .

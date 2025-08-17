#!/bin/bash
# File Cleanup App Launcher
# Double-click this file to launch the file cleanup workflow

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change to the script directory
cd "$SCRIPT_DIR"

# Check if the launcher script exists
if [[ -f "cleanup_launcher.sh" ]]; then
    echo "🚀 Launching File Cleanup App..."
    echo "=================================="
    echo ""
    
    # Run the launcher
    ./cleanup_launcher.sh
else
    echo "❌ Error: cleanup_launcher.sh not found"
    echo "Make sure this file is in the same directory as the cleanup scripts"
    echo ""
    echo "Press any key to exit..."
    read -n 1
fi

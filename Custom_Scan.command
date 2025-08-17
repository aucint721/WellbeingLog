#!/bin/bash
cd "$HOME/Wellbeing Log"
echo "📂 Custom Directory Scan"
echo "========================"
echo ""
echo "Enter directories to scan (space-separated):"
echo "Example: ~/Downloads ~/Desktop ~/Pictures"
echo ""
read -p "Directories: " directories
echo ""
if [[ -n "$directories" ]]; then
    python3 file_cleanup_workflow.py --directories $directories
    echo ""
    echo "✅ Custom scan completed!"
    echo "Reports saved in cleanup_reports/"
else
    echo "❌ No directories specified"
fi
echo ""
read -p "Press Enter to continue..."

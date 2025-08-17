#!/bin/bash
cd "$HOME/Wellbeing Log"
python3 file_cleanup_workflow.py --quick-scan
echo ""
echo "✅ Quick scan completed!"
echo "Reports saved in cleanup_reports/"
echo ""
read -p "Press Enter to continue..."

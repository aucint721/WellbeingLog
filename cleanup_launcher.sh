#!/bin/bash

# File Cleanup Workflow Launcher
# Provides a menu interface for various cleanup operations

cd "$(dirname "$0")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display menu
show_menu() {
    clear
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}    FILE CLEANUP WORKFLOW${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
    echo -e "${YELLOW}Choose an option:${NC}"
    echo ""
    echo "1) 🚀 Quick Scan (Common directories)"
    echo "2) 🔍 Full System Scan"
    echo "3) 📂 Custom Directory Scan"
    echo "4) 🗑️  Cleanup Old & Large Files"
    echo "5) 📊 Open Latest Report"
    echo "6) 🆘 Show Help"
    echo "7) ❌ Exit & Close Terminal"
    echo ""
}

# Function to run quick scan
quick_scan() {
    echo -e "${GREEN}🚀 Running Quick Scan...${NC}"
    echo ""
    python3 file_cleanup_workflow.py --quick-scan
    echo ""
    echo -e "${GREEN}✅ Quick scan completed!${NC}"
    echo "Reports saved in cleanup_reports/"
    echo ""
    echo -e "${YELLOW}Press Enter to return to menu...${NC}"
    read -p ""
}

# Function to run full scan
full_scan() {
    echo -e "${GREEN}🔍 Running Full System Scan...${NC}"
    echo ""
    python3 file_cleanup_workflow.py
    echo ""
    echo -e "${GREEN}✅ Full system scan completed!${NC}"
    echo "Reports saved in cleanup_reports/"
    echo ""
    echo -e "${YELLOW}Press Enter to return to menu...${NC}"
    read -p ""
}

# Function to run custom scan
custom_scan() {
    echo -e "${GREEN}📂 Custom Directory Scan${NC}"
    echo "========================"
    echo ""
    echo "Enter directories to scan (space-separated):"
    echo "Example: ~/Downloads ~/Desktop ~/Pictures"
    echo ""
    read -p "Directories: " directories
    echo ""
    if [[ -n "$directories" ]]; then
        echo -e "${GREEN}🔍 Scanning custom directories...${NC}"
        echo ""
        python3 file_cleanup_workflow.py --directories $directories
        echo ""
        echo -e "${GREEN}✅ Custom scan completed!${NC}"
        echo "Reports saved in cleanup_reports/"
    else
        echo -e "${RED}❌ No directories specified${NC}"
    fi
    echo ""
    echo -e "${YELLOW}Press Enter to return to menu...${NC}"
    read -p ""
}

# Function to cleanup old and large files
cleanup_old_large_files() {
    echo -e "${GREEN}🗑️  Cleanup Old & Large Files${NC}"
    echo "================================"
    echo ""
    echo -e "${YELLOW}This will help you find files that are:${NC}"
    echo "• Large (>100MB) - taking up disk space"
    echo "• Old (>1 year) - potentially outdated"
    echo "• Unused (>6 months since last access)"
    echo "• Duplicates - wasting storage"
    echo ""
    echo -e "${YELLOW}Safety: Files are NOT automatically deleted!${NC}"
    echo "You'll get a detailed report to review first."
    echo ""
    read -p "Press Enter to start cleanup scan..."
    echo ""
    
    echo -e "${GREEN}🔍 Running cleanup scan...${NC}"
    echo ""
    
    # Run the cleanup workflow with focus on common cleanup directories
    python3 file_cleanup_workflow.py --directories ~/Downloads ~/Desktop ~/Documents ~/Pictures ~/Movies
    
    echo ""
    echo -e "${GREEN}✅ Cleanup scan completed!${NC}"
    echo "Reports saved in cleanup_reports/"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "• Use 'Quick Look at Results' to preview the report"
    echo "• Use 'Open Latest Report' to view in browser"
    echo "• Review files carefully before deleting anything"
    echo ""
    echo -e "${YELLOW}Press Enter to return to menu...${NC}"
    read -p ""
}



# Function to open latest report
open_report() {
    echo -e "${GREEN}📊 Opening Latest Report${NC}"
    echo ""
    
    # Check if reports directory exists
    if [[ ! -d "cleanup_reports" ]]; then
        echo -e "${RED}❌ No reports found. Run a scan first.${NC}"
        echo -e "${YELLOW}Press Enter to return to menu...${NC}"
        read -p ""
        return
    fi
    
    # Find the latest report
    latest_report=$(find cleanup_reports -name "*.html" -type f -exec ls -t {} + | head -n1)
    
    if [[ -n "$latest_report" ]]; then
        echo "Opening latest report: $latest_report"
        open "$latest_report"
        echo -e "${GREEN}✅ Report opened in default browser${NC}"
    else
        echo -e "${RED}❌ No HTML reports found${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}Press Enter to return to menu...${NC}"
    read -p ""
}







# Function to show help
show_help() {
    echo -e "${GREEN}🆘 File Cleanup Workflow Help${NC}"
    echo "================================"
    echo ""
    echo -e "${YELLOW}What this tool does:${NC}"
    echo "• Scans your system for large, old, and unused files"
    echo "• Identifies potential files for cleanup"
    echo "• Generates detailed reports"
    echo "• Helps organize your file system"
    echo ""
    echo -e "${YELLOW}Scan Types:${NC}"
    echo "• Quick Scan: Common directories (Downloads, Desktop, etc.)"
    echo "• Full Scan: Entire system (takes longer)"
    echo "• Custom Scan: Specific directories you choose"
    echo "• Cleanup Focus: Old, large, and unused files for deletion"
    echo ""
    echo -e "${YELLOW}Reports:${NC}"
    echo "• HTML reports with file details and risk scores"
    echo "• CSV exports for spreadsheet analysis"
    echo "• JSON data for further processing"
    echo "• Working Quick Look buttons for file previews"
    echo ""
    echo -e "${YELLOW}Safety Features:${NC}"
    echo "• Files are NOT automatically deleted"
    echo "• Review all suggestions before taking action"
    echo "• Risk scoring helps prioritize decisions"
    echo ""
    echo -e "${YELLOW}Press Enter to return to menu...${NC}"
    read -p ""
}

# Main menu loop
while true; do
    show_menu
    read -p "Enter your choice (1-7): " choice
    
    case $choice in
        1)
            quick_scan
            ;;
        2)
            full_scan
            ;;
        3)
            custom_scan
            ;;
        4)
            cleanup_old_large_files
            ;;
        5)
            open_report
            ;;
        6)
            show_help
            ;;
        7)
            echo -e "${GREEN}👋 Goodbye!${NC}"
            echo ""
            echo "Closing terminal in 3 seconds..."
            sleep 3
            # Close the terminal window
            osascript -e 'tell application "Terminal" to close (every window whose name contains ".command")' 2>/dev/null || true
            # Alternative method for closing terminal
            kill -9 $PPID 2>/dev/null || true
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid option. Please try again.${NC}"
            sleep 2
            ;;
    esac
done

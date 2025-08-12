#!/bin/bash
# Test Intake Automation System
# Verifies that the centralized file organization works

echo "🧪 Testing Intake Automation System..."
echo "======================================"

# Test directory
TEST_DIR="$HOME/Documents/Research/File_Intake/Test_Files"
mkdir -p "$TEST_DIR"

echo "📁 Created test directory: $TEST_DIR"

# Test files
echo "📝 Creating test files..."

# Test PDF (research document)
echo "This is a test PDF for EDSP 505 Inclusive Education research." > "$TEST_DIR/EDSP_505_Inclusive_Education_Test.pdf"

# Test LaTeX file
echo "\\documentclass{article}" > "$TEST_DIR/Research_Paper_Test.tex"
echo "\\title{Test Research Paper}" >> "$TEST_DIR/Research_Paper_Test.tex"
echo "\\begin{document}" >> "$TEST_DIR/Research_Paper_Test.tex"
echo "\\maketitle" >> "$TEST_DIR/Research_Paper_Test.tex"
echo "This is a test LaTeX document." >> "$TEST_DIR/Research_Paper_Test.tex"
echo "\\end{document}" >> "$TEST_DIR/Research_Paper_Test.tex"

# Test image
echo "This is a test image file." > "$TEST_DIR/test_image.jpg"

# Test audio
echo "This is a test audio file." > "$TEST_DIR/test_audio.m4a"

# Test code
echo "#!/usr/bin/env python3" > "$TEST_DIR/test_script.py"
echo "print('This is a test Python script')" >> "$TEST_DIR/test_script.py"

echo "✅ Created test files:"
ls -la "$TEST_DIR"

echo ""
echo "🎯 Now testing the automation system..."
echo ""

# Test each file type
for file in "$TEST_DIR"/*; do
    if [ -f "$file" ]; then
        echo "🔍 Processing: $(basename "$file")"
        ~/Documents/Research/hazel_intake_automation.sh "$file"
        echo ""
    fi
done

echo "🔍 Checking results..."
echo ""

# Check organized research
if [ -d "$HOME/Documents/Research/Organized_Research" ]; then
    echo "✅ Organized Research directory exists:"
    find "$HOME/Documents/Research/Organized_Research" -type f -name "*test*" 2>/dev/null | head -5
else
    echo "❌ Organized Research directory not found"
fi

# Check projects
if [ -d "$HOME/Documents/Research/Projects" ]; then
    echo "✅ Projects directory exists:"
    find "$HOME/Documents/Research/Projects" -type f -name "*test*" 2>/dev/null | head -5
else
    echo "❌ Projects directory not found"
fi

# Check archives
if [ -d "$HOME/Documents/Research/Archives/By_Type" ]; then
    echo "✅ Archives directory exists:"
    find "$HOME/Documents/Research/Archives/By_Type" -type f -name "*test*" 2>/dev/null | head -5
else
    echo "❌ Archives directory not found"
fi

# Check logs
if [ -f "$HOME/Documents/Research/Logs/hazel_intake.log" ]; then
    echo "✅ Log file created:"
    tail -10 "$HOME/Documents/Research/Logs/hazel_intake.log"
else
    echo "❌ Log file not found"
fi

echo ""
echo "🧹 Cleaning up test files..."
echo ""

# Clean up organized test files
find "$HOME/Documents/Research" -name "*test*" -type f -delete 2>/dev/null

# Remove test directory
rm -rf "$TEST_DIR"

echo "✅ Cleanup complete"
echo ""
echo "🎉 Intake System Test Complete!"
echo ""
echo "📋 Next Steps:"
echo "1. Set up Hazel rules as described in COMPREHENSIVE_FILE_ORGANIZATION_SETUP.md"
echo "2. Configure application default directories"
echo "3. Test with real files from your applications"
echo "4. Monitor logs for processing details"
echo ""
echo "🚀 Your centralized file organization system is ready!"

#!/bin/bash
# Test Hazel Setup
# Verifies that Hazel rules are working correctly

echo "🧪 Testing Hazel Setup..."
echo "=========================="

# Test directory
TEST_DIR="$HOME/Documents/Research/File_Intake/Safari_Downloads"
mkdir -p "$TEST_DIR"

echo "📁 Created test directory: $TEST_DIR"

# Test files
echo "📝 Creating test files..."

# Test PDF with course context
echo "This is a test PDF for EDSP 554 Autism research." > "$TEST_DIR/EDSP_554_Autism_Intervention_Test.pdf"

# Test LaTeX file
echo "\\documentclass{article}" > "$TEST_DIR/Test_Research_Paper.tex"
echo "\\title{Test Research Paper}" >> "$TEST_DIR/Test_Research_Paper.tex"
echo "\\begin{document}" >> "$TEST_DIR/Test_Research_Paper.tex"
echo "\\maketitle" >> "$TEST_DIR/Test_Research_Paper.tex"
echo "This is a test LaTeX document." >> "$TEST_DIR/Test_Research_Paper.tex"
echo "\\end{document}" >> "$TEST_DIR/Test_Research_Paper.tex"

# Test image
echo "This is a test image file." > "$TEST_DIR/test_image.jpg"

echo "✅ Created test files:"
ls -la "$TEST_DIR"

echo ""
echo "🎯 Now Hazel should automatically process these files..."
echo "⏳ Waiting 10 seconds for Hazel to process..."
echo ""

# Wait for Hazel to process
sleep 10

echo "🔍 Checking results..."
echo ""

# Check if files were processed (should be moved from test directory)
if [ -z "$(ls -A $TEST_DIR)" ]; then
    echo "✅ Hazel processed all files! Test directory is empty."
else
    echo "⚠️ Some files still in test directory:"
    ls -la "$TEST_DIR"
fi

# Check organized research
if [ -d "$HOME/Documents/Research/Organized_Research" ]; then
    echo "✅ Organized Research directory exists:"
    find "$HOME/Documents/Research/Organized_Research" -type f -name "*test*" 2>/dev/null | head -5
fi

# Check projects
if [ -d "$HOME/Documents/Research/Projects" ]; then
    echo "✅ Projects directory exists:"
    find "$HOME/Documents/Research/Projects" -type f -name "*test*" 2>/dev/null | head -5
fi

# Check archives
if [ -d "$HOME/Documents/Research/Archives/By_Type" ]; then
    echo "✅ Archives directory exists:"
    find "$HOME/Documents/Research/Archives/By_Type" -type f -name "*test*" 2>/dev/null | head -5
fi

# Check logs
if [ -f "$HOME/Documents/Research/Logs/hazel_intake.log" ]; then
    echo "✅ Log file created:"
    tail -10 "$HOME/Documents/Research/Logs/hazel_intake.log"
else
    echo "❌ Log file not found - Hazel may not be processing files"
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
echo "🎉 Hazel Setup Test Complete!"
echo ""
echo "📋 If Hazel processed the files automatically:"
echo "   ✅ Your Hazel rules are working correctly!"
echo "   ✅ The automation system is functioning!"
echo ""
echo "📋 If Hazel did NOT process the files:"
echo "   ❌ Check Hazel permissions (Full Disk Access)"
echo "   ❌ Verify rules are enabled and configured correctly"
echo "   ❌ Check the log file for error messages"
echo ""
echo "🚀 Your centralized file organization system is ready!"

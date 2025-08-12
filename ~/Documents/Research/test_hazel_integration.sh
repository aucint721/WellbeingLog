#!/bin/bash
# Test Hazel Integration Script
# Verifies that the system-wide organization script works correctly

echo "🧪 Testing Hazel Integration..."
echo "================================"

# Test directory
TEST_DIR="$HOME/Desktop/Hazel_Test"
TEST_FILES=(
    "test_document.pdf"
    "test_image.jpg"
    "test_audio.m4a"
    "test_code.py"
    "test_ebook.epub"
)

# Create test directory
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "📁 Created test directory: $TEST_DIR"

# Create test files
echo "📝 Creating test files..."

# Test PDF
echo "This is a test PDF document for Hazel automation testing." > test_document.pdf

# Test image (create a simple text file with .jpg extension for testing)
echo "This is a test image file for Hazel automation testing." > test_image.jpg

# Test audio
echo "This is a test audio file for Hazel automation testing." > test_audio.m4a

# Test code
echo "#!/usr/bin/env python3" > test_code.py
echo "print('This is a test Python script for Hazel automation testing')" >> test_code.py

# Test e-book
echo "This is a test e-book file for Hazel automation testing." > test_ebook.epub

echo "✅ Created test files:"
ls -la

echo ""
echo "🎯 Now testing the organization script..."
echo ""

# Run the organization script on the test directory
~/Documents/Research/hazel_rules_system_wide.sh

echo ""
echo "🔍 Checking results..."
echo ""

# Check if files were moved
if [ -d "$HOME/Documents/Research/Archives/By_Type" ]; then
    echo "✅ Files were organized into Archives/By_Type:"
    ls -la "$HOME/Documents/Research/Archives/By_Type" | grep "test_"
else
    echo "❌ Files were not organized as expected"
fi

# Check if test directory is empty
if [ -z "$(ls -A $TEST_DIR)" ]; then
    echo "✅ Test directory is now empty (files were processed)"
else
    echo "❌ Test directory still contains files"
    ls -la "$TEST_DIR"
fi

echo ""
echo "🧹 Cleaning up test files..."
echo ""

# Clean up organized test files
find "$HOME/Documents/Research" -name "test_*" -type f -delete 2>/dev/null

# Remove test directory
rm -rf "$TEST_DIR"

echo "✅ Cleanup complete"
echo ""
echo "🎉 Hazel Integration Test Complete!"
echo ""
echo "📋 Next Steps:"
echo "1. Open Hazel application"
echo "2. Add Desktop folder to monitor"
echo "3. Create 'Desktop Auto-Organize' rule"
echo "4. Test with a real file"
echo "5. Enable the rule for automation"
echo ""
echo "📖 See HAZEL_AUTOMATION_SETUP.md for complete setup instructions"

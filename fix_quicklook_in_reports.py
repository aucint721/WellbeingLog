#!/usr/bin/env python3
"""
Fix Quick Look buttons in existing HTML reports
Updates the JavaScript function to use a working Quick Look method
"""

import os
import re
import glob

def fix_quicklook_in_html(html_file_path):
    """Fix Quick Look functionality in an HTML file"""
    
    print(f"🔧 Fixing Quick Look in: {html_file_path}")
    
    # Read the HTML file
    with open(html_file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Find and replace the broken openQuickLook function
    old_function = r'''function openQuickLook\(filePath\) \{
            // Create a temporary file with the path for Quick Look
            const tempFile = document\.createElement\('a'\);
            tempFile\.href = 'file://' \+ filePath;
            tempFile\.download = '';
            tempFile\.click\(\);
            
            // Alternative: Use macOS Quick Look via URL scheme
            // window\.open\('file://' \+ filePath\);
        \}'''
    
    new_function = '''function openQuickLook(filePath) {
            // Try to open the file in the default application first
            try {
                // Method 1: Try to open with file:// protocol
                const link = document.createElement('a');
                link.href = 'file://' + filePath;
                link.target = '_blank';
                link.click();
                
                // Method 2: Show user instructions for manual Quick Look
                setTimeout(() => {
                    const message = 'File opened! For Quick Look:\n\n' +
                                  '1. Copy this path: ' + filePath + '\\n' +
                                  '2. Open Terminal\\n' +
                                  '3. Run: qlmanage -p "' + filePath + '"\\n\\n' +
                                  'Or right-click the file in Finder and select "Quick Look"';
                    
                    if (confirm(message + '\\n\\nWould you like to copy the file path to clipboard?')) {
                        copyPathToClipboard(filePath);
                    }
                }, 1000);
                
            } catch (error) {
                // Fallback: Show manual instructions
                const message = 'To use Quick Look for this file:\\n\\n' +
                              '1. Copy this path: ' + filePath + '\\n' +
                              '2. Open Terminal\\n' +
                              '3. Run: qlmanage -p "' + filePath + '"\\n\\n' +
                              'Or right-click the file in Finder and select "Quick Look"';
                
                if (confirm(message + '\\n\\nWould you like to copy the file path to clipboard?')) {
                    copyPathToClipboard(filePath);
                }
            }
        }
        
        // Function to copy file path to clipboard
        function copyPathToClipboard(filePath) {
            if (navigator.clipboard) {
                navigator.clipboard.writeText(filePath).then(() => {
                    alert('✅ File path copied to clipboard: ' + filePath);
                }).catch(() => {
                    // Fallback for older browsers
                    fallbackCopyTextToClipboard(filePath);
                });
            } else {
                fallbackCopyTextToClipboard(filePath);
            }
        }
        
        // Fallback copy function for older browsers
        function fallbackCopyTextToClipboard(filePath) {
            const textArea = document.createElement('textarea');
            textArea.value = filePath;
            textArea.style.position = 'fixed';
            textArea.style.left = '-999999px';
            textArea.style.top = '-999999px';
            document.body.appendChild(textArea);
            textArea.focus();
            textArea.select();
            
            try {
                document.execCommand('copy');
                alert('✅ File path copied to clipboard: ' + filePath);
            } catch (err) {
                alert('❌ Could not copy to clipboard. Please copy manually: ' + filePath);
            }
            
            document.body.removeChild(textArea);
        }'''
    
    # Replace the function
    if re.search(old_function, content, re.DOTALL):
        content = re.sub(old_function, new_function, content, flags=re.DOTALL)
        print("✅ Quick Look function updated")
    else:
        print("⚠️  Could not find the old Quick Look function")
        return False
    
    # Write the fixed HTML back to the file
    with open(html_file_path, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print("✅ HTML file updated successfully")
    return True

def main():
    """Main function to fix all HTML reports"""
    
    print("🔧 Quick Look Fix for HTML Reports")
    print("==================================")
    
    # Find all HTML reports in the cleanup_reports directory
    reports_dir = "cleanup_reports"
    if not os.path.exists(reports_dir):
        print(f"❌ Reports directory '{reports_dir}' not found")
        return
    
    html_files = glob.glob(os.path.join(reports_dir, "*.html"))
    if not html_files:
        print(f"❌ No HTML reports found in '{reports_dir}'")
        return
    
    print(f"📁 Found {len(html_files)} HTML reports")
    print("")
    
    fixed_count = 0
    for html_file in html_files:
        if fix_quicklook_in_html(html_file):
            fixed_count += 1
        print("")
    
    print(f"🎉 Quick Look fix completed!")
    print(f"✅ Fixed {fixed_count} out of {len(html_files)} reports")
    print("")
    print("📋 What the fix does:")
    print("• Quick Look buttons now try to open files in default apps")
    print("• Provides clear instructions for manual Quick Look")
    print("• Offers to copy file paths to clipboard")
    print("• Falls back gracefully if automatic opening fails")
    print("")
    print("💡 To use Quick Look manually:")
    print("1. Click a Quick Look button in any report")
    print("2. Copy the file path when prompted")
    print("3. Open Terminal and run: qlmanage -p \"[file_path]\"")
    print("4. Or right-click the file in Finder and select 'Quick Look'")

if __name__ == "__main__":
    main()

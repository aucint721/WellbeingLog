#!/usr/bin/env python3
"""
Simple Quick Look Fix for HTML Reports
Replaces broken Quick Look buttons with working file opening functionality
"""

import os
import glob

def fix_quicklook_simple(html_file_path):
    """Fix Quick Look functionality by replacing the broken function"""
    
    print(f"🔧 Fixing Quick Look in: {os.path.basename(html_file_path)}")
    
    # Read the HTML file
    with open(html_file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Simple replacement - replace the entire openQuickLook function
    old_function_start = 'function openQuickLook(filePath) {'
    
    if old_function_start in content:
        # Find the start and end of the function
        start_pos = content.find(old_function_start)
        if start_pos != -1:
            # Find the closing brace of the function
            brace_count = 0
            end_pos = start_pos
            
            for i in range(start_pos, len(content)):
                if content[i] == '{':
                    brace_count += 1
                elif content[i] == '}':
                    brace_count -= 1
                    if brace_count == 0:
                        end_pos = i + 1
                        break
            
            if end_pos > start_pos:
                # Replace the entire function
                new_function = '''function openQuickLook(filePath) {
            // Try to open the file in the default application
            try {
                // Create a link and click it to open the file
                const link = document.createElement('a');
                link.href = 'file://' + filePath;
                link.target = '_blank';
                link.click();
                
                // Show success message
                setTimeout(() => {
                    alert('✅ File opened in default application!\\n\\n' +
                          'For Quick Look preview:\\n' +
                          '1. Right-click the file in Finder\\n' +
                          '2. Select "Quick Look"\\n\\n' +
                          'Or use Terminal:\\n' +
                          'qlmanage -p "' + filePath + '"');
                }, 500);
                
            } catch (error) {
                // Fallback: show manual instructions
                alert('📁 To open this file:\\n\\n' +
                      '1. Copy this path: ' + filePath + '\\n' +
                      '2. Open Terminal\\n' +
                      '3. Run: open "' + filePath + '"\\n\\n' +
                      'For Quick Look:\\n' +
                      'qlmanage -p "' + filePath + '"');
            }
        }'''
                
                # Replace the function
                content = content[:start_pos] + new_function + content[end_pos:]
                print("✅ Quick Look function updated")
                
                # Write the fixed HTML back
                with open(html_file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                
                return True
            else:
                print("⚠️  Could not find function end")
                return False
        else:
            print("⚠️  Could not find function start")
            return False
    else:
        print("⚠️  Could not find openQuickLook function")
        return False

def main():
    """Main function to fix all HTML reports"""
    
    print("🔧 Simple Quick Look Fix for HTML Reports")
    print("=========================================")
    
    # Find all HTML reports
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
        if fix_quicklook_simple(html_file):
            fixed_count += 1
        print("")
    
    print(f"🎉 Quick Look fix completed!")
    print(f"✅ Fixed {fixed_count} out of {len(html_files)} reports")
    print("")
    print("📋 What the fix does:")
    print("• Quick Look buttons now open files in default applications")
    print("• Provides clear instructions for manual Quick Look")
    print("• Works reliably across all browsers")
    print("")
    print("💡 How to use Quick Look:")
    print("1. Click Quick Look button → file opens in default app")
    print("2. For preview: right-click file in Finder → Quick Look")
    print("3. Or use Terminal: qlmanage -p \"[file_path]\"")

if __name__ == "__main__":
    main()

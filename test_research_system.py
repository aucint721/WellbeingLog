#!/usr/bin/env python3
"""
Test script for Research File Management System
Run this to verify everything is working correctly
"""

import os
import json
from pathlib import Path


def test_python_environment():
    """Test if all required Python packages are available."""
    print("🐍 Testing Python Environment...")
    
    required_packages = [
        'PyPDF2',
        'docx', 
        'bibtexparser',
        'pyzotero',
        'watchdog'
    ]
    
    missing_packages = []
    
    for package in required_packages:
        try:
            __import__(package)
            print(f"  ✅ {package}")
        except ImportError:
            print(f"  ❌ {package} - MISSING")
            missing_packages.append(package)
    
    if missing_packages:
        print(f"\n❌ Missing packages: {', '.join(missing_packages)}")
        print("Install with: pip install " + " ".join(missing_packages))
        return False
    else:
        print("✅ All Python packages available")
        return True

def test_system_tools():
    """Test if required system tools are available."""
    print("\n🔧 Testing System Tools...")
    
    tools = {
        'pdfinfo': 'poppler (brew install poppler)',
        'calibre': 'Calibre (download from calibre-ebook.com)'
    }
    
    missing_tools = []
    
    for tool, install_instruction in tools.items():
        if tool == 'calibre':
            # Check for Calibre in the typical macOS location
            calibre_path = Path("/Applications/calibre.app/Contents/MacOS/calibredb")
            if calibre_path.exists():
                print(f"  ✅ {tool} (found at {calibre_path})")
            else:
                print(f"  ❌ {tool} - MISSING")
                print(f"     Install: {install_instruction}")
                missing_tools.append(tool)
        else:
            if os.system(f"which {tool} > /dev/null 2>&1") == 0:
                print(f"  ✅ {tool}")
            else:
                print(f"  ❌ {tool} - MISSING")
                print(f"     Install: {install_instruction}")
                missing_tools.append(tool)
    
    if missing_tools:
        print(f"\n❌ Missing system tools: {', '.join(missing_tools)}")
        return False
    else:
        print("✅ All system tools available")
        return True

def test_directories():
    """Test if required directories exist and are writable."""
    print("\n📁 Testing Directories...")
    
    directories = [
        "~/Documents/Research",
        "~/Downloads",
        "~/Desktop"
    ]
    
    for directory in directories:
        path = Path(directory).expanduser()
        if path.exists():
            if os.access(path, os.W_OK):
                print(f"  ✅ {directory} (writable)")
            else:
                print(f"  ⚠️  {directory} (exists but not writable)")
        else:
            print(f"  ❌ {directory} (doesn't exist)")
            try:
                path.mkdir(parents=True, exist_ok=True)
                print(f"     Created: {directory}")
            except Exception as e:
                print(f"     Failed to create: {e}")

def test_config_file():
    """Test if configuration file exists and is valid."""
    print("\n⚙️  Testing Configuration...")
    
    config_path = Path("config.json")
    
    if config_path.exists():
        try:
            with open(config_path, 'r') as f:
                config = json.load(f)
            print("  ✅ config.json exists and is valid JSON")
            
            # Check required keys
            required_keys = ['source_directories', 'research_base_dir', 'categories']
            missing_keys = [key for key in required_keys if key not in config]
            
            if missing_keys:
                print(f"  ⚠️  Missing config keys: {', '.join(missing_keys)}")
            else:
                print("  ✅ All required config keys present")
                
        except json.JSONDecodeError:
            print("  ❌ config.json exists but is invalid JSON")
            return False
    else:
        print("  ❌ config.json doesn't exist")
        print("     Run research_file_manager.py to create it")
        return False
    
    return True

def test_hazel_script():
    """Test if Hazel script is executable."""
    print("\n🔧 Testing Hazel Script...")
    
    script_path = Path("hazel_rules.sh")
    
    if script_path.exists():
        if os.access(script_path, os.X_OK):
            print("  ✅ hazel_rules.sh is executable")
        else:
            print("  ❌ hazel_rules.sh exists but is not executable")
            print("     Fix with: chmod +x hazel_rules.sh")
            return False
    else:
        print("  ❌ hazel_rules.sh doesn't exist")
        return False
    
    return True

def test_sample_files():
    """Test with sample files to verify processing works."""
    print("\n📄 Testing Sample File Processing...")
    
    # Create a test PDF file
    test_pdf = Path("test_research_paper.pdf")
    
    if not test_pdf.exists():
        print("  ℹ️  Creating test PDF file...")
        try:
            # Create a simple test PDF using Python
            from reportlab.pdfgen import canvas
            from reportlab.lib.pagesizes import letter
            
            c = canvas.Canvas(str(test_pdf), pagesize=letter)
            c.drawString(100, 750, "Test Research Paper")
            c.drawString(100, 700, "Author: Test Author")
            c.drawString(100, 650, "Year: 2024")
            c.drawString(100, 600, "Title: Sample Research Document")
            c.drawString(100, 550, "This is a test document for the research automation system.")
            c.save()
            print("     Created: test_research_paper.pdf")
        except ImportError:
            print("     Skipping PDF creation (reportlab not available)")
            return True
    
    # Test the research file manager
    try:
        from research_file_manager import ResearchFileManager
        
        manager = ResearchFileManager()
        print("  ✅ ResearchFileManager imported successfully")
        
        # Test basic functionality
        if hasattr(manager, 'extract_metadata'):
            print("  ✅ Metadata extraction method available")
        else:
            print("  ❌ Metadata extraction method missing")
            
    except Exception as e:
        print(f"  ❌ Error importing ResearchFileManager: {e}")
        return False
    
    return True

def main():
    """Run all tests."""
    print("🧪 Research File Management System - System Test")
    print("=" * 60)
    
    tests = [
        ("Python Environment", test_python_environment),
        ("System Tools", test_system_tools),
        ("Directories", test_directories),
        ("Configuration", test_config_file),
        ("Hazel Script", test_hazel_script),
        ("Sample Files", test_sample_files)
    ]
    
    results = []
    
    for test_name, test_func in tests:
        try:
            result = test_func()
            results.append((test_name, result))
        except Exception as e:
            print(f"  ❌ {test_name} test failed with error: {e}")
            results.append((test_name, False))
    
    # Summary
    print("\n" + "=" * 60)
    print("📊 Test Results Summary")
    print("=" * 60)
    
    passed = sum(1 for _, result in results if result)
    total = len(results)
    
    for test_name, result in results:
        status = "✅ PASS" if result else "❌ FAIL"
        print(f"{status} {test_name}")
    
    print(f"\nOverall: {passed}/{total} tests passed")
    
    if passed == total:
        print("🎉 All tests passed! Your system is ready to use.")
        print("\nNext steps:")
        print("1. Configure Hazel rules in the Hazel app")
        print("2. Run: python3 research_file_manager.py --process-all")
        print("3. Start monitoring: python3 research_file_manager.py --watch")
    else:
        print("⚠️  Some tests failed. Please fix the issues above.")
        print("\nCommon fixes:")
        print("- Install missing packages: pip install <package_name>")
        print("- Install system tools: brew install <tool_name>")
        print("- Fix permissions: chmod +x hazel_rules.sh")
        print("- Create config: python3 research_file_manager.py")

if __name__ == "__main__":
    main()

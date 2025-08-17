#!/usr/bin/env python3
"""
Demo script for the File Cleanup Workflow
This script demonstrates the basic functionality of the cleanup system.
"""

import os
import sys
from pathlib import Path

# Add current directory to path to import the workflow module
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

try:
    from file_cleanup_workflow import FileCleanupWorkflow
    print("✅ File Cleanup Workflow module imported successfully")
except ImportError as e:
    print(f"❌ Error importing module: {e}")
    print("Make sure file_cleanup_workflow.py is in the same directory")
    sys.exit(1)

def create_test_files():
    """Create some test files for demonstration."""
    test_dir = Path("test_files")
    test_dir.mkdir(exist_ok=True)
    
    # Create test files with different sizes and ages
    test_files = [
        ("small_file.txt", "This is a small test file", 0),
        ("medium_file.txt", "This is a medium test file" * 1000, 0),
        ("large_file.txt", "This is a large test file" * 100000, 0),
    ]
    
    for filename, content, days_old in test_files:
        file_path = test_dir / filename
        with open(file_path, 'w') as f:
            f.write(content)
        
        # Set file modification time to simulate age
        if days_old > 0:
            import time
            old_time = time.time() - (days_old * 24 * 60 * 60)
            os.utime(file_path, (old_time, old_time))
    
    print(f"✅ Created test files in {test_dir}")
    return test_dir

def run_demo():
    """Run the demo workflow."""
    print("🚀 Starting File Cleanup Workflow Demo")
    print("=" * 50)
    
    # Create test files
    test_dir = create_test_files()
    
    # Initialize the workflow
    print("\n📋 Initializing File Cleanup Workflow...")
    workflow = FileCleanupWorkflow()
    
    # Run a quick scan on test directory
    print(f"\n🔍 Scanning test directory: {test_dir}")
    try:
        report = workflow.run_cleanup_workflow([str(test_dir)])
        print("✅ Scan completed successfully!")
        
        # Show summary
        print(f"\n📊 Scan Summary:")
        print(f"   Total files: {report['total_files']}")
        print(f"   Total size: {report['total_size_human']}")
        print(f"   Potential savings: {report['potential_savings_human']}")
        
        # Show categories
        for category_name, category_data in report['categories'].items():
            if category_data['count'] > 0:
                print(f"   {category_name.replace('_', ' ').title()}: {category_data['count']} files")
        
        print(f"\n📁 Reports generated in: cleanup_reports/")
        print(f"🔧 Shortcuts workflow created in: shortcuts_workflows/")
        
    except Exception as e:
        print(f"❌ Error during scan: {e}")
        return False
    
    # Clean up test files
    print(f"\n🧹 Cleaning up test files...")
    import shutil
    shutil.rmtree(test_dir)
    print("✅ Test files removed")
    
    return True

def show_usage():
    """Show usage examples."""
    print("\n📖 Usage Examples:")
    print("=" * 30)
    print("1. Quick scan of common directories:")
    print("   python3 file_cleanup_workflow.py --quick-scan")
    print()
    print("2. Create Shortcuts workflow files:")
    print("   python3 file_cleanup_workflow.py --create-shortcuts")
    print()
    print("3. Scan specific directories:")
    print("   python3 file_cleanup_workflow.py --directories ~/Downloads ~/Desktop")
    print()
    print("4. Full workflow with all directories:")
    print("   python3 file_cleanup_workflow.py")
    print()
    print("5. Get help:")
    print("   python3 file_cleanup_workflow.py --help")

def main():
    """Main demo function."""
    print("🎯 File Cleanup Workflow - Demo Mode")
    print("This demo will create test files and run a sample scan.")
    print()
    
    # Check if user wants to run demo
    response = input("Run the demo? (y/n): ").lower().strip()
    if response not in ['y', 'yes']:
        print("Demo skipped. Use --help for usage information.")
        show_usage()
        return
    
    # Run the demo
    if run_demo():
        print("\n🎉 Demo completed successfully!")
        print("\nNext steps:")
        print("1. Check the generated reports in cleanup_reports/")
        print("2. Import the Shortcuts workflow into the Shortcuts app")
        print("3. Customize the configuration in cleanup_config.json")
        print("4. Run regular scans on your actual directories")
    else:
        print("\n❌ Demo failed. Check the error messages above.")
    
    show_usage()

if __name__ == "__main__":
    main()

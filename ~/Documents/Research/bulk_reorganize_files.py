#!/usr/bin/env python3
"""
Bulk File Reorganization Script
Analyzes and reorganizes all existing files in your system.
"""

import os
import sys
import json
import shutil
from pathlib import Path
from datetime import datetime

def analyze_and_reorganize_files(base_directory):
    """Analyze and reorganize all files in the given directory."""
    try:
        print(f"🔍 Analyzing files in: {base_directory}")
        
        # Load configuration
        config = load_config()
        
        # Track statistics
        stats = {
            'total_files': 0,
            'processed_files': 0,
            'moved_files': 0,
            'errors': 0,
            'file_types': {}
        }
        
        # Walk through all files
        for root, dirs, files in os.walk(base_directory):
            # Skip certain directories
            if any(skip_dir in root for skip_dir in ['.git', 'node_modules', '__pycache__', '.DS_Store']):
                continue
                
            for file in files:
                if file.startswith('.'):  # Skip hidden files
                    continue
                    
                file_path = os.path.join(root, file)
                stats['total_files'] += 1
                
                # Determine file type
                file_type = get_file_type(file_path)
                if file_type not in stats['file_types']:
                    stats['file_types'][file_type] = 0
                stats['file_types'][file_type] += 1
                
                print(f"📁 Processing: {file_path}")
                
                try:
                    # Process the file
                    if process_existing_file(file_path, config):
                        stats['processed_files'] += 1
                        stats['moved_files'] += 1
                    else:
                        stats['processed_files'] += 1
                        
                except Exception as e:
                    print(f"❌ Error processing {file_path}: {e}")
                    stats['errors'] += 1
        
        # Print summary
        print_summary(stats)
        
    except Exception as e:
        print(f"❌ Error during bulk reorganization: {e}")

def process_existing_file(file_path, config):
    """Process a single existing file and move it to correct location."""
    try:
        filename = os.path.basename(file_path)
        extension = Path(file_path).suffix.lower()
        
        # Determine where this file should go
        target_location = determine_target_location(file_path, config)
        
        if target_location and target_location != os.path.dirname(file_path):
            # File needs to be moved
            print(f"🔄 Moving: {filename}")
            print(f"   From: {os.path.dirname(file_path)}")
            print(f"   To: {target_location}")
            
            # Create target directory
            os.makedirs(target_location, exist_ok=True)
            
            # Move file
            target_path = os.path.join(target_location, filename)
            
            # Handle filename conflicts
            if os.path.exists(target_path):
                target_path = generate_unique_filename(target_path)
            
            shutil.move(file_path, target_path)
            print(f"✅ Moved to: {target_path}")
            return True
            
        else:
            print(f"✅ File already in correct location: {filename}")
            return False
            
    except Exception as e:
        print(f"❌ Error processing file {file_path}: {e}")
        return False

def determine_target_location(file_path, config):
    """Determine where a file should be located based on its content and type."""
    try:
        filename = os.path.basename(file_path)
        extension = Path(file_path).suffix.lower()
        
        # Check if it's a research document with course context
        if extension in ['.pdf', '.doc', '.docx', '.rtf', '.txt', '.md']:
            course_info = detect_course_context(filename, config)
            if course_info and course_info['course_name'] != 'General Research':
                # Course-specific organization
                year = datetime.now().year
                target_dir = os.path.expanduser(f'~/Documents/Research/Organized_Research/{course_info["course_name"]}/{year}')
                return target_dir
        
        # Type-based organization
        if extension in ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.svg', '.heic']:
            date_folder = datetime.now().strftime('%Y/%m')
            target_dir = os.path.expanduser(f'~/Documents/Research/Archives/By_Type/Images/{date_folder}')
            return target_dir
            
        elif extension in ['.mp3', '.wav', '.m4a', '.aac']:
            target_dir = os.path.expanduser(f'~/Documents/Research/Projects/Audio_Transcription/{datetime.now().strftime("%Y%m%d")}')
            return target_dir
            
        elif extension in ['.tex', '.bib']:
            project_name = extract_project_name(filename)
            target_dir = os.path.expanduser(f'~/Documents/Research/Projects/{project_name}/Writing')
            return target_dir
            
        elif extension in ['.py', '.js', '.html', '.css', '.java', '.cpp', '.c', '.swift', '.sh', '.sql']:
            project_name = extract_project_name(filename)
            target_dir = os.path.expanduser(f'~/Documents/Research/Projects/Development/{project_name}/src')
            return target_dir
            
        elif extension in ['.epub', '.mobi', '.azw3']:
            target_dir = os.path.expanduser('~/Documents/Research/Archives/By_Type/E-books')
            return target_dir
            
        elif extension in ['.xlsx', '.xls', '.csv']:
            target_dir = os.path.expanduser('~/Documents/Research/Archives/By_Type/Spreadsheets')
            return target_dir
            
        elif extension in ['.pptx', '.ppt', '.key']:
            target_dir = os.path.expanduser('~/Documents/Research/Archives/By_Type/Presentations')
            return target_dir
            
        elif extension in ['.zip', '.rar', '.7z', '.tar', '.gz']:
            target_dir = os.path.expanduser('~/Documents/Research/Archives/By_Type/Archives')
            return target_dir
        
        # Default: keep in current location
        return None
        
    except Exception as e:
        print(f"⚠️ Error determining target location: {e}")
        return None

def detect_course_context(filename, config):
    """Detect course context from filename."""
    try:
        filename_lower = filename.lower()
        
        # Check each course
        for course_code, course_data in config.get('course_details', {}).items():
            # Check course code
            if course_code.lower() in filename_lower:
                return {
                    'course_name': course_code,
                    'course_title': course_data.get('title', course_code),
                    'collection_key': course_data.get('collection_key'),
                    'confidence': 'high'
                }
            
            # Check course number
            course_number = course_code.split()[-1]
            if course_number in filename_lower:
                return {
                    'course_name': course_code,
                    'course_title': course_data.get('title', course_code),
                    'collection_key': course_data.get('collection_key'),
                    'confidence': 'medium'
                }
        
        return None
        
    except Exception as e:
        print(f"⚠️ Error detecting course context: {e}")
        return None

def get_file_type(file_path):
    """Get the type/category of a file."""
    extension = Path(file_path).suffix.lower()
    
    if extension in ['.pdf', '.doc', '.docx', '.rtf', '.txt', '.md']:
        return 'Documents'
    elif extension in ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.svg', '.heic']:
        return 'Images'
    elif extension in ['.mp3', '.wav', '.m4a', '.aac', '.mp4', '.mov', '.avi', '.mkv']:
        return 'Media'
    elif extension in ['.tex', '.bib']:
        return 'LaTeX'
    elif extension in ['.py', '.js', '.html', '.css', '.java', '.cpp', '.c', '.swift', '.sh', '.sql']:
        return 'Code'
    elif extension in ['.epub', '.mobi', '.azw3']:
        return 'E-books'
    elif extension in ['.xlsx', '.xls', '.csv']:
        return 'Spreadsheets'
    elif extension in ['.pptx', '.ppt', '.key']:
        return 'Presentations'
    elif extension in ['.zip', '.rar', '.7z', '.tar', '.gz']:
        return 'Archives'
    else:
        return 'Other'

def extract_project_name(filename):
    """Extract project name from filename."""
    base_name = os.path.splitext(filename)[0]
    
    # Remove common prefixes
    base_name = base_name.replace('thesis_', '').replace('paper_', '').replace('research_', '')
    
    # Convert to title case
    return base_name.replace('_', ' ').title()

def generate_unique_filename(target_path):
    """Generate a unique filename if target already exists."""
    base_path = os.path.splitext(target_path)[0]
    extension = Path(target_path).suffix
    counter = 1
    
    while os.path.exists(target_path):
        target_path = f"{base_path}_{counter}{extension}"
        counter += 1
    
    return target_path

def load_config():
    """Load configuration from JSON file."""
    config_path = os.path.expanduser('~/Documents/Research/config.json')
    
    try:
        with open(config_path, 'r') as f:
            return json.load(f)
    except Exception as e:
        print(f"⚠️ Failed to load config: {e}")
        return {}

def print_summary(stats):
    """Print reorganization summary."""
    print("\n" + "="*60)
    print("📊 BULK REORGANIZATION SUMMARY")
    print("="*60)
    print(f"📁 Total files found: {stats['total_files']}")
    print(f"✅ Files processed: {stats['processed_files']}")
    print(f"🔄 Files moved: {stats['moved_files']}")
    print(f"❌ Errors: {stats['errors']}")
    
    print("\n📈 File types found:")
    for file_type, count in stats['file_types'].items():
        print(f"   {file_type}: {count}")
    
    print("\n🎯 Next steps:")
    print("1. Review the moved files")
    print("2. Set up Hazel rules to monitor organized folders")
    print("3. Enjoy automatic future organization!")

def main():
    """Main function."""
    if len(sys.argv) > 1:
        base_directory = sys.argv[1]
    else:
        base_directory = os.path.expanduser('~/Documents/Research')
    
    print("🚀 Bulk File Reorganization Tool")
    print("="*50)
    print(f"Target directory: {base_directory}")
    print("This will analyze and reorganize all files in the directory.")
    
    response = input("\nContinue? (y/N): ").strip().lower()
    if response != 'y':
        print("Operation cancelled.")
        return
    
    analyze_and_reorganize_files(base_directory)

if __name__ == "__main__":
    main()


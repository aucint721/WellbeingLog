#!/usr/bin/env python3
"""
Enhanced Research Workflow Automation System
Automatically categorizes research files into Zotero collections based on course context.
"""

import os
import sys
import json
import requests
import re
from pathlib import Path
from datetime import datetime

def process_research_file(file_path):
    """Process a single research file through the enhanced workflow."""
    try:
        file_path = os.path.expanduser(file_path)
        if not os.path.exists(file_path):
            print(f"❌ File not found: {file_path}")
            return False
        
        print(f"🔬 Processing research file: {file_path}")
        
        # Load configuration
        config = load_config()
        
        # Determine course context and collection
        course_info = determine_course_context(file_path, config)
        
        # Upload to Zotero with proper collection
        zotero_id = upload_to_zotero(file_path, config, course_info)
        
        # Organize file into course-specific folder
        organized_path = organize_file_by_course(file_path, course_info)
        
        # Create enhanced research summary
        create_research_summary(file_path, course_info, zotero_id)
        
        print(f"✅ Successfully processed: {file_path}")
        print(f"📚 Course: {course_info['course_name']}")
        print(f"🏷️ Collection: {course_info['collection_name']}")
        return True
        
    except Exception as e:
        print(f"❌ Error processing research file {file_path}: {e}")
        return False

def determine_course_context(file_path, config):
    """Determine which course the file belongs to based on filename and content."""
    filename = os.path.basename(file_path).lower()
    
    # Course detection patterns
    course_patterns = {
        'EDSP 505': [
            r'edsp\s*505', r'505', r'behavior', r'classroom', r'management',
            r'discipline', r'intervention', r'positive\s*behavior'
        ],
        'EDSP 554': [
            r'edsp\s*554', r'554', r'assessment', r'evaluation', r'measurement',
            r'testing', r'data\s*collection', r'progress\s*monitoring'
        ],
        'EDSP 552': [
            r'edsp\s*552', r'552', r'curriculum', r'instruction', r'teaching',
            r'lesson\s*plan', r'educational\s*materials', r'pedagogy'
        ],
        'EDCX 513': [
            r'edcx\s*513', r'513', r'research', r'methodology', r'statistics',
            r'analysis', r'literature\s*review', r'academic\s*writing'
        ]
    }
    
    # Check filename for course indicators
    for course_name, patterns in course_patterns.items():
        for pattern in patterns:
            if re.search(pattern, filename, re.IGNORECASE):
                collection_key = config['zotero']['collections'][course_name]
                return {
                    'course_name': course_name,
                    'collection_key': collection_key,
                    'collection_name': course_name,
                    'confidence': 'high'
                }
    
    # If no specific course detected, use default collection
    return {
        'course_name': 'General Research',
        'collection_key': None,
        'collection_name': 'General Research',
        'confidence': 'low'
    }

def upload_to_zotero(file_path, config, course_info):
    """Upload research file to Zotero with proper collection assignment."""
    try:
        if not config['zotero']['enabled']:
            print("ℹ️ Zotero integration disabled")
            return None
        
        api_key = config['zotero']['api_key']
        library_id = config['zotero']['library_id']
        library_type = config['zotero']['library_type']
        
        base_url = f"https://api.zotero.org/{library_type}s/{library_id}"
        headers = {
            'Zotero-API-Key': api_key,
            'Content-Type': 'application/json'
        }
        
        # Prepare item data with course context
        filename = os.path.basename(file_path)
        item_data = {
            'itemType': 'attachment',
            'title': filename,
            'filename': filename,
            'tags': [
                'auto_imported',
                'research_workflow',
                f"course:{course_info['course_name']}",
                f"confidence:{course_info['confidence']}"
            ]
        }
        
        # Add course-specific tags
        if course_info['course_name'] != 'General Research':
            item_data['tags'].extend([
                'course_material',
                'academic',
                'education'
            ])
        
        print(f"📤 Uploading to Zotero: {filename}")
        print(f"🏷️ Course: {course_info['course_name']}")
        
        # Create the item
        item_response = requests.post(
            f"{base_url}/items",
            headers=headers,
            json=item_data
        )
        
        if item_response.status_code != 200:
            print(f"❌ Failed to create Zotero item: {item_response.text}")
            return None
        
        item = item_response.json()
        item_key = item['key']
        
        # Upload the file attachment
        with open(file_path, 'rb') as f:
            file_data = f.read()
        
        file_response = requests.post(
            f"{base_url}/items/{item_key}/file",
            headers={'Zotero-API-Key': api_key},
            data=file_data
        )
        
        if file_response.status_code != 200:
            print(f"❌ Failed to upload file to Zotero: {file_response.text}")
            return None
        
        # Add to specific collection if course was detected
        if course_info['collection_key']:
            collection_response = requests.post(
                f"{base_url}/collections/{course_info['collection_key']}/items",
                headers=headers,
                json=[item_key]
            )
            
            if collection_response.status_code == 200:
                print(f"✅ Added to {course_info['course_name']} collection")
            else:
                print(f"⚠️ Could not add to collection: {collection_response.status_code}")
        
        print(f"✅ Successfully uploaded to Zotero: {item_key}")
        return item_key
        
    except Exception as e:
        print(f"⚠️ Error uploading to Zotero: {e}")
        return None

def organize_file_by_course(file_path, course_info):
    """Organize file into course-specific folder structure."""
    try:
        base_dir = os.path.expanduser('~/Documents/Research/Organized_Research')
        year = datetime.now().year
        
        # Create course-specific path
        if course_info['course_name'] != 'General Research':
            organized_dir = os.path.join(base_dir, course_info['course_name'], str(year))
        else:
            organized_dir = os.path.join(base_dir, 'General_Research', str(year))
        
        os.makedirs(organized_dir, exist_ok=True)
        
        # Generate organized filename
        filename = os.path.basename(file_path)
        organized_filename = generate_organized_filename(filename)
        organized_path = os.path.join(organized_dir, organized_filename)
        
        # Move file to organized location
        if os.path.exists(file_path):
            os.rename(file_path, organized_path)
            print(f"📁 File organized to: {organized_path}")
            return organized_path
        
        return None
        
    except Exception as e:
        print(f"⚠️ Error organizing file: {e}")
        return None

def generate_organized_filename(filename):
    """Generate an organized filename for the research file."""
    # Extract meaningful parts from filename
    base_name = os.path.splitext(filename)[0]
    extension = Path(filename).suffix
    
    # Remove common prefixes/suffixes
    base_name = re.sub(r'^(download|file|document|paper|research)_*', '', base_name, flags=re.IGNORECASE)
    base_name = re.sub(r'_*(download|file|document|paper|research)$', '', base_name, flags=re.IGNORECASE)
    
    # Clean up underscores and dashes
    base_name = re.sub(r'[_-]+', '_', base_name)
    base_name = base_name.strip('_')
    
    # Add timestamp if filename is generic
    if base_name.lower() in ['untitled', 'document', 'file', 'download']:
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        base_name = f"research_{timestamp}"
    
    return f"{base_name}{extension}"

def create_research_summary(file_path, course_info, zotero_id=None):
    """Create an enhanced research summary with course context."""
    try:
        summary_dir = os.path.expanduser('~/Documents/Research/Research_Summaries')
        os.makedirs(summary_dir, exist_ok=True)
        
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        summary_file = os.path.join(summary_dir, f"research_summary_{timestamp}.json")
        
        summary = {
            'timestamp': timestamp,
            'original_file': file_path,
            'course_info': course_info,
            'zotero_item_id': zotero_id,
            'processing_status': 'completed',
            'auto_categorization': True
        }
        
        with open(summary_file, 'w') as f:
            json.dump(summary, f, indent=2)
        
        print(f"📋 Enhanced research summary created: {summary_file}")
        
    except Exception as e:
        print(f"⚠️ Error creating research summary: {e}")

def load_config():
    """Load configuration from JSON file."""
    config_path = os.path.expanduser('~/Documents/Research/config.json')
    
    try:
        with open(config_path, 'r') as f:
            config = json.load(f)
        return config
    except Exception as e:
        print(f"⚠️ Failed to load config: {e}")
        return get_default_config()

def get_default_config():
    """Get default configuration if config file is missing."""
    return {
        'zotero': {
            'api_key': 'YOUR_API_KEY',
            'library_id': 'YOUR_LIBRARY_ID',
            'enabled': False,
            'collections': {}
        }
    }

def main():
    """Main function to run the enhanced research workflow automation."""
    try:
        # Process command line arguments
        if len(sys.argv) > 1:
            if sys.argv[1] == '--process':
                # Process a specific file
                file_path = sys.argv[2]
                success = process_research_file(file_path)
                if success:
                    print(f"✅ Successfully processed: {file_path}")
                else:
                    print(f"❌ Failed to process: {file_path}")
                    sys.exit(1)
            elif sys.argv[1] == '--help':
                print_help()
            else:
                print(f"Unknown argument: {sys.argv[1]}")
                print_help()
                sys.exit(1)
        else:
            # Interactive mode
            print("🔬 Enhanced Research Workflow Automation System")
            print("=" * 60)
            print("1. Process a specific file")
            print("2. Exit")
            
            choice = input("\nSelect an option (1-2): ").strip()
            
            if choice == '1':
                file_path = input("Enter file path: ").strip()
                success = process_research_file(file_path)
                if success:
                    print(f"✅ Successfully processed: {file_path}")
                else:
                    print(f"❌ Failed to process: {file_path}")
            elif choice == '2':
                print("Goodbye!")
            else:
                print("Invalid choice")
    
    except KeyboardInterrupt:
        print("\n\n👋 Enhanced research workflow automation stopped")
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)

def print_help():
    """Print help information."""
    print("🔬 Enhanced Research Workflow Automation System")
    print("=" * 60)
    print("Usage:")
    print("  python enhanced_research_workflow.py --process <file_path>")
    print("  python enhanced_research_workflow.py --help")
    print("  python enhanced_research_workflow.py (interactive mode)")
    print("\nEnhanced Features:")
    print("  • Automatic course detection and categorization")
    print("  • Smart Zotero collection assignment")
    print("  • Course-specific folder organization")
    print("  • Enhanced metadata and tagging")
    print("  • Intelligent file naming and organization")

if __name__ == "__main__":
    main()

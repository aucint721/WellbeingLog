#!/usr/bin/env python3
"""
Intelligent Research Workflow Automation System
Uses actual course titles and keywords for highly accurate categorization.
"""

import os
import sys
import json
import requests
import re
from pathlib import Path
from datetime import datetime

def process_research_file(file_path):
    """Process a single research file through the intelligent workflow."""
    try:
        file_path = os.path.expanduser(file_path)
        if not os.path.exists(file_path):
            print(f"❌ File not found: {file_path}")
            return False
        
        print(f"🔬 Processing research file: {file_path}")
        
        # Load configuration
        config = load_config()
        
        # Determine course context with enhanced detection
        course_info = intelligent_course_detection(file_path, config)
        
        # Upload to Zotero with proper collection
        zotero_id = upload_to_zotero(file_path, config, course_info)
        
        # Organize file into course-specific folder
        organized_path = organize_file_by_course(file_path, course_info)
        
        # Create enhanced research summary
        create_research_summary(file_path, course_info, zotero_id)
        
        print(f"✅ Successfully processed: {file_path}")
        print(f"📚 Course: {course_info['course_name']}")
        print(f"📖 Title: {course_info['course_title']}")
        print(f"🏷️ Collection: {course_info['collection_name']}")
        print(f"🎯 Confidence: {course_info['confidence']}")
        return True
        
    except Exception as e:
        print(f"❌ Error processing research file {file_path}: {e}")
        return False

def intelligent_course_detection(file_path, config):
    """Intelligent course detection using actual course titles and keywords."""
    filename = os.path.basename(file_path).lower()
    file_content = extract_file_content(file_path)
    
    # Combine filename and content for analysis
    search_text = f"{filename} {file_content}".lower()
    
    course_scores = {}
    
    # Analyze each course
    for course_code, course_data in config['course_details'].items():
        score = 0
        matched_keywords = []
        
        # Check course code
        if course_code.lower() in search_text:
            score += 10
            matched_keywords.append(course_code)
        
        # Check course number
        course_number = course_code.split()[-1]
        if course_number in search_text:
            score += 5
            matched_keywords.append(course_number)
        
        # Check course title keywords
        title_words = course_data['title'].lower().split()
        for word in title_words:
            if len(word) > 3 and word in search_text:  # Only meaningful words
                score += 2
                matched_keywords.append(word)
        
        # Check specific keywords
        for keyword in course_data['keywords']:
            if keyword.lower() in search_text:
                score += 3
                matched_keywords.append(keyword)
        
        course_scores[course_code] = {
            'score': score,
            'matched_keywords': matched_keywords,
            'course_data': course_data
        }
    
    # Find the best match
    best_course = max(course_scores.items(), key=lambda x: x[1]['score'])
    best_course_code = best_course[0]
    best_course_info = best_course[1]
    
    # Determine confidence level
    if best_course_info['score'] >= 15:
        confidence = 'very_high'
    elif best_course_info['score'] >= 10:
        confidence = 'high'
    elif best_course_info['score'] >= 5:
        confidence = 'medium'
    else:
        confidence = 'low'
        best_course_code = 'General Research'
        best_course_info = {
            'course_data': {
                'title': 'General Research',
                'collection_key': None
            }
        }
    
    return {
        'course_name': best_course_code,
        'course_title': best_course_info['course_data']['title'],
        'collection_key': best_course_info['course_data']['collection_key'],
        'collection_name': best_course_code,
        'confidence': confidence,
        'score': best_course_info['score'],
        'matched_keywords': best_course_info['matched_keywords']
    }

def extract_file_content(file_path):
    """Extract text content from file for better analysis."""
    try:
        extension = Path(file_path).suffix.lower()
        
        if extension == '.pdf':
            # Try to extract text from PDF
            try:
                result = os.system(f"pdftotext '{file_path}' - 2>/dev/null")
                if result == 0:
                    with open(file_path.replace('.pdf', '.txt'), 'r') as f:
                        return f.read()[:1000]  # First 1000 characters
            except:
                pass
        
        elif extension in ['.doc', '.docx']:
            # Try to extract text from Word documents
            try:
                result = os.system(f"textutil -convert txt -stdout '{file_path}' 2>/dev/null")
                if result == 0:
                    return result[:1000]  # First 1000 characters
            except:
                pass
        
        elif extension in ['.txt', '.md']:
            # Read text files directly
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    return f.read()[:1000]  # First 1000 characters
            except:
                pass
        
        return ""
        
    except Exception:
        return ""

def upload_to_zotero(file_path, config, course_info):
    """Upload research file to Zotero with enhanced metadata."""
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
        
        # Prepare enhanced item data
        filename = os.path.basename(file_path)
        item_data = {
            'itemType': 'attachment',
            'title': filename,
            'filename': filename,
            'tags': [
                'auto_imported',
                'research_workflow',
                f"course:{course_info['course_name']}",
                f"confidence:{course_info['confidence']}",
                f"score:{course_info['score']}"
            ]
        }
        
        # Add course-specific tags
        if course_info['course_name'] != 'General Research':
            item_data['tags'].extend([
                'course_material',
                'academic',
                'education',
                course_info['course_name'].lower().replace(' ', '_')
            ])
            
            # Add matched keywords as tags
            for keyword in course_info['matched_keywords']:
                item_data['tags'].append(f"keyword:{keyword}")
        
        print(f"📤 Uploading to Zotero: {filename}")
        print(f"🏷️ Course: {course_info['course_name']}")
        print(f"📖 Title: {course_info['course_title']}")
        print(f"🎯 Keywords matched: {', '.join(course_info['matched_keywords'])}")
        
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
        organized_filename = generate_organized_filename(filename, course_info)
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

def generate_organized_filename(filename, course_info):
    """Generate an organized filename with course context."""
    # Extract meaningful parts from filename
    base_name = os.path.splitext(filename)[0]
    extension = Path(filename).suffix
    
    # Remove common prefixes/suffixes
    base_name = re.sub(r'^(download|file|document|paper|research)_*', '', base_name, flags=re.IGNORECASE)
    base_name = re.sub(r'_*(download|file|document|paper|research)$', '', base_name, flags=re.IGNORECASE)
    
    # Clean up underscores and dashes
    base_name = re.sub(r'[_-]+', '_', base_name)
    base_name = base_name.strip('_')
    
    # Add course prefix if course was detected
    if course_info['course_name'] != 'General Research':
        course_code = course_info['course_name'].replace(' ', '_')
        base_name = f"{course_code}_{base_name}"
    
    # Add timestamp if filename is generic
    if base_name.lower() in ['untitled', 'document', 'file', 'download']:
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        base_name = f"research_{timestamp}"
    
    return f"{base_name}{extension}"

def create_research_summary(file_path, course_info, zotero_id=None):
    """Create an intelligent research summary with enhanced course context."""
    try:
        summary_dir = os.path.expanduser('~/Documents/Research/Research_Summaries')
        os.makedirs(summary_dir, exist_ok=True)
        
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        summary_file = os.path.join(summary_dir, f"intelligent_research_summary_{timestamp}.json")
        
        summary = {
            'timestamp': timestamp,
            'original_file': file_path,
            'course_info': course_info,
            'zotero_item_id': zotero_id,
            'processing_status': 'completed',
            'intelligent_categorization': True,
            'detection_score': course_info['score'],
            'matched_keywords': course_info['matched_keywords']
        }
        
        with open(summary_file, 'w') as f:
            json.dump(summary, f, indent=2)
        
        print(f"📋 Intelligent research summary created: {summary_file}")
        
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
        },
        'course_details': {}
    }

def main():
    """Main function to run the intelligent research workflow automation."""
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
            print("🧠 Intelligent Research Workflow Automation System")
            print("=" * 70)
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
        print("\n\n👋 Intelligent research workflow automation stopped")
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)

def print_help():
    """Print help information."""
    print("🧠 Intelligent Research Workflow Automation System")
    print("=" * 70)
    print("Usage:")
    print("  python intelligent_research_workflow.py --process <file_path>")
    print("  python intelligent_research_workflow.py --help")
    print("  python intelligent_research_workflow.py (interactive mode)")
    print("\nIntelligent Features:")
    print("  • Actual course titles and keywords for detection")
    print("  • Content analysis for better categorization")
    print("  • Confidence scoring and detailed matching")
    print("  • Enhanced metadata and tagging")
    print("  • Course-specific organization")

if __name__ == "__main__":
    main()

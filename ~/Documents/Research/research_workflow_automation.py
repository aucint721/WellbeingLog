#!/usr/bin/env python3
"""
Research Workflow Automation System
Automates Zotero integration, metadata extraction, and Calibre archiving
for research materials that Zotero doesn't automatically capture.
"""

import os
import sys
import json
import subprocess
import requests
from pathlib import Path
from datetime import datetime
import re

def process_research_file(file_path):
    """Process a single research file through the complete workflow."""
    try:
        file_path = os.path.expanduser(file_path)
        if not os.path.exists(file_path):
            print(f"❌ File not found: {file_path}")
            return False
        
        print(f"🔬 Processing research file: {file_path}")
        
        # Step 1: Extract metadata
        metadata = extract_file_metadata(file_path)
        
        # Step 2: Upload to Zotero
        zotero_item_id = upload_to_zotero(file_path, metadata)
        
        # Step 3: Archive to Calibre
        calibre_id = archive_to_calibre(file_path, metadata)
        
        # Step 4: Move to organized research folder
        organized_path = organize_research_file(file_path, metadata)
        
        # Step 5: Create research summary
        create_research_summary(file_path, metadata, zotero_item_id, calibre_id)
        
        print(f"✅ Successfully processed: {file_path}")
        return True
        
    except Exception as e:
        print(f"❌ Error processing research file {file_path}: {e}")
        return False

def extract_file_metadata(file_path):
    """Extract comprehensive metadata from research files."""
    try:
        extension = Path(file_path).suffix.lower().lstrip('.')
        metadata = {
            'filename': os.path.basename(file_path),
            'filepath': file_path,
            'extension': extension,
            'size': os.path.getsize(file_path),
            'modified': datetime.fromtimestamp(os.path.getmtime(file_path)).isoformat(),
            'created': datetime.fromtimestamp(os.path.getctime(file_path)).isoformat()
        }
        
        # Extract specific metadata based on file type
        if extension == 'pdf':
            metadata.update(extract_pdf_metadata(file_path))
        elif extension in ['epub', 'mobi']:
            metadata.update(extract_ebook_metadata(file_path))
        elif extension in ['doc', 'docx']:
            metadata.update(extract_word_metadata(file_path))
        
        return metadata
        
    except Exception as e:
        print(f"⚠️ Error extracting metadata from {file_path}: {e}")
        return {}

def extract_pdf_metadata(file_path):
    """Extract metadata from PDF files."""
    try:
        result = subprocess.run(['pdfinfo', file_path], capture_output=True, text=True)
        if result.returncode == 0:
            metadata = {}
            for line in result.stdout.split('\n'):
                if ':' in line:
                    key, value = line.split(':', 1)
                    metadata[key.strip()] = value.strip()
            return metadata
    except Exception:
        pass
    
    return {'type': 'PDF', 'pages': 'Unknown'}

def extract_ebook_metadata(file_path):
    """Extract metadata from e-book files."""
    try:
        calibre_path = '/Applications/calibre.app/Contents/MacOS'
        ebook_meta = os.path.join(calibre_path, 'ebook-meta')
        
        if os.path.exists(ebook_meta):
            result = subprocess.run([ebook_meta, file_path], capture_output=True, text=True)
            if result.returncode == 0:
                metadata = {}
                for line in result.stdout.split('\n'):
                    if ':' in line:
                        key, value = line.split(':', 1)
                        metadata[key.strip()] = value.strip()
                return metadata
    except Exception:
        pass
    
    return {'type': 'E-book'}

def extract_word_metadata(file_path):
    """Extract metadata from Word documents."""
    try:
        result = subprocess.run(['textutil', '-convert', 'txt', '-stdout', file_path], 
                              capture_output=True, text=True)
        if result.returncode == 0:
            text = result.stdout[:500]  # First 500 characters
            return {
                'type': 'Word Document',
                'preview': text.replace('\n', ' ').strip(),
                'word_count': len(text.split())
            }
    except Exception:
        pass
    
    return {'type': 'Word Document'}

def upload_to_zotero(file_path, metadata):
    """Upload research file to Zotero."""
    try:
        # Load configuration
        config = load_config()
        if not config['zotero']['enabled']:
            print("ℹ️ Zotero integration disabled")
            return None
        
        api_key = config['zotero']['api_key']
        library_id = config['zotero']['library_id']
        library_type = config['zotero']['library_type']
        
        if api_key == 'YOUR_API_KEY' or library_id == 'YOUR_LIBRARY_ID':
            print("⚠️ Zotero API credentials not configured")
            return None
        
        base_url = f"https://api.zotero.org/{library_type}s/{library_id}"
        headers = {
            'Zotero-API-Key': api_key,
            'Content-Type': 'application/json'
        }
        
        # Prepare Zotero item data
        item_data = {
            'itemType': 'attachment',
            'title': metadata.get('title', metadata.get('filename', 'Untitled')),
            'filename': os.path.basename(file_path),
            'contentType': get_content_type(file_path),
            'tags': generate_zotero_tags(metadata)
        }
        
        # Add additional metadata if available
        if 'author' in metadata:
            item_data['creator'] = metadata['author']
        if 'date' in metadata:
            item_data['dateAdded'] = metadata['date']
        
        print(f"📤 Uploading to Zotero: {metadata.get('filename', 'Unknown')}")
        
        # First, create the item
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
        
        # Then, upload the file attachment
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
        
        print(f"✅ Successfully uploaded to Zotero: {item_key}")
        return item_key
        
    except Exception as e:
        print(f"⚠️ Error uploading to Zotero: {e}")
        return None

def archive_to_calibre(file_path, metadata):
    """Archive research file to Calibre."""
    try:
        config = load_config()
        if not config['calibre']['enabled']:
            print("ℹ️ Calibre integration disabled")
            return None
        
        calibre_path = config['calibre']['path']
        calibredb = os.path.join(calibre_path, 'calibredb')
        
        if not os.path.exists(calibredb):
            print("⚠️ Calibre command-line tools not found")
            return None
        
        library_path = os.path.expanduser(config['calibre']['library_path'])
        
        print(f"📚 Adding to Calibre: {metadata.get('filename', 'Unknown')}")
        
        # Add book to Calibre library
        result = subprocess.run([
            calibredb, 'add',
            '--library-path', library_path,
            file_path
        ], capture_output=True, text=True)
        
        if result.returncode == 0:
            # Extract book ID from output
            output_lines = result.stdout.split('\n')
            for line in output_lines:
                if 'Added book id:' in line:
                    book_id = line.split(':')[1].strip()
                    print(f"✅ Added to Calibre: {book_id}")
                    return book_id
        
        print(f"⚠️ Failed to add to Calibre: {result.stderr}")
        return None
        
    except Exception as e:
        print(f"⚠️ Error adding to Calibre: {e}")
        return None

def organize_research_file(file_path, metadata):
    """Organize research file into structured folders."""
    try:
        base_dir = os.path.expanduser('~/Documents/Research/Organized_Research')
        
        # Determine category based on file type and content
        category = determine_research_category(metadata)
        year = datetime.now().year
        
        # Create organized path
        organized_dir = os.path.join(base_dir, category, str(year))
        os.makedirs(organized_dir, exist_ok=True)
        
        # Generate organized filename
        organized_filename = generate_organized_filename(metadata)
        organized_path = os.path.join(organized_dir, organized_filename)
        
        # Move file to organized location
        if os.path.exists(file_path):
            os.rename(file_path, organized_path)
            print(f"📁 File organized to: {organized_path}")
            return organized_path
        
        return None
        
    except Exception as e:
        print(f"⚠️ Error organizing research file: {e}")
        return None

def determine_research_category(metadata):
    """Determine the research category for a file."""
    filename = metadata.get('filename', '').lower()
    extension = metadata.get('extension', '').lower()
    
    # Academic papers and research
    if any(word in filename for word in ['paper', 'research', 'study', 'thesis']):
        return 'Academic_Papers'
    
    # Books and e-books
    if extension in ['epub', 'mobi', 'pdf']:
        return 'Books_Ebooks'
    
    # Reports and documents
    if extension in ['pdf', 'doc', 'docx']:
        return 'Reports_Documents'
    
    # Default category
    return 'General_Research'

def generate_organized_filename(metadata):
    """Generate an organized filename for the research file."""
    filename = metadata.get('filename', 'untitled')
    extension = metadata.get('extension', '')
    
    # Extract meaningful parts from filename
    base_name = os.path.splitext(filename)[0]
    
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
    
    return f"{base_name}.{extension}"

def generate_zotero_tags(metadata):
    """Generate relevant tags for Zotero."""
    tags = ['auto_imported', 'research_workflow']
    
    # Add category-based tags
    category = determine_research_category(metadata)
    tags.append(category.lower().replace('_', ' '))
    
    # Add file type tags
    extension = metadata.get('extension', '')
    if extension:
        tags.append(f"file_type:{extension}")
    
    # Add date tags
    if 'modified' in metadata:
        try:
            date = datetime.fromisoformat(metadata['modified'])
            tags.append(f"year:{date.year}")
            tags.append(f"month:{date.strftime('%B')}")
        except Exception:
            pass
    
    return tags

def get_content_type(file_path):
    """Get MIME content type for file."""
    extension = Path(file_path).suffix.lower()
    
    content_types = {
        '.pdf': 'application/pdf',
        '.doc': 'application/msword',
        '.docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        '.epub': 'application/epub+zip',
        '.mobi': 'application/x-mobipocket-ebook',
        '.txt': 'text/plain',
        '.md': 'text/markdown'
    }
    
    return content_types.get(extension, 'application/octet-stream')

def create_research_summary(file_path, metadata, zotero_id=None, calibre_id=None):
    """Create a summary of the research file processing."""
    try:
        summary_dir = os.path.expanduser('~/Documents/Research/Research_Summaries')
        os.makedirs(summary_dir, exist_ok=True)
        
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        summary_file = os.path.join(summary_dir, f"research_summary_{timestamp}.json")
        
        summary = {
            'timestamp': timestamp,
            'original_file': file_path,
            'metadata': metadata,
            'zotero_item_id': zotero_id,
            'calibre_id': calibre_id,
            'processing_status': 'completed'
        }
        
        with open(summary_file, 'w') as f:
            json.dump(summary, f, indent=2)
        
        print(f"📋 Research summary created: {summary_file}")
        
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
            'enabled': False
        },
        'calibre': {
            'path': '/Applications/calibre.app/Contents/MacOS',
            'library_path': '~/Calibre Library',
            'enabled': True
        }
    }

def main():
    """Main function to run the research workflow automation."""
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
            print("🔬 Research Workflow Automation System")
            print("=" * 50)
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
        print("\n\n👋 Research workflow automation stopped")
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)

def print_help():
    """Print help information."""
    print("🔬 Research Workflow Automation System")
    print("=" * 50)
    print("Usage:")
    print("  python research_workflow_automation.py --process <file_path>")
    print("  python research_workflow_automation.py --help")
    print("  python research_workflow_automation.py (interactive mode)")
    print("\nFeatures:")
    print("  • Automatic Zotero upload for research files")
    print("  • Automatic Calibre archiving with metadata")
    print("  • Smart file organization and naming")
    print("  • Comprehensive metadata extraction")
    print("  • Research summaries for tracking")

if __name__ == "__main__":
    main()

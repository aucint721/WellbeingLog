#!/usr/bin/env python3
"""
Research File Manager - Automated Research File Organization
For Masters of Education Studies

This script automatically organizes research files, extracts metadata,
and integrates with Zotero and Calibre for seamless research management.
"""

import sys
import json
import logging
import shutil
from datetime import datetime
from pathlib import Path
from typing import Dict, Optional
import PyPDF2
from docx import Document
import bibtexparser
from pyzotero import zotero
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import time

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('research_file_manager.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

class ResearchFileManager:
    """Main class for managing research files automatically."""

    def __init__(self, config_path: str = "config.json"):
        """Initialize the research file manager."""
        self.config = self.load_config(config_path)
        self.setup_directories()
        self.zotero_client = self.setup_zotero()
        self.calibre_db_path = self.config.get('calibre_db_path')
        
    def load_config(self, config_path: str) -> Dict:
        """Load configuration from JSON file."""
        try:
            with open(config_path, 'r') as f:
                config = json.load(f)
            logger.info(f"Loaded configuration from {config_path}")
            return config
        except FileNotFoundError:
            logger.warning(f"Config file {config_path} not found, using defaults")
            return self.create_default_config(config_path)
        except json.JSONDecodeError as e:
            logger.error(f"Error parsing config file: {e}")
            return self.create_default_config(config_path)
    
    def create_default_config(self, config_path: str) -> Dict:
        """Create a default configuration file."""
        default_config = {
            "source_directories": [
                "~/Downloads",
                "~/Desktop"
            ],
            "research_base_dir": "~/Documents/Research",
            "categories": {
                "papers": ["pdf", "docx", "doc"],
                "books": ["pdf", "epub", "mobi"],
                "reports": ["pdf", "docx", "doc"],
                "presentations": ["pptx", "ppt", "pdf"],
                "data": ["csv", "xlsx", "json", "sqlite"],
                "unsorted": []
            },
            "zotero": {
                "library_id": "YOUR_LIBRARY_ID",
                "api_key": "YOUR_API_KEY",
                "library_type": "user"
            },
            "calibre_db_path": "~/Calibre Library/metadata.db",
            "file_naming": {
                "use_author_year": True,
                "use_original_name": False,
                "add_timestamp": True
            },
            "metadata_extraction": {
                "extract_pdf_metadata": True,
                "extract_docx_metadata": True,
                "extract_bibtex": True
            },
            "auto_organization": {
                "enabled": True,
                "move_files": True,
                "create_backup": True
            }
        }
        
        try:
            with open(config_path, 'w') as f:
                json.dump(default_config, f, indent=2)
            logger.info(f"Created default config file: {config_path}")
        except Exception as e:
            logger.error(f"Failed to create config file: {e}")
        
        return default_config
    
    def setup_directories(self):
        """Create necessary research directories."""
        base_dir = Path(self.config['research_base_dir']).expanduser()
        
        for category in self.config['categories'].keys():
            category_dir = base_dir / category
            category_dir.mkdir(parents=True, exist_ok=True)
            logger.info(f"Ensured directory exists: {category_dir}")
    
    def setup_zotero(self) -> Optional[zotero.Zotero]:
        """Setup Zotero client if credentials are provided."""
        zotero_config = self.config.get('zotero', {})
        
        if (zotero_config.get('library_id') and
                zotero_config.get('api_key') and
                zotero_config.get('library_type')):
            try:
                client = zotero.Zotero(
                    zotero_config['library_id'],
                    zotero_config['library_type'],
                    zotero_config['api_key']
                )
                logger.info("Zotero client initialized successfully")
                return client
            except Exception as e:
                logger.error(f"Failed to initialize Zotero client: {e}")
                return None
        else:
            logger.warning("Zotero credentials not configured")
            return None
    
    def categorize_file(self, file_path: Path) -> str:
        """Determine the appropriate category for a file."""
        extension = file_path.suffix.lower().lstrip('.')
        
        for category, extensions in self.config['categories'].items():
            if extensions and extension in extensions:
                return category
        
        return 'unsorted'
    
    def extract_metadata(self, file_path: Path) -> Dict:
        """Extract metadata from various file types."""
        metadata = {
            'filename': file_path.name,
            'extension': file_path.suffix.lower(),
            'size': file_path.stat().st_size,
            'modified': datetime.fromtimestamp(file_path.stat().st_mtime),
            'extracted_at': datetime.now()
        }
        
        try:
            if file_path.suffix.lower() == '.pdf':
                metadata.update(self.extract_pdf_metadata(file_path))
            elif file_path.suffix.lower() in ['.docx', '.doc']:
                metadata.update(self.extract_docx_metadata(file_path))
            elif file_path.suffix.lower() == '.bib':
                metadata.update(self.extract_bibtex_metadata(file_path))
            elif file_path.suffix.lower() in ['.png', '.jpg', '.jpeg', '.gif', '.bmp']:
                metadata.update(self.extract_image_metadata(file_path))
            elif file_path.suffix.lower() in ['.mp4', '.mov', '.avi', '.mkv', '.wmv']:
                metadata.update(self.extract_video_metadata(file_path))
            elif file_path.suffix.lower() in ['.epub', '.mobi', '.azw3']:
                metadata.update(self.extract_ebook_metadata(file_path))
        except Exception as e:
            logger.warning(f"Failed to extract metadata from {file_path}: {e}")
        
        return metadata
    
    def extract_pdf_metadata(self, file_path: Path) -> Dict:
        """Extract metadata from PDF files."""
        metadata = {}
        
        try:
            with open(file_path, 'rb') as f:
                pdf_reader = PyPDF2.PdfReader(f)
                
                if pdf_reader.metadata:
                    info = pdf_reader.metadata
                    metadata.update({
                        'title': info.get('/Title', ''),
                        'author': info.get('/Author', ''),
                        'subject': info.get('/Subject', ''),
                        'creator': info.get('/Creator', ''),
                        'producer': info.get('/Producer', ''),
                        'creation_date': info.get('/CreationDate', ''),
                        'modification_date': info.get('/ModDate', ''),
                        'page_count': len(pdf_reader.pages)
                    })
                
                # Try to extract text from first page for better categorization
                if len(pdf_reader.pages) > 0:
                    first_page = pdf_reader.pages[0]
                    text = first_page.extract_text()
                    if text:
                        # First 500 chars
                        metadata['first_page_text'] = text[:500]
                        
        except Exception as e:
            logger.error(f"Error extracting PDF metadata from {file_path}: {e}")
        
        return metadata
    
    def extract_docx_metadata(self, file_path: Path) -> Dict:
        """Extract metadata from DOCX files."""
        metadata = {}
        
        try:
            doc = Document(file_path)
            
            # Extract core properties
            core_props = doc.core_properties
            if core_props:
                metadata.update({
                    'title': core_props.title or '',
                    'author': core_props.author or '',
                    'subject': core_props.subject or '',
                    'keywords': core_props.keywords or '',
                    'created': core_props.created,
                    'modified': core_props.modified,
                    'revision': core_props.revision
                })
            
            # Extract text content for analysis
            full_text = []
            for paragraph in doc.paragraphs:
                if paragraph.text.strip():
                    full_text.append(paragraph.text.strip())
            
            if full_text:
                metadata['text_content'] = '\n'.join(full_text[:10])  # First 10 paragraphs
                
        except Exception as e:
            logger.error(f"Error extracting DOCX metadata from {file_path}: {e}")
        
        return metadata
    
    def extract_bibtex_metadata(self, file_path: Path) -> Dict:
        """Extract metadata from BibTeX files."""
        metadata = {}
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                
            # Parse BibTeX content
            bib_database = bibtexparser.loads(content)
            
            if bib_database.entries:
                # Use first entry as representative
                entry = bib_database.entries[0]
                metadata.update({
                    'entry_type': entry.get('ENTRYTYPE', ''),
                    'citation_key': entry.get('ID', ''),
                    'title': entry.get('title', ''),
                    'author': entry.get('author', ''),
                    'year': entry.get('year', ''),
                    'journal': entry.get('journal', ''),
                    'booktitle': entry.get('booktitle', ''),
                    'publisher': entry.get('publisher', ''),
                    'url': entry.get('url', ''),
                    'doi': entry.get('doi', '')
                })
                
        except Exception as e:
            logger.error(f"Error extracting BibTeX metadata from {file_path}: {e}")
        
        return metadata
    
    def extract_image_metadata(self, file_path: Path) -> Dict:
        """Extract metadata from image files."""
        metadata = {}
        
        try:
            # Use macOS built-in sips command for image metadata
            import subprocess
            result = subprocess.run(['sips', '-g', 'all', str(file_path)], 
                                 capture_output=True, text=True, timeout=10)
            
            if result.returncode == 0:
                output = result.stdout
                # Parse sips output for key metadata
                lines = output.split('\n')
                for line in lines:
                    if 'pixelWidth' in line:
                        metadata['width'] = line.split(':')[-1].strip()
                    elif 'pixelHeight' in line:
                        metadata['height'] = line.split(':')[-1].strip()
                    elif 'format' in line:
                        metadata['format'] = line.split(':')[-1].strip()
                    elif 'dpiWidth' in line:
                        metadata['dpi_width'] = line.split(':')[-1].strip()
                    elif 'dpiHeight' in line:
                        metadata['dpi_height'] = line.split(':')[-1].strip()
                        
        except Exception as e:
            logger.warning(f"Could not extract image metadata from {file_path}: {e}")
        
        return metadata
    
    def extract_video_metadata(self, file_path: Path) -> Dict:
        """Extract metadata from video files."""
        metadata = {}
        
        try:
            # Try to use ffprobe if available
            import subprocess
            result = subprocess.run(['ffprobe', '-v', 'quiet', '-print_format', 'json',
                                   '-show_format', '-show_streams', str(file_path)], 
                                 capture_output=True, text=True, timeout=15)
            
            if result.returncode == 0:
                import json
                probe_data = json.loads(result.stdout)
                
                # Extract format info
                if 'format' in probe_data:
                    format_info = probe_data['format']
                    metadata.update({
                        'duration': format_info.get('duration', ''),
                        'size': format_info.get('size', ''),
                        'bit_rate': format_info.get('bit_rate', ''),
                        'format_name': format_info.get('format_name', '')
                    })
                
                # Extract stream info
                if 'streams' in probe_data:
                    video_streams = [s for s in probe_data['streams'] if s.get('codec_type') == 'video']
                    audio_streams = [s for s in probe_data['streams'] if s.get('codec_type') == 'audio']
                    
                    if video_streams:
                        video = video_streams[0]
                        metadata.update({
                            'video_codec': video.get('codec_name', ''),
                            'video_width': video.get('width', ''),
                            'video_height': video.get('height', ''),
                            'video_fps': video.get('r_frame_rate', '')
                        })
                    
                    if audio_streams:
                        audio = audio_streams[0]
                        metadata.update({
                            'audio_codec': audio.get('codec_name', ''),
                            'audio_channels': audio.get('channels', ''),
                            'audio_sample_rate': audio.get('sample_rate', '')
                        })
                        
        except Exception as e:
            logger.warning(f"Could not extract video metadata from {file_path}: {e}")
        
        return metadata
    
    def generate_filename(self, metadata: Dict, original_name: str) -> str:
        """Generate a standardized filename based on metadata."""
        naming_config = self.config['file_naming']
        
        if naming_config['use_author_year'] and metadata.get('author') and metadata.get('year'):
            # Try to extract author initials and year
            author = metadata['author']
            year = metadata['year']
            
            # Extract initials from author
            if ',' in author:
                # Format: "Last, First"
                last_name = author.split(',')[0].strip()
                initials = ''.join([name[0].upper() for name in author.split(',')[1:] if name.strip()])
                author_part = f"{last_name}_{initials}"
            else:
                # Format: "First Last"
                names = author.split()
                if len(names) >= 2:
                    author_part = f"{names[-1]}_{''.join([n[0].upper() for n in names[:-1]])}"
                else:
                    author_part = author.replace(' ', '_')
            
            filename = f"{author_part}_{year}"
            
            # Add title if available
            if metadata.get('title'):
                title_words = metadata['title'].split()[:3]  # First 3 words
                title_part = '_'.join([word.lower() for word in title_words if word.isalnum()])
                filename += f"_{title_part}"
            
        else:
            # Use original name
            filename = Path(original_name).stem
        
        # Add timestamp if configured
        if naming_config['add_timestamp']:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            filename += f"_{timestamp}"
        
        # Add original extension
        extension = Path(original_name).suffix
        filename += extension
        
        return filename
    
    def organize_file(self, source_path: Path) -> bool:
        """Organize a single file into the appropriate research directory."""
        try:
            # Determine category
            category = self.categorize_file(source_path)
            
            # Extract metadata
            metadata = self.extract_metadata(source_path)
            
            # Generate new filename
            new_filename = self.generate_filename(metadata, source_path.name)
            
            # Determine destination
            base_dir = Path(self.config['research_base_dir']).expanduser()
            category_dir = base_dir / category
            destination_path = category_dir / new_filename
            
            # Handle filename conflicts
            counter = 1
            original_destination = destination_path
            while destination_path.exists():
                stem = original_destination.stem
                suffix = original_destination.suffix
                destination_path = category_dir / f"{stem}_{counter}{suffix}"
                counter += 1
            
            # Move/copy file
            if self.config['auto_organization']['move_files']:
                shutil.move(str(source_path), str(destination_path))
                logger.info(f"Moved file to: {destination_path}")
            else:
                shutil.copy2(str(source_path), str(destination_path))
                logger.info(f"Copied file to: {destination_path}")
            
            # Save metadata
            metadata_file = destination_path.with_suffix('.metadata.json')
            with open(metadata_file, 'w') as f:
                json.dump(metadata, f, indent=2, default=str)
            logger.info(f"Created metadata file: {metadata_file}")
            
            # Add to Zotero if configured
            if self.zotero_client and category in ['papers', 'books']:
                self.add_to_zotero(destination_path, metadata)
            
            # Add to Calibre if configured
            if self.calibre_db_path and category in ['books']:
                self.add_to_calibre(destination_path, metadata)
            
            return True
            
        except Exception as e:
            logger.error(f"Failed to organize file {source_path}: {e}")
            return False
    
    def add_to_zotero(self, file_path: Path, metadata: Dict):
        """Add file to Zotero library."""
        try:
            # Create item data
            item_data = {
                'itemType': 'document',
                'title': metadata.get('title', file_path.stem),
                'creators': [{'creatorType': 'author', 'name': metadata.get('author', 'Unknown')}],
                'date': metadata.get('year', ''),
                'abstractNote': metadata.get('subject', ''),
                'tags': [metadata.get('entry_type', ''), 'auto-imported'],
                'collections': ['Research Files']
            }
            
            # Add item to Zotero
            created_item = self.zotero_client.create_items([item_data])
            
            if created_item:
                # Attach the file
                item_id = created_item[0]['key']
                self.zotero_client.attachment_simple(file_path, item_id)
                logger.info(f"Added to Zotero: {file_path}")
            else:
                logger.warning(f"Failed to create Zotero item for: {file_path}")
                
        except Exception as e:
            logger.error(f"Failed to add {file_path} to Zotero: {e}")
    
    def add_to_calibre(self, file_path: Path, metadata: Dict):
        """Add file to Calibre library using calibredb command-line tool."""
        try:
            if not self.config.get('calibre', {}).get('enabled', False):
                logger.info(f"Calibre integration is disabled")
                return
            
            calibre_path = self.config['calibre']['path']
            calibredb = Path(calibre_path) / 'calibredb'
            
            if not calibredb.exists():
                logger.warning(f"Calibre command-line tool not found at: {calibredb}")
                return
            
            # Use calibredb add command to add the book to Calibre library
            import subprocess
            
            cmd = [
                str(calibredb),
                'add',
                '--library-path', str(Path(self.config['calibre']['library_path']).expanduser()),
                '--title', metadata.get('title', 'Unknown Title'),
                '--authors', metadata.get('author', 'Unknown Author'),
                '--tags', 'Research,Imported',
                str(file_path)
            ]
            
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
            
            if result.returncode == 0:
                logger.info(f"Successfully added {file_path} to Calibre library")
                # Extract the book ID from output for future reference
                if 'Added book id:' in result.stdout:
                    book_id = result.stdout.split('Added book id:')[1].strip().split()[0]
                    logger.info(f"Book ID: {book_id}")
            else:
                logger.warning(f"Calibre add command failed: {result.stderr}")
                
        except Exception as e:
            logger.error(f"Failed to add {file_path} to Calibre: {e}")
    
    def extract_ebook_metadata(self, file_path: Path) -> Dict:
        """Extract metadata from e-book files using Calibre's ebook-meta tool."""
        metadata = {}
        
        try:
            if not self.config.get('calibre', {}).get('enabled', False):
                return metadata
            
            calibre_path = self.config['calibre']['path']
            ebook_meta = Path(calibre_path) / 'ebook-meta'
            
            if not ebook_meta.exists():
                logger.warning(f"ebook-meta tool not found at: {ebook_meta}")
                return metadata
            
            # Use ebook-meta to extract metadata
            import subprocess
            
            cmd = [str(ebook_meta), str(file_path)]
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
            
            if result.returncode == 0:
                output = result.stdout
                lines = output.split('\n')
                
                for line in lines:
                    line = line.strip()
                    if ':' in line:
                        key, value = line.split(':', 1)
                        key = key.strip().lower().replace(' ', '_')
                        value = value.strip()
                        
                        if key == 'title':
                            metadata['title'] = value
                        elif key == 'author(s)':
                            metadata['author'] = value
                        elif key == 'publisher':
                            metadata['publisher'] = value
                        elif key == 'language':
                            metadata['language'] = value
                        elif key == 'tags':
                            metadata['tags'] = value
                        elif key == 'series':
                            metadata['series'] = value
                        elif key == 'published':
                            metadata['year'] = value
                
                logger.info(f"Extracted e-book metadata from {file_path}")
                
        except Exception as e:
            logger.warning(f"Could not extract e-book metadata from {file_path}: {e}")
        
        return metadata
    
    def open_in_bean(self, file_path: Path):
        """Open a document in Bean for writing/editing."""
        try:
            if not self.config.get('writing_tools', {}).get('bean', {}).get('enabled', False):
                logger.info("Bean integration is disabled")
                return False
            
            bean_path = self.config['writing_tools']['bean']['path']
            if not Path(bean_path).exists():
                logger.warning(f"Bean not found at: {bean_path}")
                return False
            
            import subprocess
            subprocess.run(['open', '-a', bean_path, str(file_path)], check=True)
            logger.info(f"Opened {file_path} in Bean")
            return True
            
        except Exception as e:
            logger.error(f"Failed to open {file_path} in Bean: {e}")
            return False
    
    def open_in_texstudio(self, file_path: Path):
        """Open a LaTeX document in TexStudio for editing."""
        try:
            if not self.config.get('writing_tools', {}).get('texstudio', {}).get('enabled', False):
                logger.info("TexStudio integration is disabled")
                return False
            
            texstudio_path = self.config['writing_tools']['texstudio']['path']
            if not Path(texstudio_path).exists():
                logger.warning(f"TexStudio not found at: {texstudio_path}")
                return False
            
            import subprocess
            subprocess.run([texstudio_path, str(file_path)], check=True)
            logger.info(f"Opened {file_path} in TexStudio")
            return True
            
        except Exception as e:
            logger.error(f"Failed to open {file_path} in TexStudio: {e}")
            return False
    
    def compile_latex(self, tex_file: Path) -> bool:
        """Compile a LaTeX document to PDF."""
        try:
            if not self.config.get('writing_tools', {}).get('latex', {}).get('enabled', False):
                logger.info("LaTeX compilation is disabled")
                return False
            
            latex_path = self.config['writing_tools']['latex']['path']
            compiler = self.config['writing_tools']['latex']['compiler']
            
            # Change to the directory containing the tex file
            working_dir = tex_file.parent
            tex_filename = tex_file.name
            
            import subprocess
            
            # Run pdflatex
            cmd = [f"{latex_path}/{compiler}", "-interaction=nonstopmode", tex_filename]
            result = subprocess.run(cmd, cwd=working_dir, capture_output=True, text=True, timeout=60)
            
            if result.returncode == 0:
                logger.info(f"Successfully compiled {tex_file} to PDF")
                
                # Check if bibliography needs processing
                bibtex_path = f"{latex_path}/{self.config['writing_tools']['latex']['bibtex']}"
                if Path(working_dir / f"{tex_file.stem}.bib").exists():
                    # Run bibtex
                    bibtex_cmd = [bibtex_path, tex_filename[:-4]]  # Remove .tex extension
                    subprocess.run(bibtex_cmd, cwd=working_dir, capture_output=True, text=True, timeout=30)
                    
                    # Run pdflatex twice more for references
                    subprocess.run(cmd, cwd=working_dir, capture_output=True, text=True, timeout=60)
                    subprocess.run(cmd, cwd=working_dir, capture_output=True, text=True, timeout=60)
                
                return True
            else:
                logger.warning(f"LaTeX compilation failed: {result.stderr}")
                return False
                
        except Exception as e:
            logger.error(f"Failed to compile LaTeX document {tex_file}: {e}")
            return False
    
    def create_bean_template(self, template_name: str, content: str = None) -> Path:
        """Create a new Bean template for research writing."""
        try:
            templates_dir = Path(self.config['writing_tools']['bean']['templates_dir']).expanduser()
            templates_dir.mkdir(parents=True, exist_ok=True)
            
            template_file = templates_dir / f"{template_name}.rtf"
            
            if content is None:
                content = """{\\rtf1\\ansi\\deff0 {\\fonttbl {\\f0 Times;}}
{\\colortbl ;\\red0\\green0\\blue0;}
\\f0\\fs24 Research Document Template\\par
\\par
Title: \\par
Author: \\par
Date: \\par
\\par
Abstract:\\par
\\par
Introduction:\\par
\\par
Methods:\\par
\\par
Results:\\par
\\par
Discussion:\\par
\\par
Conclusion:\\par
\\par
References:\\par
}"""
            
            with open(template_file, 'w', encoding='utf-8') as f:
                f.write(content)
            
            logger.info(f"Created Bean template: {template_file}")
            return template_file
            
        except Exception as e:
            logger.error(f"Failed to create Bean template: {e}")
            return None
    
    def create_latex_template(self, template_name: str, document_type: str = "article") -> Path:
        """Create a new LaTeX template for research writing."""
        try:
            templates_dir = Path(self.config['writing_tools']['latex']['templates_dir']).expanduser()
            templates_dir.mkdir(parents=True, exist_ok=True)
            
            template_file = templates_dir / f"{template_name}.tex"
            
            if document_type == "article":
                content = f"""\\documentclass[11pt]{{article}}
\\usepackage[utf8]{{inputenc}}
\\usepackage{{amsmath}}
\\usepackage{{amsfonts}}
\\usepackage{{amssymb}}
\\usepackage{{graphicx}}
\\usepackage{{hyperref}}
\\usepackage{{natbib}}

\\title{{{template_name}}}
\\author{{Your Name}}
\\date{{\\today}}

\\begin{{document}}

\\maketitle

\\begin{{abstract}}
Your abstract here.
\\end{{abstract}}

\\section{{Introduction}}
Your introduction here.

\\section{{Methods}}
Your methods here.

\\section{{Results}}
Your results here.

\\section{{Discussion}}
Your discussion here.

\\section{{Conclusion}}
Your conclusion here.

\\bibliographystyle{{plainnat}}
\\bibliography{{references}}

\\end{{document}}"""
            else:
                content = f"""\\documentclass[11pt]{{{document_type}}}
\\usepackage[utf8]{{inputenc}}
\\usepackage{{amsmath}}
\\usepackage{{amsfonts}}
\\usepackage{{amssymb}}
\\usepackage{{graphicx}}
\\usepackage{{hyperref}}

\\title{{{template_name}}}
\\author{{Your Name}}
\\date{{\\today}}

\\begin{{document}}

\\maketitle

Your content here.

\\end{{document}}"""
            
            with open(template_file, 'w', encoding='utf-8') as f:
                f.write(content)
            
            logger.info(f"Created LaTeX template: {template_file}")
            return template_file
            
        except Exception as e:
            logger.error(f"Failed to create LaTeX template: {e}")
            return None
    
    def process_scispace_export(self, export_file: Path):
        """Process a SciSpace export file and integrate it into the research system."""
        try:
            if not self.config.get('research_tools', {}).get('scispace', {}).get('enabled', False):
                logger.info("SciSpace integration is disabled")
                return False
            
            export_dir = Path(self.config['research_tools']['scispace']['export_dir']).expanduser()
            export_dir.mkdir(parents=True, exist_ok=True)
            
            # Move export to SciSpace exports directory
            destination = export_dir / export_file.name
            shutil.move(str(export_file), str(destination))
            
            # Extract metadata and create research entry
            metadata = self.extract_metadata(destination)
            metadata['source'] = 'SciSpace'
            metadata['export_date'] = datetime.now().isoformat()
            
            # Save metadata
            metadata_file = destination.with_suffix('.metadata.json')
            with open(metadata_file, 'w') as f:
                json.dump(metadata, f, indent=2, default=str)
            
            logger.info(f"Processed SciSpace export: {destination}")
            return True
            
        except Exception as e:
            logger.error(f"Failed to process SciSpace export {export_file}: {e}")
            return False
    
    def process_directory(self, directory_path: str):
        """Process all files in a directory."""
        directory = Path(directory_path).expanduser()
        
        if not directory.exists():
            logger.warning(f"Directory not found: {directory}")
            return
        
        logger.info(f"Processing directory: {directory}")
        
        # Get all files
        files = [f for f in directory.iterdir() if f.is_file()]
        logger.info(f"Found {len(files)} files to process")
        
        processed = 0
        failed = 0
        
        for file_path in files:
            try:
                if self.organize_file(file_path):
                    processed += 1
                else:
                    failed += 1
            except Exception as e:
                logger.error(f"Error processing {file_path}: {e}")
                failed += 1
        
        logger.info(f"Directory processing complete. Processed: {processed}, Failed: {failed}")
    
    def start_watching(self):
        """Start watching source directories for new files."""
        if not self.config['auto_organization']['enabled']:
            logger.info("Auto-organization is disabled in config")
            return
        
        class FileHandler(FileSystemEventHandler):
            def __init__(self, manager):
                self.manager = manager
            
            def on_created(self, event):
                if not event.is_directory:
                    logger.info(f"New file detected: {event.src_path}")
                    # Wait a bit for file to be fully written
                    time.sleep(2)
                    self.manager.organize_file(Path(event.src_path))
        
        event_handler = FileHandler(self)
        observer = Observer()
        
        for directory in self.config['source_directories']:
            dir_path = Path(directory).expanduser()
            if dir_path.exists():
                observer.schedule(event_handler, str(dir_path), recursive=False)
                logger.info(f"Watching directory: {dir_path}")
            else:
                logger.warning(f"Source directory not found: {dir_path}")
        
        observer.start()
        logger.info("File watching started. Press Ctrl+C to stop.")
        
        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            observer.stop()
            logger.info("File watching stopped.")
        
        observer.join()

def main():
    """Main function to run the research file manager."""
    import argparse
    
    parser = argparse.ArgumentParser(description='Research File Manager')
    parser.add_argument('--config', default='config.json', help='Configuration file path')
    parser.add_argument('--watch', action='store_true', help='Start watching directories')
    parser.add_argument('--process', help='Process a specific directory')
    parser.add_argument('--process-all', action='store_true', help='Process all source directories')
    
    args = parser.parse_args()
    
    # Initialize manager
    manager = ResearchFileManager(args.config)
    
    if args.process:
        # Process specific directory
        manager.process_directory(args.process)
    elif args.process_all:
        # Process all source directories
        for directory in manager.config['source_directories']:
            manager.process_directory(directory)
    elif args.watch:
        # Start watching mode
        manager.start_watching()
    else:
        # Default: process all source directories once
        for directory in manager.config['source_directories']:
            manager.process_directory(directory)

if __name__ == "__main__":
    main()

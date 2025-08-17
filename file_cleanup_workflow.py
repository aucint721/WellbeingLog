#!/usr/bin/env python3
"""
File Cleanup Workflow - Find Large and Old Files for Review
Integrated with macOS Shortcuts and Quick Look for efficient file management

This script helps identify files that may be candidates for deletion by analyzing:
- File size (large files)
- File age (old files)
- File access patterns (unused files)
- Duplicate files
"""

import os
import sys
import json
import logging
import argparse
import subprocess
from datetime import datetime, timedelta
from pathlib import Path
from typing import Dict, List, Tuple, Optional
import hashlib
import sqlite3
from dataclasses import dataclass, asdict
import csv

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('file_cleanup.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

@dataclass
class FileInfo:
    """Data class for file information."""
    path: str
    name: str
    size: int
    size_human: str
    modified: datetime
    accessed: datetime
    created: datetime
    age_days: int
    last_access_days: int
    extension: str
    is_hidden: bool
    is_system: bool
    quick_look_url: str = ""
    duplicate_group: Optional[str] = None
    risk_score: float = 0.0

class FileCleanupWorkflow:
    """Main class for file cleanup workflow management."""
    
    def __init__(self, config_path: str = "cleanup_config.json"):
        """Initialize the file cleanup workflow."""
        self.config = self.load_config(config_path)
        self.db_path = Path("file_cleanup.db")
        self.setup_database()
        
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
            "scan_directories": [
                "~/Downloads",
                "~/Desktop",
                "~/Documents",
                "~/Pictures",
                "~/Movies",
                "~/Music"
            ],
            "exclude_directories": [
                "~/Library",
                "~/Applications",
                "~/System",
                "~/.Trash"
            ],
            "exclude_extensions": [
                ".app", ".dmg", ".pkg", ".kext", ".bundle"
            ],
            "size_thresholds": {
                "large_files_mb": 100,
                "huge_files_mb": 500,
                "massive_files_mb": 1000
            },
            "age_thresholds": {
                "old_files_days": 365,
                "very_old_files_days": 730,
                "ancient_files_days": 1095
            },
            "access_thresholds": {
                "unused_files_days": 180,
                "rarely_used_files_days": 90
            },
            "risk_scoring": {
                "size_weight": 0.4,
                "age_weight": 0.3,
                "access_weight": 0.3
            },
            "output_formats": ["json", "csv", "html"],
            "enable_quick_look": True,
            "enable_duplicate_detection": True,
            "max_scan_depth": 10
        }
        
        try:
            with open(config_path, 'w') as f:
                json.dump(default_config, f, indent=2)
            logger.info(f"Created default config file: {config_path}")
        except Exception as e:
            logger.error(f"Failed to create config file: {e}")
        
        return default_config
    
    def setup_database(self):
        """Setup SQLite database for file tracking."""
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            # Create files table
            cursor.execute('''
                CREATE TABLE IF NOT EXISTS files (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    path TEXT UNIQUE,
                    name TEXT,
                    size INTEGER,
                    modified TEXT,
                    accessed TEXT,
                    created TEXT,
                    extension TEXT,
                    is_hidden BOOLEAN,
                    is_system BOOLEAN,
                    hash TEXT,
                    risk_score REAL,
                    scan_date TEXT,
                    status TEXT DEFAULT 'active'
                )
            ''')
            
            # Create scan_history table
            cursor.execute('''
                CREATE TABLE IF NOT EXISTS scan_history (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    scan_date TEXT,
                    total_files INTEGER,
                    large_files INTEGER,
                    old_files INTEGER,
                    unused_files INTEGER,
                    duplicates INTEGER
                )
            ''')
            
            conn.commit()
            conn.close()
            logger.info("Database setup complete")
            
        except Exception as e:
            logger.error(f"Database setup failed: {e}")
    
    def get_file_info(self, file_path: Path) -> Optional[FileInfo]:
        """Extract comprehensive file information."""
        try:
            stat = file_path.stat()
            
            # Check if file is accessible
            if not os.access(file_path, os.R_OK):
                return None
            
            # Get file times
            modified = datetime.fromtimestamp(stat.st_mtime)
            accessed = datetime.fromtimestamp(stat.st_atime)
            created = datetime.fromtimestamp(stat.st_ctime)
            
            # Calculate ages
            now = datetime.now()
            age_days = (now - modified).days
            last_access_days = (now - accessed).days
            
            # Check if hidden or system file
            is_hidden = file_path.name.startswith('.')
            is_system = any(system_dir in str(file_path) for system_dir in 
                          ['/System', '/Library', '/Applications'])
            
            # Generate Quick Look URL
            quick_look_url = f"file://{file_path.absolute()}"
            
            # Calculate risk score
            risk_score = self.calculate_risk_score(
                stat.st_size, age_days, last_access_days
            )
            
            return FileInfo(
                path=str(file_path),
                name=file_path.name,
                size=stat.st_size,
                size_human=self.humanize_size(stat.st_size),
                modified=modified,
                accessed=accessed,
                created=created,
                age_days=age_days,
                last_access_days=last_access_days,
                extension=file_path.suffix.lower(),
                is_hidden=is_hidden,
                is_system=is_system,
                quick_look_url=quick_look_url,
                risk_score=risk_score
            )
            
        except Exception as e:
            logger.warning(f"Could not get info for {file_path}: {e}")
            return None
    
    def humanize_size(self, size_bytes: int) -> str:
        """Convert bytes to human readable format."""
        if size_bytes == 0:
            return "0B"
        
        size_names = ["B", "KB", "MB", "GB", "TB"]
        i = 0
        while size_bytes >= 1024 and i < len(size_names) - 1:
            size_bytes /= 1024.0
            i += 1
        
        return f"{size_bytes:.1f}{size_names[i]}"
    
    def calculate_risk_score(self, size: int, age_days: int, access_days: int) -> float:
        """Calculate risk score for file deletion (0-100)."""
        config = self.config['risk_scoring']
        
        # Size score (0-100)
        size_mb = size / (1024 * 1024)
        size_score = min(100, (size_mb / 100) * 100)  # 100MB = 100 points
        
        # Age score (0-100)
        age_score = min(100, (age_days / 365) * 100)  # 1 year = 100 points
        
        # Access score (0-100)
        access_score = min(100, (access_days / 180) * 100)  # 6 months = 100 points
        
        # Weighted combination
        total_score = (
            size_score * config['size_weight'] +
            age_score * config['age_weight'] +
            access_score * config['access_weight']
        )
        
        return round(total_score, 2)
    
    def scan_directory(self, directory: Path, max_depth: int = 0, current_depth: int = 0) -> List[FileInfo]:
        """Recursively scan directory for files."""
        files = []
        
        try:
            if not directory.exists() or not directory.is_dir():
                return files
            
            # Check if we should exclude this directory
            if self.should_exclude_directory(directory):
                return files
            
            # Check depth limit
            if max_depth > 0 and current_depth >= max_depth:
                return files
            
            for item in directory.iterdir():
                try:
                    if item.is_file():
                        # Check if we should exclude this file
                        if not self.should_exclude_file(item):
                            file_info = self.get_file_info(item)
                            if file_info:
                                files.append(file_info)
                    elif item.is_dir() and current_depth < max_depth:
                        # Recursively scan subdirectories
                        sub_files = self.scan_directory(item, max_depth, current_depth + 1)
                        files.extend(sub_files)
                        
                except PermissionError:
                    logger.debug(f"Permission denied: {item}")
                except Exception as e:
                    logger.debug(f"Error processing {item}: {e}")
                    
        except Exception as e:
            logger.error(f"Error scanning directory {directory}: {e}")
        
        return files
    
    def should_exclude_directory(self, directory: Path) -> bool:
        """Check if directory should be excluded from scanning."""
        exclude_dirs = [Path(d).expanduser() for d in self.config['exclude_directories']]
        return any(directory.is_relative_to(exclude_dir) for exclude_dir in exclude_dirs)
    
    def should_exclude_file(self, file_path: Path) -> bool:
        """Check if file should be excluded from scanning."""
        # Check extension
        if file_path.suffix.lower() in self.config['exclude_extensions']:
            return True
        
        # Check if system or hidden file
        if file_path.name.startswith('.') or 'System' in str(file_path):
            return True
        
        return False
    
    def find_large_files(self, files: List[FileInfo]) -> List[FileInfo]:
        """Find files above size thresholds."""
        thresholds = self.config['size_thresholds']
        large_files = []
        
        for file_info in files:
            size_mb = file_info.size / (1024 * 1024)
            if size_mb >= thresholds['large_files_mb']:
                large_files.append(file_info)
        
        return sorted(large_files, key=lambda x: x.size, reverse=True)
    
    def find_old_files(self, files: List[FileInfo]) -> List[FileInfo]:
        """Find files above age thresholds."""
        thresholds = self.config['age_thresholds']
        old_files = []
        
        for file_info in files:
            if file_info.age_days >= thresholds['old_files_days']:
                old_files.append(file_info)
        
        return sorted(old_files, key=lambda x: x.age_days, reverse=True)
    
    def find_unused_files(self, files: List[FileInfo]) -> List[FileInfo]:
        """Find files that haven't been accessed recently."""
        thresholds = self.config['access_thresholds']
        unused_files = []
        
        for file_info in files:
            if file_info.last_access_days >= thresholds['unused_files_days']:
                unused_files.append(file_info)
        
        return sorted(unused_files, key=lambda x: x.last_access_days, reverse=True)
    
    def find_duplicate_files(self, files: List[FileInfo]) -> List[FileInfo]:
        """Find duplicate files based on content hash."""
        if not self.config['enable_duplicate_detection']:
            return []
        
        hash_groups = {}
        duplicates = []
        
        for file_info in files:
            try:
                file_hash = self.calculate_file_hash(Path(file_info.path))
                if file_hash in hash_groups:
                    hash_groups[file_hash].append(file_info)
                else:
                    hash_groups[file_hash] = [file_info]
            except Exception as e:
                logger.debug(f"Could not hash {file_info.path}: {e}")
        
        # Find groups with multiple files
        for file_hash, file_list in hash_groups.items():
            if len(file_list) > 1:
                # Mark all but the first as duplicates
                for i, file_info in enumerate(file_list[1:], 1):
                    file_info.duplicate_group = f"Group_{file_hash[:8]}"
                    file_info.risk_score += 20  # Bonus points for being duplicate
                    duplicates.append(file_info)
        
        return sorted(duplicates, key=lambda x: x.risk_score, reverse=True)
    
    def calculate_file_hash(self, file_path: Path, chunk_size: int = 8192) -> str:
        """Calculate SHA-256 hash of file content."""
        hash_sha256 = hashlib.sha256()
        
        try:
            with open(file_path, "rb") as f:
                for chunk in iter(lambda: f.read(chunk_size), b""):
                    hash_sha256.update(chunk)
        except Exception as e:
            logger.error(f"Error calculating hash for {file_path}: {e}")
            return ""
        
        return hash_sha256.hexdigest()
    
    def generate_cleanup_report(self, files: List[FileInfo], output_dir: str = "cleanup_reports") -> Dict:
        """Generate comprehensive cleanup report."""
        output_path = Path(output_dir)
        output_path.mkdir(exist_ok=True)
        
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # Categorize files
        large_files = self.find_large_files(files)
        old_files = self.find_old_files(files)
        unused_files = self.find_unused_files(files)
        duplicate_files = self.find_duplicate_files(files)
        
        # Calculate statistics
        total_size = sum(f.size for f in files)
        potential_savings = sum(f.size for f in large_files + old_files + unused_files + duplicate_files)
        
        report_data = {
            "scan_date": datetime.now().isoformat(),
            "total_files": len(files),
            "total_size": total_size,
            "total_size_human": self.humanize_size(total_size),
            "potential_savings": potential_savings,
            "potential_savings_human": self.humanize_size(potential_savings),
            "categories": {
                "large_files": {
                    "count": len(large_files),
                    "total_size": sum(f.size for f in large_files),
                    "files": [asdict(f) for f in large_files[:50]]  # Top 50
                },
                "old_files": {
                    "count": len(old_files),
                    "total_size": sum(f.size for f in old_files),
                    "files": [asdict(f) for f in old_files[:50]]
                },
                "unused_files": {
                    "count": len(unused_files),
                    "total_size": sum(f.size for f in unused_files),
                    "files": [asdict(f) for f in unused_files[:50]]
                },
                "duplicate_files": {
                    "count": len(duplicate_files),
                    "total_size": sum(f.size for f in duplicate_files),
                    "files": [asdict(f) for f in duplicate_files[:50]]
                }
            },
            "high_risk_files": [
                asdict(f) for f in sorted(files, key=lambda x: x.risk_score, reverse=True)[:100]
            ]
        }
        
        # Generate output files
        self.save_report_json(report_data, output_path / f"cleanup_report_{timestamp}.json")
        self.save_report_csv(report_data, output_path / f"cleanup_report_{timestamp}.csv")
        self.save_report_html(report_data, output_path / f"cleanup_report_{timestamp}.html")
        
        # Save to database
        self.save_to_database(files, report_data)
        
        logger.info(f"Cleanup report generated: {output_path}")
        return report_data
    
    def save_report_json(self, report_data: Dict, file_path: Path):
        """Save report as JSON file."""
        try:
            with open(file_path, 'w') as f:
                json.dump(report_data, f, indent=2, default=str)
            logger.info(f"JSON report saved: {file_path}")
        except Exception as e:
            logger.error(f"Failed to save JSON report: {e}")
    
    def save_report_csv(self, report_data: Dict, file_path: Path):
        """Save report as CSV file."""
        try:
            with open(file_path, 'w', newline='', encoding='utf-8') as f:
                writer = csv.writer(f)
                
                # Write header
                writer.writerow([
                    'Path', 'Name', 'Size (bytes)', 'Size (human)', 'Modified', 
                    'Accessed', 'Created', 'Age (days)', 'Last Access (days)', 
                    'Extension', 'Risk Score', 'Category', 'Duplicate Group'
                ])
                
                # Write data for each category
                categories = ['large_files', 'old_files', 'unused_files', 'duplicate_files']
                for category in categories:
                    for file_data in report_data['categories'][category]['files']:
                        writer.writerow([
                            file_data['path'],
                            file_data['name'],
                            file_data['size'],
                            file_data['size_human'],
                            file_data['modified'],
                            file_data['accessed'],
                            file_data['created'],
                            file_data['age_days'],
                            file_data['last_access_days'],
                            file_data['extension'],
                            file_data['risk_score'],
                            category.replace('_', ' ').title(),
                            file_data.get('duplicate_group', '')
                        ])
            
            logger.info(f"CSV report saved: {file_path}")
        except Exception as e:
            logger.error(f"Failed to save CSV report: {e}")
    
    def save_report_html(self, report_data: Dict, file_path: Path):
        """Save report as HTML file with Quick Look integration."""
        try:
            html_content = self.generate_html_report(report_data)
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(html_content)
            logger.info(f"HTML report saved: {file_path}")
        except Exception as e:
            logger.error(f"Failed to save HTML report: {e}")
    
    def generate_html_report(self, report_data: Dict) -> str:
        """Generate HTML report with Quick Look integration."""
        html = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>File Cleanup Report - {report_data['scan_date'][:10]}</title>
    <style>
        body {{ font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; margin: 20px; }}
        .header {{ background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 10px; margin-bottom: 20px; }}
        .stats {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }}
        .stat-card {{ background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); text-align: center; }}
        .stat-number {{ font-size: 2em; font-weight: bold; color: #667eea; }}
        .category {{ margin-bottom: 30px; }}
        .category h3 {{ color: #333; border-bottom: 2px solid #667eea; padding-bottom: 10px; }}
        .file-list {{ background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); overflow: hidden; }}
        .file-item {{ display: grid; grid-template-columns: 1fr auto auto auto auto; gap: 15px; padding: 15px; border-bottom: 1px solid #eee; align-items: center; }}
        .file-item:hover {{ background: #f8f9fa; }}
        .file-name {{ font-weight: 500; color: #333; }}
        .file-size {{ color: #666; text-align: right; }}
        .file-age {{ color: #666; text-align: right; }}
        .risk-score {{ text-align: center; padding: 4px 8px; border-radius: 4px; font-weight: 500; }}
        .risk-high {{ background: #fee; color: #c33; }}
        .risk-medium {{ background: #fef; color: #66c; }}
        .risk-low {{ background: #efe; color: #363; }}
        .quick-look-btn {{ background: #667eea; color: white; border: none; padding: 8px 12px; border-radius: 4px; cursor: pointer; font-size: 12px; }}
        .quick-look-btn:hover {{ background: #5a6fd8; }}
        .duplicate-badge {{ background: #ff6b6b; color: white; padding: 2px 6px; border-radius: 10px; font-size: 10px; }}
    </style>
</head>
<body>
    <div class="header">
        <h1>📁 File Cleanup Report</h1>
        <p>Generated on {report_data['scan_date'][:19].replace('T', ' ')}</p>
    </div>
    
    <div class="stats">
        <div class="stat-card">
            <div class="stat-number">{report_data['total_files']:,}</div>
            <div>Total Files</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">{report_data['total_size_human']}</div>
            <div>Total Size</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">{report_data['potential_savings_human']}</div>
            <div>Potential Savings</div>
        </div>
    </div>
"""
        
        # Add each category
        categories = [
            ('large_files', 'Large Files', 'Size'),
            ('old_files', 'Old Files', 'Age'),
            ('unused_files', 'Unused Files', 'Last Access'),
            ('duplicate_files', 'Duplicate Files', 'Size')
        ]
        
        for category_key, category_name, sort_by in categories:
            category_data = report_data['categories'][category_key]
            html += f"""
    <div class="category">
        <h3>{category_name} ({category_data['count']:,} files, {self.humanize_size(category_data['total_size'])})</h3>
        <div class="file-list">
            <div class="file-item" style="font-weight: bold; background: #f8f9fa;">
                <div>File Name</div>
                <div>{sort_by}</div>
                <div>Age (days)</div>
                <div>Risk Score</div>
                <div>Actions</div>
            </div>
"""
            
            for file_data in category_data['files'][:20]:  # Show top 20
                risk_class = 'risk-low'
                if file_data['risk_score'] > 70:
                    risk_class = 'risk-high'
                elif file_data['risk_score'] > 40:
                    risk_class = 'risk-medium'
                
                duplicate_badge = ""
                if file_data.get('duplicate_group'):
                    duplicate_badge = f'<span class="duplicate-badge">Duplicate</span> '
                
                html += f"""
            <div class="file-item">
                <div class="file-name">
                    {duplicate_badge}{file_data['name']}
                    <br><small style="color: #999;">{file_data['path']}</small>
                </div>
                <div class="file-size">{file_data['size_human']}</div>
                <div class="file-age">{file_data['age_days']}</div>
                <div class="risk-score {risk_class}">{file_data['risk_score']}</div>
                <div>
                    <button class="quick-look-btn" onclick="openQuickLook('{file_data['path']}')">Quick Look</button>
                </div>
            </div>
"""
            
            html += """
        </div>
    </div>
"""
        
        # Add JavaScript for Quick Look integration
        html += """
    <script>
        function openQuickLook(filePath) {
            // Create a temporary file with the path for Quick Look
            const tempFile = document.createElement('a');
            tempFile.href = 'file://' + filePath;
            tempFile.download = '';
            tempFile.click();
            
            // Alternative: Use macOS Quick Look via URL scheme
            // window.open('file://' + filePath);
        }
        
        // Add keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            if (e.key === 'q' || e.key === 'Q') {
                // Quick Look shortcut
                const focusedElement = document.activeElement;
                if (focusedElement && focusedElement.classList.contains('quick-look-btn')) {
                    focusedElement.click();
                }
            }
        });
    </script>
</body>
</html>
"""
        
        return html
    
    def save_to_database(self, files: List[FileInfo], report_data: Dict):
        """Save scan results to database."""
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            # Save file information
            for file_info in files:
                cursor.execute('''
                    INSERT OR REPLACE INTO files 
                    (path, name, size, modified, accessed, created, extension, is_hidden, is_system, hash, risk_score, scan_date, status)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ''', (
                    file_info.path, file_info.name, file_info.size,
                    file_info.modified.isoformat(), file_info.accessed.isoformat(),
                    file_info.created.isoformat(), file_info.extension,
                    file_info.is_hidden, file_info.is_system,
                    self.calculate_file_hash(Path(file_info.path)),
                    file_info.risk_score, datetime.now().isoformat(), 'active'
                ))
            
            # Save scan history
            cursor.execute('''
                INSERT INTO scan_history 
                (scan_date, total_files, large_files, old_files, unused_files, duplicates)
                VALUES (?, ?, ?, ?, ?, ?)
            ''', (
                datetime.now().isoformat(),
                report_data['total_files'],
                report_data['categories']['large_files']['count'],
                report_data['categories']['old_files']['count'],
                report_data['categories']['unused_files']['count'],
                report_data['categories']['duplicate_files']['count']
            ))
            
            conn.commit()
            conn.close()
            logger.info("Scan results saved to database")
            
        except Exception as e:
            logger.error(f"Failed to save to database: {e}")
    
    def create_shortcuts_workflow(self, output_dir: str = "shortcuts_workflows"):
        """Create macOS Shortcuts workflow files for file cleanup."""
        output_path = Path(output_dir)
        output_path.mkdir(exist_ok=True)
        
        # Create the main workflow
        workflow_content = self.generate_shortcuts_workflow()
        
        workflow_file = output_path / "File_Cleanup_Workflow.shortcut"
        with open(workflow_file, 'w') as f:
            f.write(workflow_content)
        
        # Create Quick Look integration script
        quicklook_script = self.generate_quicklook_script()
        script_file = output_path / "quicklook_integration.sh"
        with open(script_file, 'w') as f:
            f.write(quicklook_script)
        
        # Make script executable
        os.chmod(script_file, 0o755)
        
        logger.info(f"Shortcuts workflow created: {workflow_file}")
        logger.info(f"Quick Look integration script: {script_file}")
        
        return workflow_file
    
    def generate_shortcuts_workflow(self) -> str:
        """Generate Shortcuts workflow content."""
        return """{
  "WFWorkflow": {
    "WFWorkflowClientRelease": "1097.1",
    "WFWorkflowClientVersion": "1097.1",
    "WFWorkflowIcon": {
      "WFWorkflowIconStartColor": 4282601983
    },
    "WFWorkflowImportQuestions": [],
    "WFWorkflowInput": {
      "Multiple": true,
      "Required": false,
      "Types": [
        "WFStringParameter"
      ]
    },
    "WFWorkflowItems": [
      {
        "WFWorkflowItemIdentifier": "A1B2C3D4-E5F6-7890-ABCD-EF1234567890",
        "WFWorkflowItemType": "WFWorkflowInput",
        "WFWorkflowItemName": "Input"
      },
      {
        "WFWorkflowItemIdentifier": "B2C3D4E5-F6G7-8901-BCDE-F23456789012",
        "WFWorkflowItemType": "WFGetFileAction",
        "WFWorkflowItemName": "Get Files from Folder",
        "WFGetFileActionInput": {
          "Value": {
            "Type": "WFPath",
            "WFValue": {
              "Path": "~/Downloads"
            }
          }
        },
        "WFGetFileActionRecursiveSubfolders": true
      },
      {
        "WFWorkflowItemIdentifier": "C3D4E5F6-G7H8-9012-CDEF-345678901234",
        "WFWorkflowItemType": "WFFilterFilesAction",
        "WFWorkflowItemName": "Filter Files",
        "WFFilterFilesActionInput": {
          "Value": {
            "Type": "WFNumber",
            "WFValue": {
              "Number": 104857600
            }
          }
        },
        "WFFilterFilesActionProperty": "File Size",
        "WFFilterFilesActionOperator": "Greater Than"
      },
      {
        "WFWorkflowItemIdentifier": "D4E5F6G7-H8I9-0123-DEF0-456789012345",
        "WFWorkflowItemType": "WFQuickLookAction",
        "WFWorkflowItemName": "Quick Look Files"
      },
      {
        "WFWorkflowItemIdentifier": "E5F6G7H8-I9J0-1234-EF01-567890123456",
        "WFWorkflowItemType": "WFShowResultAction",
        "WFWorkflowItemName": "Show Results"
      }
    ],
    "WFWorkflowName": "File Cleanup Workflow",
    "WFWorkflowTypes": [
      "WatchKit",
      "Widget"
    ]
  }
}"""
    
    def generate_quicklook_script(self) -> str:
        """Generate Quick Look integration script."""
        return """#!/bin/bash
# Quick Look Integration Script for File Cleanup Workflow
# This script enables Quick Look preview of files from the cleanup workflow

# Function to open file in Quick Look
quicklook_file() {
    local file_path="$1"
    
    if [[ -f "$file_path" ]]; then
        # Use macOS Quick Look
        qlmanage -p "$file_path" >/dev/null 2>&1 &
        echo "Opened $file_path in Quick Look"
    else
        echo "Error: File not found: $file_path"
        return 1
    fi
}

# Function to batch Quick Look multiple files
batch_quicklook() {
    local file_list="$1"
    
    if [[ -f "$file_list" ]]; then
        while IFS= read -r file_path; do
            if [[ -n "$file_path" ]]; then
                quicklook_file "$file_path"
                sleep 0.5  # Small delay between files
            fi
        done < "$file_list"
    else
        echo "Error: File list not found: $file_list"
        return 1
    fi
}

# Main execution
case "$1" in
    "single")
        if [[ -n "$2" ]]; then
            quicklook_file "$2"
        else
            echo "Usage: $0 single <file_path>"
            exit 1
        fi
        ;;
    "batch")
        if [[ -n "$2" ]]; then
            batch_quicklook "$2"
        else
            echo "Usage: $0 batch <file_list_path>"
            exit 1
        fi
        ;;
    *)
        echo "Usage: $0 {single|batch} [file_path|file_list_path]"
        echo "  single: Open single file in Quick Look"
        echo "  batch:  Open multiple files from list in Quick Look"
        exit 1
        ;;
esac
"""
    
    def run_cleanup_workflow(self, directories: List[str] = None):
        """Run the complete cleanup workflow."""
        if directories is None:
            directories = self.config['scan_directories']
        
        logger.info("Starting file cleanup workflow...")
        
        all_files = []
        for directory in directories:
            dir_path = Path(directory).expanduser()
            logger.info(f"Scanning directory: {dir_path}")
            
            files = self.scan_directory(
                dir_path, 
                max_depth=self.config['max_scan_depth']
            )
            all_files.extend(files)
            logger.info(f"Found {len(files)} files in {dir_path}")
        
        logger.info(f"Total files found: {len(all_files)}")
        
        # Generate report
        report = self.generate_cleanup_report(all_files)
        
        # Create Shortcuts workflow
        self.create_shortcuts_workflow()
        
        logger.info("File cleanup workflow complete!")
        return report

def main():
    """Main function to run the file cleanup workflow."""
    parser = argparse.ArgumentParser(description='File Cleanup Workflow')
    parser.add_argument('--config', default='cleanup_config.json', help='Configuration file path')
    parser.add_argument('--directories', nargs='+', help='Directories to scan')
    parser.add_argument('--create-shortcuts', action='store_true', help='Create Shortcuts workflow files')
    parser.add_argument('--quick-scan', action='store_true', help='Quick scan of common directories')
    
    args = parser.parse_args()
    
    # Initialize workflow
    workflow = FileCleanupWorkflow(args.config)
    
    if args.create_shortcuts:
        workflow.create_shortcuts_workflow()
        logger.info("Shortcuts workflow files created")
    elif args.quick_scan:
        # Quick scan of common directories
        quick_dirs = ['~/Downloads', '~/Desktop', '~/Documents']
        report = workflow.run_cleanup_workflow(quick_dirs)
        logger.info("Quick scan complete")
    elif args.directories:
        # Scan specified directories
        report = workflow.run_cleanup_workflow(args.directories)
        logger.info("Custom directory scan complete")
    else:
        # Run full workflow
        report = workflow.run_cleanup_workflow()
        logger.info("Full workflow complete")

if __name__ == "__main__":
    main()

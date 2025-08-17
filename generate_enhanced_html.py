#!/usr/bin/env python3
"""
Enhanced HTML Report Generator
Creates interactive HTML reports with file preview functionality
"""

import os
import json
import datetime
from typing import List, Dict, Any

def load_cleanup_data(json_report_path: str) -> Dict[str, Any]:
    """Load cleanup data from JSON report"""
    try:
        with open(json_report_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading JSON report: {e}")
        return {}


def format_file_size(size_bytes: int) -> str:
    """Format file size in human readable format"""
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if size_bytes < 1024.0:
            return f"{size_bytes:.1f}{unit}"
        size_bytes /= 1024.0
    return f"{size_bytes:.1f}PB"


def get_risk_class(risk_score: float) -> str:
    """Get CSS class for risk score"""
    if risk_score >= 70:
        return "risk-high"
    elif risk_score >= 40:
        return "risk-medium"
    else:
        return "risk-low"


def generate_file_item_html(file_info: Dict[str, Any]) -> str:
    """Generate HTML for a single file item"""
    file_name = file_info.get('name', 'Unknown')
    file_path = file_info.get('path', '')
    file_size = format_file_size(file_info.get('size', 0))
    file_age = file_info.get('age_days', 0)
    risk_score = file_info.get('risk_score', 0)
    is_duplicate = file_info.get('is_duplicate', False)
    
    # Clean up file name display
    display_name = file_name
    if is_duplicate:
        display_name = (f'<span class="duplicate-badge">'
                       f'Duplicate</span> {file_name}')
    
    risk_class = get_risk_class(risk_score)
    
    return f'''
            <div class="file-item">
                <div class="file-name">
                    {display_name}
                    <div class="file-path">{file_path}</div>
                </div>
                <div class="file-size">{file_size}</div>
                <div class="file-age">{file_age}</div>
                <div class="risk-score {risk_class}">{risk_score:.1f}</div>
                <div class="action-buttons">
                    <button class="btn btn-primary" 
                            onclick="showFilePreview('{file_path}')">
                        👁️ Preview
                    </button>
                    <button class="btn btn-secondary" 
                            onclick="openQuickLook('{file_path}')">
                        🔍 Quick Look
                    </button>
                </div>
            </div>'''


def generate_category_html(category_name: str, files: List[Dict[str, Any]], 
                          total_size: str) -> str:
    """Generate HTML for a file category"""
    if not files:
        return ""
    
    file_count = len(files)
    file_items_html = ""
    
    for file_info in files:
        file_items_html += generate_file_item_html(file_info)
    
    return f'''
    <div class="category">
        <h3>{category_name} ({file_count} files, {total_size})</h3>
        <div class="file-list">
            <div class="file-header">
                <div>File Name</div>
                <div>Size</div>
                <div>Age (days)</div>
                <div>Risk Score</div>
                <div>Actions</div>
            </div>
            {file_items_html}
        </div>
    </div>'''


def generate_enhanced_html_report(json_report_path: str, 
                                 output_dir: str = "cleanup_reports"):
    """Generate enhanced HTML report from JSON data"""
    
    # Load cleanup data
    data = load_cleanup_data(json_report_path)
    if not data:
        print("No data loaded, cannot generate report")
        return
    
    # Load HTML template
    template_path = "enhanced_html_template.html"
    if not os.path.exists(template_path):
        print(f"Template file {template_path} not found")
        return
    
    with open(template_path, 'r', encoding='utf-8') as f:
        template = f.read()
    
    # Prepare data for template
    generation_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # Calculate totals
    total_files = data.get('total_files', 0)
    total_size = format_file_size(data.get('total_size_bytes', 0))
    potential_savings = format_file_size(data.get('potential_savings_bytes', 0))
    
    # Generate categories HTML
    categories_html = ""
    
    # Large files
    large_files = data.get('large_files', [])
    if large_files:
        large_size = format_file_size(sum(f.get('size', 0) for f in large_files))
        categories_html += generate_category_html("Large Files", large_files, 
                                                large_size)
    
    # Old files
    old_files = data.get('old_files', [])
    if old_files:
        old_size = format_file_size(sum(f.get('size', 0) for f in old_files))
        categories_html += generate_category_html("Old Files", old_files, 
                                                old_size)
    
    # Unused files
    unused_files = data.get('unused_files', [])
    if unused_files:
        unused_size = format_file_size(sum(f.get('size', 0) for f in unused_files))
        categories_html += generate_category_html("Unused Files", unused_files, 
                                                unused_size)
    
    # Duplicate files
    duplicate_files = data.get('duplicate_files', [])
    if duplicate_files:
        duplicate_size = format_file_size(sum(f.get('size', 0) for f in duplicate_files))
        categories_html += generate_category_html("Duplicate Files", 
                                                duplicate_files, duplicate_size)
    
    # Replace template placeholders
    html_content = template.replace("{{GENERATION_DATE}}", generation_date)
    html_content = html_content.replace("{{TOTAL_FILES}}", str(total_files))
    html_content = html_content.replace("{{TOTAL_SIZE}}", total_size)
    html_content = html_content.replace("{{POTENTIAL_SAVINGS}}", 
                                      potential_savings)
    html_content = html_content.replace("{{CATEGORIES}}", categories_html)
    
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # Generate output filename
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    output_filename = f"enhanced_cleanup_report_{timestamp}.html"
    output_path = os.path.join(output_dir, output_filename)
    
    # Write enhanced HTML report
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(html_content)
    
    print(f"✅ Enhanced HTML report generated: {output_path}")
    print(f"📊 Report includes {total_files} files with interactive previews")
    print(f"🌐 Open in browser for the best experience")
    
    return output_path


def main():
    """Main function"""
    print("🗂️  Enhanced HTML Report Generator")
    print("==================================")
    
    # Find the most recent JSON report
    reports_dir = "cleanup_reports"
    if not os.path.exists(reports_dir):
        print(f"❌ Reports directory '{reports_dir}' not found")
        print("Run a cleanup scan first to generate reports")
        return
    
    json_files = [f for f in os.listdir(reports_dir) if f.endswith('.json')]
    if not json_files:
        print(f"❌ No JSON reports found in '{reports_dir}'")
        print("Run a cleanup scan first to generate reports")
        return
    
    # Get the most recent JSON report
    latest_json = max(json_files, key=lambda x: os.path.getctime(
        os.path.join(reports_dir, x)))
    json_path = os.path.join(reports_dir, latest_json)
    
    print(f"📁 Found latest report: {latest_json}")
    
    # Generate enhanced HTML report
    output_path = generate_enhanced_html_report(json_path)
    
    if output_path:
        print(f"\n🎉 Enhanced report ready!")
        print(f"📂 Location: {output_path}")
        print(f"🚀 Open in browser for interactive file management")
        
        # Ask if user wants to open it
        try:
            response = input("\nWould you like to open the report now? (y/n): "
                           ).lower().strip()
            if response in ['y', 'yes']:
                import subprocess
                subprocess.run(['open', output_path])
                print("✅ Report opened in browser")
        except KeyboardInterrupt:
            print("\n👋 Report generation completed")

def format_file_size(size_bytes: int) -> str:
    """Format file size in human readable format"""
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if size_bytes < 1024.0:
            return f"{size_bytes:.1f}{unit}"
        size_bytes /= 1024.0
    return f"{size_bytes:.1f}PB"

def get_risk_class(risk_score: float) -> str:
    """Get CSS class for risk score"""
    if risk_score >= 70:
        return "risk-high"
    elif risk_score >= 40:
        return "risk-medium"
    else:
        return "risk-low"

def generate_file_item_html(file_info: Dict[str, Any]) -> str:
    """Generate HTML for a single file item"""
    file_name = file_info.get('name', 'Unknown')
    file_path = file_info.get('path', '')
    file_size = format_file_size(file_info.get('size', 0))
    file_age = file_info.get('age_days', 0)
    risk_score = file_info.get('risk_score', 0)
    is_duplicate = file_info.get('is_duplicate', False)
    
    # Clean up file name display
    display_name = file_name
    if is_duplicate:
        display_name = f'<span class="duplicate-badge">Duplicate</span> {file_name}'
    
    risk_class = get_risk_class(risk_score)
    
    return f'''
            <div class="file-item">
                <div class="file-name">
                    {display_name}
                    <div class="file-path">{file_path}</div>
                </div>
                <div class="file-size">{file_size}</div>
                <div class="file-age">{file_age}</div>
                <div class="risk-score {risk_class}">{risk_score:.1f}</div>
                <div class="action-buttons">
                    <button class="btn btn-primary" onclick="showFilePreview('{file_path}')">👁️ Preview</button>
                    <button class="btn btn-secondary" onclick="openQuickLook('{file_path}')">🔍 Quick Look</button>
                </div>
            </div>'''

def generate_category_html(category_name: str, files: List[Dict[str, Any]], total_size: str) -> str:
    """Generate HTML for a file category"""
    if not files:
        return ""
    
    file_count = len(files)
    file_items_html = ""
    
    for file_info in files:
        file_items_html += generate_file_item_html(file_info)
    
    return f'''
    <div class="category">
        <h3>{category_name} ({file_count} files, {total_size})</h3>
        <div class="file-list">
            <div class="file-header">
                <div>File Name</div>
                <div>Size</div>
                <div>Age (days)</div>
                <div>Risk Score</div>
                <div>Actions</div>
            </div>
            {file_items_html}
        </div>
    </div>'''

def generate_enhanced_html_report(json_report_path: str, output_dir: str = "cleanup_reports"):
    """Generate enhanced HTML report from JSON data"""
    
    # Load cleanup data
    data = load_cleanup_data(json_report_path)
    if not data:
        print("No data loaded, cannot generate report")
        return
    
    # Load HTML template
    template_path = "enhanced_html_template.html"
    if not os.path.exists(template_path):
        print(f"Template file {template_path} not found")
        return
    
    with open(template_path, 'r', encoding='utf-8') as f:
        template = f.read()
    
    # Prepare data for template
    generation_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # Calculate totals
    total_files = data.get('total_files', 0)
    total_size = format_file_size(data.get('total_size_bytes', 0))
    potential_savings = format_file_size(data.get('potential_savings_bytes', 0))
    
    # Generate categories HTML
    categories_html = ""
    
    # Large files
    large_files = data.get('large_files', [])
    if large_files:
        large_size = format_file_size(sum(f.get('size', 0) for f in large_files))
        categories_html += generate_category_html("Large Files", large_files, large_size)
    
    # Old files
    old_files = data.get('old_files', [])
    if old_files:
        old_size = format_file_size(sum(f.get('size', 0) for f in old_files))
        categories_html += generate_category_html("Old Files", old_files, old_size)
    
    # Unused files
    unused_files = data.get('unused_files', [])
    if unused_files:
        unused_size = format_file_size(sum(f.get('size', 0) for f in unused_files))
        categories_html += generate_category_html("Unused Files", unused_files, unused_size)
    
    # Duplicate files
    duplicate_files = data.get('duplicate_files', [])
    if duplicate_files:
        duplicate_size = format_file_size(sum(f.get('size', 0) for f in duplicate_files))
        categories_html += generate_category_html("Duplicate Files", duplicate_files, duplicate_size)
    
    # Replace template placeholders
    html_content = template.replace("{{GENERATION_DATE}}", generation_date)
    html_content = html_content.replace("{{TOTAL_FILES}}", str(total_files))
    html_content = html_content.replace("{{TOTAL_SIZE}}", total_size)
    html_content = html_content.replace("{{POTENTIAL_SAVINGS}}", potential_savings)
    html_content = html_content.replace("{{CATEGORIES}}", categories_html)
    
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # Generate output filename
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    output_filename = f"enhanced_cleanup_report_{timestamp}.html"
    output_path = os.path.join(output_dir, output_filename)
    
    # Write enhanced HTML report
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(html_content)
    
    print(f"✅ Enhanced HTML report generated: {output_path}")
    print(f"📊 Report includes {total_files} files with interactive previews")
    print(f"🌐 Open in browser for the best experience")
    
    return output_path

def main():
    """Main function"""
    print("🗂️  Enhanced HTML Report Generator")
    print("==================================")
    
    # Find the most recent JSON report
    reports_dir = "cleanup_reports"
    if not os.path.exists(reports_dir):
        print(f"❌ Reports directory '{reports_dir}' not found")
        print("Run a cleanup scan first to generate reports")
        return
    
    json_files = [f for f in os.listdir(reports_dir) if f.endswith('.json')]
    if not json_files:
        print(f"❌ No JSON reports found in '{reports_dir}'")
        print("Run a cleanup scan first to generate reports")
        return
    
    # Get the most recent JSON report
    latest_json = max(json_files, key=lambda x: os.path.getctime(os.path.join(reports_dir, x)))
    json_path = os.path.join(reports_dir, latest_json)
    
    print(f"📁 Found latest report: {latest_json}")
    
    # Generate enhanced HTML report
    output_path = generate_enhanced_html_report(json_path)
    
    if output_path:
        print(f"\n🎉 Enhanced report ready!")
        print(f"📂 Location: {output_path}")
        print(f"🚀 Open in browser for interactive file management")
        
        # Ask if user wants to open it
        try:
            response = input("\nWould you like to open the report now? (y/n): ").lower().strip()
            if response in ['y', 'yes']:
                import subprocess
                subprocess.run(['open', output_path])
                print("✅ Report opened in browser")
        except KeyboardInterrupt:
            print("\n👋 Report generation completed")

if __name__ == "__main__":
    main()

# File Cleanup Workflow - Complete Setup Guide

## Overview

This comprehensive file cleanup workflow helps you efficiently find and review large and old files for potential deletion. It integrates with macOS Shortcuts and Quick Look to provide a seamless file review experience without opening files individually.

## Features

- **Smart File Detection**: Identifies large, old, and unused files
- **Quick Look Integration**: Preview files without opening them
- **Risk Scoring**: Prioritizes files based on size, age, and access patterns
- **Duplicate Detection**: Finds duplicate files to save space
- **Multiple Output Formats**: JSON, CSV, and HTML reports
- **macOS Shortcuts Integration**: Automated workflow execution
- **Database Tracking**: Maintains history of scans and file status

## Quick Start

### 1. Run a Quick Scan

```bash
python3 file_cleanup_workflow.py --quick-scan
```

This will scan common directories (~/Downloads, ~/Desktop, ~/Documents) and generate reports.

### 2. Create Shortcuts Workflow

```bash
python3 file_cleanup_workflow.py --create-shortcuts
```

This creates the macOS Shortcuts workflow files in the `shortcuts_workflows/` directory.

### 3. Custom Directory Scan

```bash
python3 file_cleanup_workflow.py --directories ~/Pictures ~/Movies
```

Scan specific directories of your choice.

## Installation & Setup

### Prerequisites

- macOS 10.15 or later
- Python 3.7+
- Required Python packages (install via pip):

```bash
pip3 install pathlib dataclasses
```

### Configuration

The system automatically creates a `cleanup_config.json` file on first run. You can customize:

```json
{
  "scan_directories": [
    "~/Downloads",
    "~/Desktop",
    "~/Documents",
    "~/Pictures",
    "~/Movies",
    "~/Music"
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
  }
}
```

## macOS Shortcuts Integration

### Importing the Workflow

1. **Open Shortcuts app** on your Mac
2. **Import the workflow**: File → Import → Select `File_Cleanup_Workflow.shortcut`
3. **Customize the workflow** as needed

### Workflow Components

The Shortcuts workflow includes:

1. **Get Files from Folder**: Scans specified directories
2. **Filter Large Files**: Identifies files above size threshold (100MB default)
3. **Quick Look Files**: Opens files in Quick Look for review
4. **Show Results**: Displays filtered file list

### Customizing the Workflow

You can modify the workflow to:

- Change the size threshold (currently 100MB)
- Add age-based filtering
- Include different directories
- Add file type filtering
- Integrate with other apps

## Quick Look Integration

### Using the Quick Look Script

The `quicklook_integration.sh` script provides several functions:

```bash
# Open single file in Quick Look
./shortcuts_workflows/quicklook_integration.sh single /path/to/file.pdf

# Batch Quick Look from file list
./shortcuts_workflows/quicklook_integration.sh batch file_list.txt

# Open file in Finder
./shortcuts_workflows/quicklook_integration.sh finder /path/to/file.pdf

# Create file list for batch operations
./shortcuts_workflows/quicklook_integration.sh list files_to_review.txt file1.pdf file2.pdf file3.pdf
```

### Keyboard Shortcuts

- **Space bar**: Quick Look any selected file in Finder
- **Q**: Quick Look from the HTML report interface
- **Cmd+Shift+P**: Quick Look in Preview app

## Report Types

### 1. HTML Report

The HTML report provides an interactive interface with:

- **File categorization** by size, age, and usage
- **Risk scoring** to prioritize deletion candidates
- **Quick Look buttons** for each file
- **Duplicate file identification**
- **Potential space savings** calculations

### 2. CSV Report

Export data for analysis in:

- Excel/Numbers
- Database systems
- Custom scripts
- Data visualization tools

### 3. JSON Report

Programmatic access to:

- File metadata
- Risk scores
- Categorization data
- Scan statistics

## Advanced Usage

### Batch Operations

```bash
# Create a list of high-risk files
python3 file_cleanup_workflow.py --quick-scan
grep "high_risk" cleanup_reports/*.json > high_risk_files.txt

# Quick Look all high-risk files
./shortcuts_workflows/quicklook_integration.sh batch high_risk_files.txt
```

### Scheduled Cleanup

Add to your crontab for regular scans:

```bash
# Weekly cleanup scan every Sunday at 2 AM
0 2 * * 0 cd /path/to/workflow && python3 file_cleanup_workflow.py --quick-scan
```

### Integration with Hazel

If you use Hazel for file organization, you can:

1. **Scan Hazel-managed folders** for cleanup candidates
2. **Use Hazel rules** to move files to review folders
3. **Automate cleanup** based on file patterns

## File Categories

### Large Files (>100MB)

- **Videos**: Movies, recordings, screen captures
- **Disk images**: .dmg, .iso files
- **Archives**: Large zip files, backups
- **Databases**: Large data files

### Old Files (>1 year)

- **Downloads**: Old software versions
- **Documents**: Outdated reports, drafts
- **Media**: Old photos, videos
- **Backups**: Superseded backups

### Unused Files (>6 months since access)

- **Temporary files**: Cache, temp, log files
- **Old projects**: Completed work, archives
- **Media**: Unused photos, videos, music
- **Downloads**: Forgotten downloads

### Duplicate Files

- **Identical content**: Same file, different names
- **Similar files**: Different versions, formats
- **Backup copies**: Multiple backups of same data

## Risk Scoring

Files are scored 0-100 based on:

- **Size (40%)**: Larger files get higher scores
- **Age (30%)**: Older files get higher scores  
- **Access (30%)**: Less recently accessed files get higher scores

**Risk Levels:**
- **Low (0-40)**: Generally safe to keep
- **Medium (41-70)**: Consider for deletion
- **High (71-100)**: Strong deletion candidates

## Safety Features

### Before Deletion

1. **Review in Quick Look**: Preview file content
2. **Check file path**: Verify location and context
3. **Assess importance**: Consider if file is needed
4. **Backup if unsure**: Move to review folder first

### Safe Deletion Process

```bash
# Move to review folder instead of deleting
mkdir -p ~/Desktop/Review_Folder
mv /path/to/file ~/Desktop/Review_Folder/

# After review period, delete if confirmed safe
rm ~/Desktop/Review_Folder/file
```

## Troubleshooting

### Common Issues

1. **Permission Denied**
   ```bash
   # Check file permissions
   ls -la /path/to/file
   
   # Fix permissions if needed
   chmod 644 /path/to/file
   ```

2. **Quick Look Not Working**
   ```bash
   # Reset Quick Look cache
   qlmanage -r
   qlmanage -r cache
   ```

3. **Large Scan Times**
   - Reduce `max_scan_depth` in config
   - Exclude more directories
   - Use `--quick-scan` for common locations only

### Performance Tips

- **Scan during off-peak hours** for large directories
- **Use SSD storage** for faster file access
- **Limit scan depth** for deep directory structures
- **Exclude system directories** to avoid permission issues

## Integration Examples

### With Alfred

Create an Alfred workflow that:

1. **Triggers** on keyword "cleanup"
2. **Runs** the Python script
3. **Opens** the HTML report
4. **Integrates** with Quick Look

### With Keyboard Maestro

Create a Keyboard Maestro macro that:

1. **Scans** specified folders
2. **Filters** by criteria
3. **Opens** files in Quick Look
4. **Records** decisions for batch processing

### With Automator

Create an Automator workflow that:

1. **Receives** folder selection
2. **Runs** the cleanup script
3. **Opens** results in Finder
4. **Integrates** with Quick Look

## Best Practices

### Regular Maintenance

- **Weekly scans** of active directories
- **Monthly scans** of all directories
- **Quarterly deep scans** for comprehensive cleanup
- **Annual review** of old files

### File Organization

- **Use consistent naming** conventions
- **Organize by project** or date
- **Regular archiving** of completed work
- **Backup important files** before deletion

### Risk Management

- **Start with large files** for maximum space savings
- **Review before deletion** using Quick Look
- **Keep backups** of important data
- **Document deletion decisions** for future reference

## Support & Updates

### Getting Help

- Check the log file: `file_cleanup.log`
- Review configuration: `cleanup_config.json`
- Test with small directories first
- Use `--help` for command options

### Contributing

To improve the workflow:

1. **Report issues** with detailed error messages
2. **Suggest features** for better integration
3. **Share workflows** you've created
4. **Improve documentation** and examples

## Conclusion

This file cleanup workflow provides a powerful, efficient way to manage your digital files. By combining automated scanning with Quick Look integration, you can quickly identify and review files for potential deletion, saving significant disk space while maintaining control over the process.

The system is designed to be safe, efficient, and customizable, allowing you to adapt it to your specific needs and workflow preferences.

# Research File Management Automation Setup Guide
## For Masters of Education Studies

This guide will help you set up a fully automated research file management system that will keep your Mac organized and your research files properly categorized.

## 🚀 Quick Start

1. **Install Dependencies** (see below)
2. **Configure the system** (see Configuration section)
3. **Set up Hazel rules** (see Hazel Setup)
4. **Run the Python script** to process existing files
5. **Enjoy automated organization!**

## 📦 Required Dependencies

### Python Packages (already installed in your environment)
- ✅ PyPDF2 - PDF metadata extraction
- ✅ python-docx - DOCX metadata extraction  
- ✅ bibtexparser - BibTeX parsing
- ✅ pyzotero - Zotero integration
- ✅ watchdog - File system monitoring

### System Tools
```bash
# Install Homebrew if you don't have it
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required tools
brew install poppler  # For pdfinfo command
brew install calibre  # For Calibre integration
```

## ⚙️ Configuration

### 1. Basic Configuration
The system will create a `config.json` file automatically. Edit it to customize:

```json
{
  "source_directories": [
    "~/Downloads",
    "~/Desktop",
    "~/Documents/Inbox"
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
    "use_author_year": true,
    "use_original_name": false,
    "add_timestamp": true
  },
  "auto_organization": {
    "enabled": true,
    "move_files": true,
    "create_backup": true
  }
}
```

### 2. Zotero Configuration
1. Go to [Zotero.org](https://www.zotero.org) and create an account
2. Get your API key: Settings → API → Create API Key
3. Note your User ID from the URL when logged in
4. Update the config.json with your credentials

### 3. Calibre Configuration
1. Install Calibre from [calibre-ebook.com](https://calibre-ebook.com)
2. Note the path to your Calibre library
3. Update the config.json with the correct path

## 🔧 Hazel Setup (Mac Automation)

### 1. Install Hazel
- Download from [Noodlesoft.com](https://www.noodlesoft.com)
- Install and grant necessary permissions

### 2. Create Hazel Rules

#### Rule 1: Research Papers (PDFs)
- **Folder**: Downloads
- **Conditions**: 
  - Extension is pdf
  - Name contains "research" OR "study" OR "paper"
- **Actions**: 
  - Run shell script: `./hazel_rules.sh "$1"`
  - Move to folder: Research/Papers

#### Rule 2: Academic Documents (DOCX/DOC)
- **Folder**: Downloads  
- **Conditions**: Extension is docx OR doc
- **Actions**:
  - Run shell script: `./hazel_rules.sh "$1"`
  - Move to folder: Research/Documents

#### Rule 3: Data Files
- **Folder**: Downloads
- **Conditions**: Extension is csv OR xlsx OR json
- **Actions**:
  - Run shell script: `./hazel_rules.sh "$1"`
  - Move to folder: Research/Data

### 3. Make Hazel Script Executable
```bash
chmod +x hazel_rules.sh
```

## 🐍 Python Script Usage

### Basic Commands

```bash
# Process all source directories once
python3 research_file_manager.py --process-all

# Process a specific directory
python3 research_file_manager.py --process ~/Downloads

# Start watching mode (continuous monitoring)
python3 research_file_manager.py --watch

# Use custom config file
python3 research_file_manager.py --config my_config.json
```

### File Processing Features

1. **Automatic Categorization**: Files are sorted by type and content
2. **Metadata Extraction**: 
   - PDF: Title, author, subject, page count
   - DOCX: Core properties, text content
   - BibTeX: Citation information
3. **Smart Naming**: Author_Year_Title format
4. **Zotero Integration**: Automatic addition to research library
5. **Calibre Integration**: Book management

## 📁 Directory Structure

After setup, your research will be organized as:

```
~/Documents/Research/
├── papers/           # Academic papers, articles
├── books/            # Books, textbooks, ebooks  
├── reports/          # Research reports, white papers
├── presentations/    # Slides, presentations
├── data/            # Datasets, spreadsheets
└── unsorted/        # Uncategorized files
```

Each file gets:
- Standardized filename
- Metadata file (.metadata.json)
- Proper categorization
- Zotero entry (if applicable)

## 🔄 Automation Workflow

### 1. File Arrival
- File downloaded to monitored folder
- Hazel detects new file
- Hazel script processes and categorizes
- File moved to appropriate research folder
- Metadata extracted and saved
- Zotero entry created (if applicable)

### 2. Continuous Monitoring
- Python script watches for new files
- Automatic processing and organization
- Logging of all activities
- Error handling and recovery

### 3. Manual Processing
- Run script on existing files
- Batch processing of large collections
- Custom directory processing

## 🛠️ Troubleshooting

### Common Issues

1. **Permission Errors**
   ```bash
   chmod +x hazel_rules.sh
   chmod +x research_file_manager.py
   ```

2. **Python Path Issues**
   ```bash
   # Use the virtual environment
   source research_env/bin/activate
   python research_file_manager.py
   ```

3. **Hazel Not Working**
   - Check System Preferences → Security & Privacy
   - Ensure Hazel has full disk access
   - Verify script permissions

4. **Zotero Integration Fails**
   - Verify API key and library ID
   - Check internet connection
   - Review Zotero API limits

### Log Files

- **Python Script**: `research_file_manager.log`
- **Hazel Script**: `~/Library/Logs/hazel_research.log`

## 📚 Advanced Features

### 1. Custom Categories
Add new categories in config.json:

```json
"categories": {
  "thesis": ["pdf", "docx"],
  "conferences": ["pdf", "pptx"],
  "datasets": ["csv", "xlsx", "json"]
}
```

### 2. Custom File Naming
Modify naming rules in config.json:

```json
"file_naming": {
  "use_author_year": true,
  "use_original_name": false,
  "add_timestamp": true,
  "custom_format": "Author_Year_Type_Title"
}
```

### 3. Backup and Recovery
Enable backup creation:

```json
"auto_organization": {
  "create_backup": true,
  "backup_location": "~/Documents/Research/Backups"
}
```

## 🎯 Best Practices

1. **Regular Maintenance**
   - Review unsorted folder weekly
   - Clean up broken symlinks
   - Update Zotero collections

2. **File Naming**
   - Use descriptive names when downloading
   - Include author and year in filename
   - Avoid special characters

3. **Backup Strategy**
   - Regular backups of research folder
   - Cloud sync for important papers
   - Version control for data files

4. **Integration Workflow**
   - Download → Auto-organize → Zotero → Cite
   - Keep original downloads as symlinks
   - Use research folders as primary storage

## 🚀 Getting Started Checklist

- [ ] Install system dependencies (poppler, calibre)
- [ ] Configure config.json with your preferences
- [ ] Set up Zotero API credentials
- [ ] Install and configure Hazel
- [ ] Create Hazel rules for automation
- [ ] Test with sample files
- [ ] Process existing research files
- [ ] Enable continuous monitoring
- [ ] Set up regular backups

## 📞 Support

For issues or questions:
1. Check the log files for error messages
2. Review this setup guide
3. Test with simple files first
4. Verify all permissions and paths

## 🔮 Future Enhancements

- AI-powered content analysis
- Automatic citation generation
- Research topic clustering
- Integration with reference managers
- Cloud storage synchronization
- Mobile app for file management

---

**Happy Researching! 🎓**

This system will keep your research files organized automatically, so you can focus on your Masters of Education studies instead of file management.

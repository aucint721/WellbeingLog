# Research Workflow Integration - Complete System

## 🎯 Overview
Your research system is now fully integrated with **Bean** (for writing), **TexStudio** (for LaTeX), **LaTeX compilation**, and **SciSpace** (for online research). This creates a seamless workflow from initial research to final submission.

## 🚀 What's Been Integrated

### 1. **Bean Integration** 📝
- **Automatic Detection**: System automatically detects RTF/DOC/DOCX files
- **Smart Opening**: Research documents automatically open in Bean
- **Template Creation**: Pre-built research templates (articles, thesis, reports)
- **Path**: `/Applications/Bean.app`

### 2. **TexStudio Integration** 📊
- **LaTeX Support**: Automatic detection of .tex files
- **Smart Opening**: LaTeX documents automatically open in TexStudio
- **Path**: `/Applications/texstudio-4.8.6-osx.app/Contents/MacOS/texstudio`

### 3. **LaTeX Compilation** 🔨
- **Automatic Compilation**: Compile .tex files to PDF with one command
- **Bibliography Support**: Automatic BibTeX processing
- **Multiple Passes**: Handles references and cross-references correctly
- **Path**: `/Library/TeX/texbin/pdflatex`

### 4. **SciSpace Integration** 🔬
- **Export Processing**: Automatically processes SciSpace exports
- **Metadata Extraction**: Extracts research metadata
- **Research Integration**: Integrates exports into your research system
- **Export Directory**: `~/Documents/Research/SciSpace_Exports`

### 5. **BibDesk Integration** 📚
- **Bibliography Management**: Integrated with TeX distribution
- **Path**: `/Applications/TeX/BibDesk.app`
- **Library Path**: `~/Documents/Research/Bibliography`

## 📁 New File Categories Added

Your system now automatically categorizes these additional file types:

- **Writing**: `rtf`, `rtfd`, `doc`, `docx` → Opens in Bean
- **LaTeX**: `tex`, `bib`, `sty`, `cls`, `bbl` → Opens in TexStudio
- **Templates**: `template`, `tpl` → Organized template management

## 🛠️ New Workflow Commands

### **Create Research Project**
```bash
python3 research_workflow.py create "Project_Name" --type article
python3 research_workflow.py create "My_Thesis" --type thesis
python3 research_workflow.py create "Technical_Report" --type report
```

### **Open Project in Editor**
```bash
python3 research_workflow.py open "Project_Name" --editor bean
python3 research_workflow.py open "Project_Name" --editor texstudio
python3 research_workflow.py open "Project_Name" --editor auto
```

### **Compile LaTeX Project**
```bash
python3 research_workflow.py compile "Project_Name"
```

### **List All Projects**
```bash
python3 research_workflow.py list
```

### **Process SciSpace Export**
```bash
python3 research_workflow.py scispace "export_file.pdf"
```

## 📂 Project Structure

Each research project now creates this organized structure:

```
Project_Name/
├── Research/          # Research materials and sources
├── Writing/           # Writing files (RTF, LaTeX, DOC)
├── Drafts/            # Working drafts
├── Final/             # Final compiled documents
├── Bibliography/      # References and citations
└── project_metadata.json
```

## 🔄 Complete Workflow

### **1. Research Phase**
- Use SciSpace for online research
- Export findings → Automatically processed and organized
- Files categorized by type and metadata extracted

### **2. Writing Phase**
- Create new research project with templates
- Write in Bean (RTF) or TexStudio (LaTeX)
- Automatic file organization and metadata

### **3. Compilation Phase**
- LaTeX projects automatically compile to PDF
- Bibliography processing included
- Final documents organized in Final/ directory

### **4. Submission Phase**
- Final PDFs ready for submission
- All source materials organized and accessible
- Complete project history maintained

## 🎨 Templates Available

### **Article Templates**
- Standard journal article structure
- Abstract, Introduction, Methods, Results, Discussion, Conclusion
- Available in both RTF (Bean) and LaTeX (TexStudio)

### **Thesis Templates**
- Complete thesis/dissertation structure
- Chapter-based organization
- Table of contents, figures, and tables

### **Report Templates**
- Technical report structure
- Executive summary and recommendations
- Professional formatting

## 🔧 Configuration

All integrations are configured in `config.json`:

```json
{
  "writing_tools": {
    "bean": {
      "path": "/Applications/Bean.app",
      "enabled": true,
      "templates_dir": "~/Documents/Research/Templates/Bean"
    },
    "texstudio": {
      "path": "/Applications/texstudio-4.8.6-osx.app/Contents/MacOS/texstudio",
      "enabled": true,
      "templates_dir": "~/Documents/Research/Templates/LaTeX"
    },
    "latex": {
      "path": "/Library/TeX/texbin",
      "enabled": true,
      "compiler": "pdflatex",
      "bibtex": "bibtex"
    }
  },
  "research_tools": {
    "scispace": {
      "enabled": true,
      "export_dir": "~/Documents/Research/SciSpace_Exports"
    },
    "bibdesk": {
      "path": "/Applications/TeX/BibDesk.app",
      "enabled": true,
      "library_path": "~/Documents/Research/Bibliography"
    }
  }
}
```

## 🚀 Getting Started

### **1. Create Your First Project**
```bash
python3 research_workflow.py create "My_Research" --type article
```

### **2. Start Writing**
```bash
python3 research_workflow.py open "My_Research" --editor bean
```

### **3. Process SciSpace Exports**
```bash
python3 research_workflow.py scispace "~/Downloads/scispace_export.pdf"
```

### **4. Compile LaTeX (if using)**
```bash
python3 research_workflow.py compile "My_Research"
```

## 🔍 File Processing

### **Automatic Categorization**
- **Research files** → Papers, books, data, screenshots, videos, audio
- **Writing files** → RTF, DOC, DOCX (opens in Bean)
- **LaTeX files** → TEX, BIB, STY, CLS (opens in TexStudio)
- **E-books** → EPUB, MOBI, AZW3 (added to Calibre)

### **Metadata Extraction**
- **PDFs**: Title, author, subject, keywords
- **Documents**: Title, author, creation date, modification date
- **E-books**: Title, author, publisher, language, tags
- **Images**: Dimensions, color space, creation date
- **Videos**: Duration, dimensions, codec, creation date

## 🎯 Benefits

1. **Streamlined Workflow**: From research to submission in one system
2. **Automatic Organization**: Files categorized and metadata extracted automatically
3. **Template System**: Professional templates for all document types
4. **Tool Integration**: Seamless switching between Bean and TexStudio
5. **LaTeX Compilation**: One-command PDF generation with bibliography
6. **Research Integration**: SciSpace exports automatically processed
7. **Project Management**: Organized project structure with metadata

## 🔮 Future Enhancements

- **Zotero API Integration**: Direct citation management
- **Cloud Sync**: Research files synced across devices
- **Collaboration**: Multi-author project support
- **Version Control**: Document version tracking
- **AI Integration**: Smart research suggestions

## ✅ System Status

- **Bean Integration**: ✅ Working
- **TexStudio Integration**: ✅ Working
- **LaTeX Compilation**: ✅ Working
- **SciSpace Integration**: ✅ Ready
- **BibDesk Integration**: ✅ Ready
- **Hazel Automation**: ✅ Updated
- **File Categorization**: ✅ Enhanced
- **Workflow Management**: ✅ Complete

Your research system is now a **complete, integrated workflow** that handles everything from initial research to final submission! 🎉

# 🎯 Comprehensive File Organization System Setup

## **📁 Centralized File Intake System**

This system creates a single "catch-all" folder that Hazel monitors to intelligently route all incoming files to appropriate locations.

### **🏗️ Directory Structure Created:**

```
~/Documents/Research/
├── File_Intake/                    # 🎯 CENTRAL MONITORING FOLDER
│   ├── Safari_Downloads/          # Safari default downloads
│   ├── TexStudio_Projects/        # TexStudio default save location
│   ├── Bean_Documents/            # Bean default save location
│   └── General_Uploads/           # Catch-all for other files
├── Organized_Research/             # Course-specific organization
├── Archives/By_Type/              # Type-based archives
├── Projects/                       # Project-specific folders
└── Logs/                          # Processing logs
```

## **⚙️ Application Default Directory Settings**

### **1. Safari Browser**
- **Downloads Folder**: `~/Documents/Research/File_Intake/Safari_Downloads`
- **Setup**: Safari → Preferences → General → File download location
- **Benefits**: All web downloads automatically go through Hazel processing

### **2. TexStudio (LaTeX Editor)**
- **Default Save Location**: `~/Documents/Research/File_Intake/TexStudio_Projects`
- **Setup**: TexStudio → Options → Configure TexStudio → General → Default Document Directory
- **Benefits**: LaTeX files automatically create project structures

### **3. Bean (Word Processor)**
- **Default Save Location**: `~/Documents/Research/File_Intake/Bean_Documents`
- **Setup**: Bean → Preferences → General → Default Save Location
- **Benefits**: Documents automatically organized by type and content

### **4. Other Applications**
- **Default Save Location**: `~/Documents/Research/File_Intake/General_Uploads`
- **Applications**: Preview, QuickTime, TextEdit, etc.
- **Benefits**: All files automatically processed and organized

## **🔧 Hazel Rules Setup**

### **Rule 1: File Intake Monitoring (High Priority)**

#### **Rule Settings:**
- **Name**: `File Intake Auto-Process`
- **Folder**: `~/Documents/Research/File_Intake`
- **Enabled**: ✅ Yes

#### **Conditions:**
- **File is not hidden** ✅
- **File exists** ✅
- **File is not in subfolder** ✅

#### **Actions:**
1. **Run shell script**: `~/Documents/Research/hazel_intake_automation.sh "$1"`
2. **Delete original** ✅ (after processing)

#### **Advanced Options:**
- **Run on subfolders**: ❌ No (only root level)
- **Run on files added**: ✅ Yes
- **Run on files modified**: ❌ No

### **Rule 2: Safari Downloads Auto-Route (Medium Priority)**

#### **Rule Settings:**
- **Name**: `Safari Downloads Auto-Route`
- **Folder**: `~/Documents/Research/File_Intake/Safari_Downloads`
- **Enabled**: ✅ Yes

#### **Conditions:**
- **File is not hidden** ✅
- **File exists** ✅

#### **Actions:**
1. **Run shell script**: `~/Documents/Research/hazel_intake_automation.sh "$1"`
2. **Delete original** ✅

### **Rule 3: TexStudio Projects Auto-Process (Medium Priority)**

#### **Rule Settings:**
- **Name**: `TexStudio Projects Auto-Process`
- **Folder**: `~/Documents/Research/File_Intake/TexStudio_Projects`
- **Enabled**: ✅ Yes

#### **Conditions:**
- **File is not hidden** ✅
- **File exists** ✅

#### **Actions:**
1. **Run shell script**: `~/Documents/Research/hazel_intake_automation.sh "$1"`
2. **Delete original** ✅

## **🚀 How It Works**

### **1. File Intake Process:**
1. **File arrives** in any File_Intake subfolder
2. **Hazel detects** the new file
3. **Automation script runs** to analyze the file
4. **Intelligent routing** based on file type and content
5. **File organized** into appropriate location
6. **Original removed** from intake folder

### **2. Intelligent File Processing:**

#### **Research Documents (PDF, DOC, DOCX):**
- **Course detection** using intelligent workflow
- **Zotero upload** with proper collection assignment
- **Course-specific organization** by year
- **Enhanced metadata** and tagging

#### **LaTeX Files:**
- **Project structure creation** (Research, Writing, Drafts, Final, Bibliography)
- **Automatic organization** by file type
- **Project naming** based on content

#### **Images:**
- **Date-based organization** (YYYY/MM)
- **Metadata extraction** and organization
- **Smart naming** with type prefixes

#### **Audio/Video:**
- **Audio files** → Transcription folder
- **Video files** → Media archives
- **Date-based organization**

#### **E-books:**
- **Calibre integration** (if available)
- **Research archives** backup
- **Smart categorization**

#### **Code Files:**
- **Development project structure** (src, tests, docs, resources)
- **Language-specific organization**
- **Project naming** from content

## **📋 Setup Instructions**

### **Step 1: Create Directory Structure**
```bash
cd ~/Documents/Research
mkdir -p File_Intake/{Safari_Downloads,TexStudio_Projects,Bean_Documents,General_Uploads}
mkdir -p Organized_Research Archives/By_Type Projects Logs
```

### **Step 2: Set Application Defaults**

#### **Safari:**
1. Open Safari
2. Safari → Preferences → General
3. Set "File download location" to: `~/Documents/Research/File_Intake/Safari_Downloads`

#### **TexStudio:**
1. Open TexStudio
2. Options → Configure TexStudio → General
3. Set "Default Document Directory" to: `~/Documents/Research/File_Intake/TexStudio_Projects`

#### **Bean:**
1. Open Bean
2. Bean → Preferences → General
3. Set "Default Save Location" to: `~/Documents/Research/File_Intake/Bean_Documents`

### **Step 3: Hazel Rules Setup**

#### **Primary Rule (File Intake):**
1. Open Hazel application
2. Add `~/Documents/Research/File_Intake` folder
3. Create rule: "File Intake Auto-Process"
4. Set conditions and actions as specified above
5. Enable the rule

#### **Secondary Rules (Subfolder Monitoring):**
1. Create rules for each subfolder
2. Set to run the same automation script
3. Enable all rules

### **Step 4: Test the System**

#### **Test with Safari Download:**
1. Download a PDF from any website
2. File should automatically appear in `File_Intake/Safari_Downloads`
3. Hazel should process it within seconds
4. Check `Organized_Research` for organized file
5. Check `Logs/hazel_intake.log` for processing details

#### **Test with TexStudio:**
1. Create a new LaTeX document
2. Save it to `File_Intake/TexStudio_Projects`
3. Hazel should create project structure
4. Check `Projects` folder for new project

## **🎯 Benefits of This System**

### **1. Centralized Control:**
- **Single monitoring point** for all file types
- **Consistent processing** across all applications
- **Easy troubleshooting** and monitoring

### **2. Intelligent Organization:**
- **Course detection** for research materials
- **Content-based routing** for different file types
- **Automatic metadata** extraction and tagging

### **3. Seamless Integration:**
- **Zotero integration** for research materials
- **Calibre integration** for e-books
- **Project structure** creation for development

### **4. Time Savings:**
- **No manual organization** required
- **Automatic file naming** and categorization
- **Instant access** to organized materials

### **5. Consistency:**
- **Standardized naming** conventions
- **Uniform folder structures** across projects
- **Predictable file locations**

## **🔍 Monitoring and Maintenance**

### **Log Files:**
- **Location**: `~/Documents/Research/Logs/hazel_intake.log`
- **Content**: Processing details, errors, file movements
- **Rotation**: Automatic log rotation for space management

### **Performance Monitoring:**
- **Processing time**: Usually under 5 seconds per file
- **Error handling**: Automatic fallback to type-based organization
- **Resource usage**: Minimal CPU and memory impact

### **Troubleshooting:**
- **Check logs** for error messages
- **Verify Hazel permissions** (Full Disk Access)
- **Test automation script** manually if needed
- **Check file permissions** in intake folders

## **🚀 Next Steps**

1. **Set up Hazel rules** as described above
2. **Configure application defaults** for your main tools
3. **Test with sample files** to verify functionality
4. **Monitor logs** for the first few days
5. **Adjust rules** based on your specific needs

## **💡 Pro Tips**

- **Start small**: Begin with one or two applications
- **Monitor closely**: Watch logs during initial setup
- **Test thoroughly**: Use different file types and sizes
- **Backup first**: Ensure your important files are backed up
- **Iterate**: Refine rules based on actual usage patterns

This system will transform your file organization from manual chaos to automated intelligence! 🎉

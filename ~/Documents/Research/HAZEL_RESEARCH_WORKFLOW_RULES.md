# 🔬 Hazel Research Workflow Rules Setup

## **🎯 Specialized Automation for Your Research Workflow**

This guide sets up Hazel rules specifically designed to work with your Zotero Safari plugin and research workflow automation system.

## **📋 Research Workflow Rules to Create**

### **Rule 1: Research Downloads Auto-Process (High Priority)**

#### **Rule Settings:**
- **Name**: `Research Downloads Auto-Process`
- **Folder**: `Downloads`
- **Enabled**: ✅ Yes

#### **Conditions:**
- **File is not in Research folder** ✅
- **File is not hidden** ✅
- **File exists** ✅
- **File extension is one of**: `pdf, doc, docx, epub, mobi, txt, md`

#### **Actions:**
1. **Run shell script**: `~/Documents/Research/research_workflow_automation.py --process "$1"`
2. **Move to**: `~/Documents/Research/Organized_Research` (temporary)
3. **Delete original** ✅

#### **Advanced Options:**
- **Run on subfolders**: ✅ Yes
- **Run on files added**: ✅ Yes
- **Run on files modified**: ❌ No

---

### **Rule 2: Zotero Webpage Snapshots (Medium Priority)**

#### **Rule Settings:**
- **Name**: `Zotero Webpage Snapshots`
- **Folder**: `Downloads`
- **Enabled**: ✅ Yes

#### **Conditions:**
- **File is not in Research folder** ✅
- **File is not hidden** ✅
- **File exists** ✅
- **File name contains**: `zotero` OR `snapshot` OR `webpage`

#### **Actions:**
1. **Run shell script**: `~/Documents/Research/research_workflow_automation.py --process "$1"`
2. **Move to**: `~/Documents/Research/Organized_Research/Zotero_Snapshots`
3. **Delete original** ✅

---

### **Rule 3: Research PDFs (High Priority)**

#### **Rule Settings:**
- **Name**: `Research PDFs Auto-Process`
- **Folder**: `Downloads`
- **Enabled**: ✅ Yes

#### **Conditions:**
- **File is not in Research folder** ✅
- **File is not hidden** ✅
- **File exists** ✅
- **File extension is**: `pdf`
- **File name contains**: `research` OR `paper` OR `study` OR `thesis` OR `article`

#### **Actions:**
1. **Run shell script**: `~/Documents/Research/research_workflow_automation.py --process "$1"`
2. **Move to**: `~/Documents/Research/Organized_Research/Academic_Papers`
3. **Delete original** ✅

---

### **Rule 4: E-books and Reading Materials (Medium Priority)**

#### **Rule Settings:**
- **Name**: `E-books Auto-Process`
- **Folder**: `Downloads`
- **Enabled**: ✅ Yes

#### **Conditions:**
- **File is not in Research folder** ✅
- **File is not hidden** ✅
- **File exists** ✅
- **File extension is one of**: `epub, mobi, azw3, pdf`

#### **Actions:**
1. **Run shell script**: `~/Documents/Research/research_workflow_automation.py --process "$1"`
2. **Move to**: `~/Documents/Research/Organized_Research/Books_Ebooks`
3. **Delete original** ✅

---

### **Rule 5: Research Documents (Medium Priority)**

#### **Rule Settings:**
- **Name**: `Research Documents Auto-Process`
- **Folder**: `Downloads`
- **Enabled**: ✅ Yes

#### **Conditions:**
- **File is not in Research folder** ✅
- **File is not hidden** ✅
- **File exists** ✅
- **File extension is one of**: `doc, docx, rtf, txt, md`

#### **Actions:**
1. **Run shell script**: `~/Documents/Research/research_workflow_automation.py --process "$1"`
2. **Move to**: `~/Documents/Research/Organized_Research/Reports_Documents`
3. **Delete original** ✅

---

## **🔧 Step-by-Step Setup in Hazel**

### **Step 1: Open Hazel**
1. Launch Hazel from Applications
2. Click the **"+"** button to add Downloads folder

### **Step 2: Create Research Downloads Rule**
1. **Select Downloads folder**
2. **Click the "+" button** to add a rule
3. **Name**: `Research Downloads Auto-Process`
4. **Set conditions** as specified above
5. **Set actions** as specified above
6. **Save the rule**

### **Step 3: Test with a Research File**
1. **Download a research PDF** to your Downloads folder
2. **Watch Hazel process it** automatically
3. **Check the Organized_Research folder** for the processed file
4. **Verify Zotero integration** (if configured)
5. **Check Calibre** for the archived file

### **Step 4: Enable All Rules**
1. **Enable each rule** by checking the box
2. **Set priorities** (High/Medium/Low)
3. **Test with real research files**

---

## **🎯 What This System Will Do Automatically**

### **For Every Research File You Download:**

✅ **Detect research materials** automatically  
✅ **Extract comprehensive metadata** (title, author, pages, etc.)  
✅ **Upload to Zotero** with proper tags and categorization  
✅ **Archive in Calibre** for long-term storage  
✅ **Organize into logical folders** by category and year  
✅ **Generate research summaries** for tracking  
✅ **Clean up Downloads folder** automatically  

### **Handles These Scenarios:**

🔍 **Zotero Safari plugin works perfectly** → File gets processed and archived  
🔍 **Zotero only takes webpage snapshot** → PDF gets auto-uploaded to Zotero  
🔍 **Manual PDF download required** → File gets processed automatically  
🔍 **Multiple file types** → Each gets handled appropriately  
🔍 **Batch downloads** → All get processed in sequence  

---

## **⚙️ Configuration Requirements**

### **Zotero API Setup:**
1. **Get your API key** from Zotero website
2. **Get your library ID** from Zotero
3. **Update config.json** with your credentials
4. **Test with a small file** first

### **Calibre Setup:**
1. **Ensure Calibre is installed** and working
2. **Verify command-line tools** are accessible
3. **Set library path** in configuration

### **File Permissions:**
1. **Hazel has full disk access** ✅ (You already have this!)
2. **Python script is executable**
3. **All target folders** are accessible

---

## **🧪 Testing Your Setup**

### **Quick Test (2 minutes):**
1. **Download a research PDF** to Downloads
2. **Watch Hazel process it** in real-time
3. **Check Organized_Research folder**
4. **Verify file was processed** correctly

### **Full Test (5 minutes):**
1. **Test with different file types** (PDF, DOC, EPUB)
2. **Check Zotero integration** (if configured)
3. **Verify Calibre archiving** (if configured)
4. **Review research summaries** generated

---

## **📊 Expected Results**

### **Immediate Benefits:**
- **Downloads folder stays clean** automatically
- **Research files get organized** instantly
- **No more manual file management** needed
- **Consistent file naming** and organization

### **Long-term Benefits:**
- **Complete research library** in Zotero
- **Organized Calibre archive** for reading
- **Searchable research database** across all tools
- **Professional research workflow** that scales

---

## **🚀 Getting Started Right Now**

### **Quick Setup (5 minutes):**
1. **Open Hazel**
2. **Add Downloads folder**
3. **Create Research Downloads rule** (copy from above)
4. **Test with a research PDF**
5. **Enable the rule**

### **Full Setup (15 minutes):**
1. **Set up all 5 rules** above
2. **Test each rule** individually
3. **Enable all rules**
4. **Monitor for 24 hours**
5. **Adjust as needed**

---

## **🎉 Your Research Workflow Will Be:**

✅ **Fully Automated**: No manual file management needed  
✅ **Zotero Integrated**: All files automatically uploaded  
✅ **Calibre Archived**: Long-term storage with metadata  
✅ **Smartly Organized**: Logical folder structure  
✅ **Metadata Rich**: Comprehensive file information  
✅ **Searchable**: Find research materials instantly  
✅ **Scalable**: Handles any amount of research files  

---

**🔬 Ready to transform your research workflow?**

Start with the Research Downloads rule, test it with a real research file, then expand to the other specialized rules. Your system will automatically handle every research file you download, whether Zotero captures it or not!

**💡 Pro Tip**: Start with one rule and test thoroughly before adding more. This ensures each part works perfectly before building the complete system.

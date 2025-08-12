# 🎯 Hazel Automation Rules Setup Guide

## **🚀 Complete Automation for Your Organized System**

This guide will help you set up Hazel rules that automatically organize **every new file** on your MacBook Pro using the system-wide organization script we just created.

## **📋 Hazel Rules to Create**

### **Rule 1: Desktop Cleanup (High Priority)**

#### **Rule Settings:**
- **Name**: `Desktop Auto-Organize`
- **Folder**: `Desktop`
- **Enabled**: ✅ Yes

#### **Conditions:**
- **File is not in Research folder** ✅
- **File is not hidden** ✅
- **File exists** ✅

#### **Actions:**
1. **Run shell script**: `~/Documents/Research/hazel_rules_system_wide.sh`
2. **Move to**: `~/Documents/Research/Archives/By_Type` (temporary)
3. **Delete original** ✅

#### **Advanced Options:**
- **Run on subfolders**: ✅ Yes
- **Run on files added**: ✅ Yes
- **Run on files modified**: ❌ No (only new files)

---

### **Rule 2: Downloads Organization (High Priority)**

#### **Rule Settings:**
- **Name**: `Downloads Auto-Organize`
- **Folder**: `Downloads`
- **Enabled**: ✅ Yes

#### **Conditions:**
- **File is not in Research folder** ✅
- **File is not hidden** ✅
- **File exists** ✅
- **File extension is not**: `download` (prevents conflicts)

#### **Actions:**
1. **Run shell script**: `~/Documents/Research/hazel_rules_system_wide.sh`
2. **Move to**: `~/Documents/Research/Archives/By_Type` (temporary)
3. **Delete original** ✅

#### **Advanced Options:**
- **Run on subfolders**: ✅ Yes
- **Run on files added**: ✅ Yes
- **Run on files modified**: ❌ No

---

### **Rule 3: Documents Processing (Medium Priority)**

#### **Rule Settings:**
- **Name**: `Documents Auto-Organize`
- **Folder**: `Documents`
- **Enabled**: ✅ Yes

#### **Conditions:**
- **File is not in Research folder** ✅
- **File is not hidden** ✅
- **File exists** ✅
- **File extension is one of**: `pdf, doc, docx, rtf, txt, md, tex, bib`

#### **Actions:**
1. **Run shell script**: `~/Documents/Research/hazel_rules_system_wide.sh`
2. **Move to**: `~/Documents/Research/Archives/By_Type` (temporary)
3. **Delete original** ✅

---

### **Rule 4: Pictures Organization (Medium Priority)**

#### **Rule Settings:**
- **Name**: `Pictures Auto-Organize`
- **Folder**: `Pictures`
- **Enabled**: ✅ Yes

#### **Conditions:**
- **File is not in Research folder** ✅
- **File is not hidden** ✅
- **File exists** ✅
- **File extension is one of**: `jpg, jpeg, png, gif, heic, raw, psd, ai, sketch`

#### **Actions:**
1. **Run shell script**: `~/Documents/Research/hazel_rules_system_wide.sh`
2. **Move to**: `~/Documents/Research/Archives/By_Type` (temporary)
3. **Delete original** ✅

---

### **Rule 5: Music & Audio (Medium Priority)**

#### **Rule Settings:**
- **Name**: `Music Auto-Organize`
- **Folder**: `Music`
- **Enabled**: ✅ Yes

#### **Conditions:**
- **File is not in Research folder** ✅
- **File is not hidden** ✅
- **File exists** ✅
- **File extension is one of**: `mp3, m4a, wav, aac, flac`

#### **Actions:**
1. **Run shell script**: `~/Documents/Research/hazel_rules_system_wide.sh`
2. **Move to**: `~/Documents/Research/Archives/By_Type` (temporary)
3. **Delete original** ✅

---

### **Rule 6: Movies & Videos (Medium Priority)**

#### **Rule Settings:**
- **Name**: `Movies Auto-Organize`
- **Folder**: `Movies`
- **Enabled**: ✅ Yes

#### **Conditions:**
- **File is not in Research folder** ✅
- **File is not hidden** ✅
- **File exists** ✅
- **File extension is one of**: `mp4, mov, avi, mkv, wmv`

#### **Actions:**
1. **Run shell script**: `~/Documents/Research/hazel_rules_system_wide.sh`
2. **Move to**: `~/Documents/Research/Archives/By_Type` (temporary)
3. **Delete original** ✅

---

### **Rule 7: Code & Development Files (Low Priority)**

#### **Rule Settings:**
- **Name**: `Code Auto-Organize`
- **Folder**: `Documents` (or wherever you keep code)
- **Enabled**: ✅ Yes

#### **Conditions:**
- **File is not in Research folder** ✅
- **File is not hidden** ✅
- **File exists** ✅
- **File extension is one of**: `py, js, html, css, java, cpp, swift, sql, php, rb`

#### **Actions:**
1. **Run shell script**: `~/Documents/Research/hazel_rules_system_wide.sh`
2. **Move to**: `~/Documents/Research/Archives/By_Type` (temporary)
3. **Delete original** ✅

---

### **Rule 8: E-books & Reading (Low Priority)**

#### **Rule Settings:**
- **Name**: `E-books Auto-Organize`
- **Folder**: `Downloads` (or wherever you download e-books)
- **Enabled**: ✅ Yes

#### **Conditions:**
- **File is not in Research folder** ✅
- **File is not hidden** ✅
- **File exists** ✅
- **File extension is one of**: `epub, mobi, azw3, pdf, cbz, cbr`

#### **Actions:**
1. **Run shell script**: `~/Documents/Research/hazel_rules_system_wide.sh`
2. **Move to**: `~/Documents/Research/Archives/By_Type` (temporary)
3. **Delete original** ✅

---

## **🔧 Step-by-Step Setup in Hazel**

### **Step 1: Open Hazel**
1. Launch Hazel from Applications
2. Click the "+" button to add a new folder
3. Add each folder you want to monitor

### **Step 2: Create Rules**
1. **Select the folder** you want to monitor
2. **Click the "+" button** to add a rule
3. **Name your rule** (e.g., "Desktop Auto-Organize")
4. **Set conditions** as specified above
5. **Set actions** as specified above
6. **Save the rule**

### **Step 3: Test Each Rule**
1. **Create a test file** in the monitored folder
2. **Watch Hazel process it** automatically
3. **Check the destination** folder
4. **Verify the file** was organized correctly

### **Step 4: Enable All Rules**
1. **Enable each rule** by checking the box
2. **Set priorities** (High/Medium/Low)
3. **Test with real files**

---

## **⚠️ Important Safety Settings**

### **Backup Before Enabling**
- **Time Machine**: Ensure Time Machine is running
- **Cloud Backup**: Sync important folders to iCloud/OneDrive
- **Test First**: Test with non-critical files

### **Hazel Permissions**
- **Full Disk Access**: Grant Hazel full disk access
- **Automation**: Allow Hazel to control other applications
- **File Access**: Grant access to all monitored folders

### **Monitoring Settings**
- **Run on subfolders**: Enable for complete coverage
- **Run on files added**: Enable for new files
- **Run on files modified**: Disable to avoid loops

---

## **🎯 Expected Results**

### **Immediate Benefits**
- **Clean Desktop**: No more cluttered desktop
- **Organized Downloads**: Downloads folder stays clean
- **Structured Documents**: Everything in logical places
- **Easy Search**: Find files quickly and easily

### **Long-term Benefits**
- **Better Productivity**: Spend less time looking for files
- **Professional Organization**: Impress colleagues and clients
- **Easy Backup**: Organized structure makes backup simple
- **Scalable**: Grows with your needs

---

## **🔄 Maintenance & Monitoring**

### **Regular Checks**
- **Review Hazel logs** for any errors
- **Check organization results** weekly
- **Update rules** based on usage patterns
- **Monitor disk space** in organized folders

### **Troubleshooting**
- **Permission errors**: Check Hazel permissions
- **Script errors**: Check script logs
- **File conflicts**: Review duplicate handling
- **Performance issues**: Adjust rule priorities

---

## **🚀 Getting Started Right Now**

### **Quick Setup (5 minutes)**
1. **Open Hazel**
2. **Add Desktop folder**
3. **Create Desktop rule** (copy from above)
4. **Test with a file**
5. **Enable the rule**

### **Full Setup (15 minutes)**
1. **Set up all 8 rules** above
2. **Test each rule** individually
3. **Enable all rules**
4. **Monitor for 24 hours**
5. **Adjust as needed**

---

## **🎉 Your System Will Be:**

✅ **Fully Automated**: No manual file organization needed  
✅ **Always Clean**: Folders stay organized automatically  
✅ **Professional**: Everything in its proper place  
✅ **Efficient**: Find files instantly  
✅ **Scalable**: Handles any amount of files  
✅ **Integrated**: Works with all your tools  

---

**🎯 Ready to transform your MacBook Pro into the most organized computer ever?**

Follow these rules and your system will automatically organize every file you create, download, or receive!

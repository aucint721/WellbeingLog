# 🎯 Complete Hazel Setup Guide - System-Wide Monitoring

## **📁 Current Hazel Rules (Working)**

### **✅ Rule 1: "File Intake Auto-Process"**
- **Folder**: `~/Documents/Research/File_Intake`
- **Purpose**: Process new files from applications
- **Status**: ✅ **ACTIVE**

### **✅ Rule 2: "Auto-Sort Existing Files"**
- **Folder**: `~/Documents/Research/Organized_Research`
- **Purpose**: Continuously sort organized research files
- **Status**: ✅ **ACTIVE**

## **🔧 New Hazel Rules to Add**

### **Rule 3: "Pictures Auto-Organize"**
- **Folder**: `~/Pictures` (or your Pictures folder location)
- **Purpose**: Automatically organize pictures into Research system
- **Conditions**: 
  - File is not hidden
  - File exists
- **Actions**: 
  - Run shell script: `~/Documents/Research/hazel_intake_automation.sh "$1"`

### **Rule 4: "Movies Auto-Organize"**
- **Folder**: `~/Movies` (or your Movies folder location)
- **Purpose**: Automatically organize videos into Research system
- **Conditions**: 
  - File is not hidden
  - File exists
- **Actions**: 
  - Run shell script: `~/Documents/Research/hazel_intake_automation.sh "$1"`

### **Rule 5: "Downloads Auto-Organize"**
- **Folder**: `~/Downloads`
- **Purpose**: Catch any downloads that bypass File_Intake
- **Conditions**: 
  - File is not hidden
  - File exists
- **Actions**: 
  - Run shell script: `~/Documents/Research/hazel_intake_automation.sh "$1"`

### **Rule 6: "Desktop Auto-Organize"**
- **Folder**: `~/Desktop`
- **Purpose**: Keep desktop clean and organized
- **Conditions**: 
  - File is not hidden
  - File exists
- **Actions**: 
  - Run shell script: `~/Documents/Research/hazel_intake_automation.sh "$1"`

## **📋 Step-by-Step Setup Instructions**

### **Step 1: Add Pictures Folder Monitoring**
1. **Open Hazel application**
2. **Click "+" button** (bottom left)
3. **Select "Add Folder"**
4. **Navigate to**: `~/Pictures` (or your Pictures folder)
5. **Click "Choose"**
6. **Create rule**: "Pictures Auto-Organize"
7. **Set conditions**: File is not hidden, File exists
8. **Set actions**: Run shell script with your automation script
9. **Enable the rule**

### **Step 2: Add Movies Folder Monitoring**
1. **Click "+" button** again
2. **Select "Add Folder"**
3. **Navigate to**: `~/Movies` (or your Movies folder)
4. **Click "Choose"**
5. **Create rule**: "Movies Auto-Organize"
6. **Set conditions**: File is not hidden, File exists
7. **Set actions**: Run shell script with your automation script
8. **Enable the rule**

### **Step 3: Add Downloads Folder Monitoring**
1. **Click "+" button** again
2. **Select "Add Folder"**
3. **Navigate to**: `~/Downloads`
4. **Click "Choose"**
5. **Create rule**: "Downloads Auto-Organize"
6. **Set conditions**: File is not hidden, File exists
7. **Set actions**: Run shell script with your automation script
8. **Enable the rule**

### **Step 4: Add Desktop Monitoring**
1. **Click "+" button** again
2. **Select "Add Folder"**
3. **Navigate to**: `~/Desktop`
4. **Click "Choose"**
5. **Create rule**: "Desktop Auto-Organize"
6. **Set conditions**: File is not hidden, File exists
7. **Set actions**: Run shell script with your automation script
8. **Enable the rule**

## **🎯 What This Will Achieve**

### **Complete System Coverage:**
- **File_Intake** → New application files
- **Pictures** → All image files automatically organized
- **Movies** → All video files automatically organized
- **Downloads** → Any downloads automatically processed
- **Desktop** → Desktop stays clean and organized
- **Organized_Research** → Continuous sorting of research files

### **Automatic File Organization:**
- **Images** → Date-organized in Research archives
- **Videos** → Date-organized in Research archives
- **Audio** → Transcription projects created
- **Documents** → Course-specific organization
- **Code** → Development project structures
- **LaTeX** → Complete project structures

## **🧪 Testing the New Rules**

### **Test Pictures Rule:**
1. **Add a new image** to your Pictures folder
2. **Watch Hazel** automatically process it
3. **Check Research archives** for organized image

### **Test Movies Rule:**
1. **Add a new video** to your Movies folder
2. **Watch Hazel** automatically process it
3. **Check Research archives** for organized video

### **Test Downloads Rule:**
1. **Download a file** to Downloads folder
2. **Watch Hazel** automatically process it
3. **Check Research archives** for organized file

## **⚠️ Important Considerations**

### **File Movement vs. File Addition:**
- **Hazel detects NEW files** added to monitored folders
- **Hazel may not detect** files moved between monitored folders
- **For best results**: Add files to monitored folders, don't move between them

### **Performance Impact:**
- **Multiple folder monitoring** increases Hazel activity
- **Monitor only folders** you actually use
- **Start with Pictures and Movies**, add others as needed

### **File Conflicts:**
- **Automation script** handles filename conflicts
- **Unique names** generated automatically
- **No files lost** during processing

## **🚀 Expected Results**

### **After Setup:**
1. **All new images** automatically organized by date
2. **All new videos** automatically organized by date
3. **All new downloads** automatically categorized
4. **Desktop stays clean** and organized
5. **Complete file organization** across your entire system

### **File Flow:**
```
Pictures/Movies/Downloads/Desktop → Hazel Detection → Automation Script → Organized Research System
```

## **💡 Pro Tips**

1. **Start with Pictures and Movies** - these are most important
2. **Test each rule** individually before adding more
3. **Monitor Hazel logs** to ensure rules are working
4. **Adjust conditions** if you get too many false positives
5. **Use File_Intake** for intentional file processing

## **🎉 Result**

With these new rules, **Hazel will monitor your entire system** and automatically organize all files into your Research system. No more manual file organization needed!

Your system will become a **completely automated file management powerhouse**! 🚀


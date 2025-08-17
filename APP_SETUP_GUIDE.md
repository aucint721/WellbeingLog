# 🚀 File Cleanup App - Setup Guide

## What You Now Have

✅ **Complete macOS app bundle** - `File Cleanup App.app`  
✅ **Easy dock integration** - Add to dock for quick access  
✅ **Simple launcher script** - `File_Cleanup_App.command`  
✅ **Comprehensive Shortcuts workflow** - `File_Cleanup_App.shortcut`  

## 🎯 Quick Setup (3 Ways to Launch)

### Option 1: Add to Dock (Recommended)
1. **Find the app**: Look for `File Cleanup App.app` in your current directory
2. **Drag to dock**: Drag the app icon to your dock
3. **Launch**: Click the dock icon to run the cleanup workflow

### Option 2: Double-click Command File
1. **Find the file**: Look for `File_Cleanup_App.command`
2. **Double-click**: Double-click the file to launch
3. **Grant permissions**: Allow Terminal access if prompted

### Option 3: Import Shortcuts Workflow
1. **Open Shortcuts app**
2. **Import workflow**: File → Import → Select `File_Cleanup_App.shortcut`
3. **Run from Shortcuts**: Use the Shortcuts app to launch

## 🔧 How to Use the App

### When You Launch the App:

1. **Choose an action** from the menu:
   - 🚀 **Quick Scan** - Scans Downloads, Desktop, Documents
   - 🔍 **Full System Scan** - Scans all configured directories
   - 📂 **Custom Directory Scan** - Scan specific folders
   - 👁️ **Quick Look a File** - Preview any file
   - 📊 **Open Latest Report** - View scan results
   - 🔧 **Create Shortcuts Workflow** - Generate workflow files
   - ❓ **Show Help** - Display usage information

2. **Follow the prompts** for your chosen action

3. **Review results** in the generated reports

## 📱 Adding to Dock

### Step-by-Step:
1. **Open Finder** and navigate to your current directory
2. **Find** `File Cleanup App.app` (it looks like a regular app)
3. **Drag the app** to your dock (anywhere on the dock)
4. **The app icon** will appear in your dock
5. **Click the icon** anytime to launch the cleanup workflow

### Dock Icon Features:
- **Single click** launches the app
- **Right-click** shows app options
- **Drag files** onto the icon for quick processing
- **Stays in dock** until you remove it

## 🎮 Using the App

### Quick Start Workflow:
1. **Launch the app** (click dock icon)
2. **Choose "Quick Scan"** (option 1)
3. **Wait for scan** to complete
4. **Open the report** when prompted
5. **Review files** using Quick Look
6. **Make decisions** about what to delete

### Advanced Features:
- **Custom scans** of specific directories
- **File preview** with Quick Look integration
- **Multiple report formats** (HTML, CSV, JSON)
- **Risk scoring** to prioritize deletion candidates

## 🔒 Permissions & Security

### First Launch:
- **Terminal access** may be requested
- **Click "Allow"** to grant necessary permissions
- **This is safe** - the app only accesses your files for scanning

### What the App Does:
- **Scans directories** you specify
- **Generates reports** with file information
- **Integrates with Quick Look** for file preview
- **Never deletes files** automatically

### What the App Doesn't Do:
- **Access system files** or other users' data
- **Send data** to external servers
- **Modify files** without your permission
- **Run in background** without your knowledge

## 🛠️ Troubleshooting

### App Won't Launch:
1. **Check permissions**: System Preferences → Security & Privacy → Privacy
2. **Verify location**: Make sure the app is in the same directory as the scripts
3. **Check Terminal access**: Allow Terminal in Security & Privacy

### Scripts Not Found:
1. **Verify file structure**: All files should be in the same directory
2. **Check permissions**: Make sure scripts are executable
3. **Run manually**: Try running `./cleanup_launcher.sh` in Terminal

### Reports Not Generated:
1. **Check Python**: Ensure Python 3.7+ is installed
2. **Verify dependencies**: Install required packages if needed
3. **Check directory permissions**: Ensure write access to current directory

## 🎯 Pro Tips

### For Regular Use:
- **Add to dock** for quick access
- **Run weekly scans** to keep files organized
- **Use Quick Look** to preview before deciding
- **Review reports** to track cleanup progress

### For Power Users:
- **Customize thresholds** in `cleanup_config.json`
- **Create scheduled scans** using cron or launchd
- **Integrate with Hazel** for automated organization
- **Use the Python API** for custom workflows

### For Teams:
- **Share the app** with colleagues
- **Customize for shared directories**
- **Create team cleanup schedules**
- **Track cleanup metrics** across users

## 🆘 Getting Help

### Built-in Help:
- **Choose "Show Help"** from the app menu
- **Check the guide**: `FILE_CLEANUP_WORKFLOW_GUIDE.md`
- **View the summary**: `QUICK_START_SUMMARY.md`

### Manual Commands:
```bash
# Run launcher directly
./cleanup_launcher.sh

# Run Python script directly
python3 file_cleanup_workflow.py --help

# Check app status
ls -la "File Cleanup App.app"
```

## 🎉 You're All Set!

Your File Cleanup App is now ready to use. Simply:

1. **Add to dock** for easy access
2. **Click to launch** when you need to clean up files
3. **Follow the prompts** to scan and review files
4. **Use Quick Look** to preview before deciding
5. **Reclaim disk space** safely and efficiently

**Happy cleaning! 🧹✨**

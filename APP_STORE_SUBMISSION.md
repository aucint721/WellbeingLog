# App Store Submission Guide for Wellbeing Log

## Overview
This guide will help you submit the Wellbeing Log app to the App Store. The app is designed for schools to track student wellbeing and manage room-based student logging.

## Prerequisites
1. **Apple Developer Account** ($99/year)
2. **Xcode** (latest version)
3. **App Store Connect** access
4. **App Icons** (various sizes)
5. **Screenshots** (for different device sizes)
6. **App Description** and metadata

## Step 1: Prepare App Store Connect

### 1.1 Create App in App Store Connect
1. Log into [App Store Connect](https://appstoreconnect.apple.com)
2. Click "My Apps" → "+" → "New App"
3. Fill in the following details:
   - **Platform**: iOS
   - **Name**: Wellbeing Log
   - **Bundle ID**: aucint.Wellbeing-Log
   - **SKU**: WellbeingLog2024 (or your preferred unique identifier)
   - **User Access**: Full Access

### 1.2 App Information
- **Primary Language**: English
- **Bundle ID**: aucint.Wellbeing-Log
- **SKU**: WellbeingLog2024

## Step 2: App Store Information

### 2.1 App Description
```
Wellbeing Log - Student Room Management System

A comprehensive school management app designed to track student wellbeing and manage room-based student logging. Perfect for schools, counselors, and administrators who need to monitor student attendance and wellbeing across different support rooms.

Key Features:
• Student In/Out Tracking for multiple rooms (Wellbeing, Diverse Learners, Lunch)
• Real-time headcount monitoring for each room
• Customizable reasons for student entries and exits
• Comprehensive statistics and reporting
• CSV import/export functionality for student data
• iPad and iPhone optimized interface
• Secure data management with local storage

Ideal for:
• School counselors and wellbeing coordinators
• Special education departments
• School administrators
• Student support teams

Track student movements, monitor room capacity, and generate detailed reports to support student wellbeing initiatives.
```

### 2.2 Keywords
```
wellbeing,student,management,school,counseling,attendance,tracking,room,log,education,special needs,diverse learners,lunch,statistics,reports
```

### 2.3 App Category
- **Primary Category**: Education
- **Secondary Category**: Productivity

### 2.4 App Store Information
- **Name**: Wellbeing Log
- **Subtitle**: Student Room Management System
- **Keywords**: wellbeing,student,management,school,counseling,attendance,tracking,room,log,education,special needs,diverse learners,lunch,statistics,reports
- **Description**: [Use the description above]
- **What's New**: Initial release

## Step 3: App Icons

### 3.1 Required Icon Sizes
You need to create icons in the following sizes:

**iPhone:**
- 60pt (@2x): 120x120px
- 60pt (@3x): 180x180px

**iPad:**
- 76pt (@1x): 76x76px
- 76pt (@2x): 152x152px
- 83.5pt (@2x): 167x167px

**App Store:**
- 1024pt (@1x): 1024x1024px

### 3.2 Icon Design Guidelines
- Simple, recognizable design
- No transparency
- No rounded corners (iOS will add them automatically)
- No text or numbers
- High contrast
- Professional appearance

## Step 4: Screenshots

### 4.1 Required Screenshots
You need screenshots for:
- iPhone 6.7" (iPhone 14 Pro Max, iPhone 15 Pro Max)
- iPhone 6.5" (iPhone 11 Pro Max, iPhone 12 Pro Max, iPhone 13 Pro Max)
- iPhone 5.5" (iPhone 8 Plus, iPhone 7 Plus)
- iPad Pro 12.9" (6th generation)
- iPad Pro 11" (4th generation)

### 4.2 Screenshot Content
Take screenshots of:
1. **Main Menu** - Show the clean interface with all options
2. **Student In Process** - Show room selection and student search
3. **Head Count View** - Show the room statistics
4. **Statistics View** - Show the detailed analytics
5. **Settings** - Show the data management options

## Step 5: App Store Connect Setup

### 5.1 App Information
- **Privacy Policy URL**: [You'll need to create this]
- **Support URL**: [You'll need to create this]
- **Marketing URL**: [Optional]

### 5.2 App Review Information
- **Contact Information**: Your email
- **Demo Account**: [If needed for review]
- **Notes**: "This app is designed for school administrators to track student wellbeing and room attendance. The app uses local storage only and does not collect personal data."

### 5.3 App Store Review Notes
```
App Review Notes:

This app is designed for school administrators and counselors to track student wellbeing and room attendance. Key features include:

1. Student In/Out tracking for multiple rooms (Wellbeing, Diverse Learners, Lunch)
2. Real-time headcount monitoring
3. Customizable reasons for entries/exits
4. CSV import/export for student data
5. Comprehensive statistics and reporting

The app uses local storage only and does not transmit any personal data. All student information is stored locally on the device.

Testing Instructions:
1. Launch the app
2. Navigate through the main menu options
3. Try adding/removing students from different rooms
4. Check the headcount and statistics views
5. Test the CSV import/export functionality in Settings

The app is ready for production use in educational environments.
```

## Step 6: Build and Upload

### 6.1 Archive the App
1. In Xcode, select "Any iOS Device" as the target
2. Go to Product → Archive
3. Wait for the archive to complete

### 6.2 Upload to App Store Connect
1. In the Organizer window, select your archive
2. Click "Distribute App"
3. Select "App Store Connect"
4. Choose "Upload"
5. Follow the signing and uploading process

### 6.3 Build Settings
Ensure these settings are correct:
- **Bundle Identifier**: aucint.Wellbeing-Log
- **Version**: 1.0.0
- **Build**: 1
- **Deployment Target**: iOS 18.5
- **Signing**: Use your Apple Developer account

## Step 7: Submit for Review

### 7.1 Final Checklist
- [ ] App icons uploaded
- [ ] Screenshots uploaded for all device sizes
- [ ] App description completed
- [ ] Keywords added
- [ ] Privacy policy URL provided
- [ ] Support URL provided
- [ ] App review information completed
- [ ] Build uploaded and processing completed
- [ ] All metadata completed

### 7.2 Submit for Review
1. In App Store Connect, go to your app
2. Click "Prepare for Submission"
3. Review all information
4. Click "Submit for Review"

## Step 8: Post-Submission

### 8.1 Review Process
- Typical review time: 1-3 days
- You'll receive email notifications about the status
- If rejected, address the issues and resubmit

### 8.2 Common Rejection Reasons
- Missing privacy policy
- Incomplete app information
- Poor app icons
- Missing screenshots
- App crashes during review

## Step 9: Launch

### 9.1 Release Options
- **Manual Release**: You control when the app goes live
- **Automatic Release**: App goes live immediately after approval

### 9.2 Marketing
- Announce on your website/social media
- Contact schools and educational institutions
- Consider educational app directories

## Additional Resources

### Privacy Policy Template
You'll need to create a privacy policy. Here's a basic template:

```
Privacy Policy for Wellbeing Log

This app does not collect, store, or transmit any personal data to external servers. All data is stored locally on the device and is not shared with third parties.

Data Storage:
- Student information is stored locally on the device
- CSV files are stored in the app's documents directory
- No data is transmitted to external servers

Data Usage:
- Student names and information are used only for room tracking
- No analytics or tracking data is collected
- No personal information is shared

Contact:
[Your contact information]
```

### Support Website
Consider creating a simple support website with:
- App features
- User guide
- Contact information
- Download link (once approved)

## Next Steps

1. **Create App Icons** - Design professional icons in all required sizes
2. **Take Screenshots** - Capture screenshots on different device sizes
3. **Write Privacy Policy** - Create a privacy policy website
4. **Create Support Website** - Set up a basic support site
5. **Test Thoroughly** - Ensure the app works perfectly before submission
6. **Submit for Review** - Follow the steps above

Good luck with your App Store submission! 
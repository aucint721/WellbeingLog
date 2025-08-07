# Wellbeing Log - iOS App

A comprehensive iOS application for tracking student wellbeing, attendance, and room management in educational settings.

## Features

### Core Functionality
- **Student Management**: Add, search, and manage student records
- **Room Tracking**: Monitor students in Wellbeing Room, Diverse Learners Room, and Lunch Room
- **Real-time Sync**: CloudKit-powered synchronization between devices
- **Statistics**: Comprehensive reporting and analytics
- **Safety Monitoring**: Automated safety warnings and alerts

### Room Management
- **Wellbeing Room**: Track students seeking emotional support
- **Diverse Learners Room**: Monitor students with learning support needs
- **Lunch Room**: Manage lunchtime attendance

### CloudKit Integration
- **Real-time Sync**: Changes appear on all devices within 30 seconds
- **iCloud Required**: Professional Apple infrastructure for reliable sync
- **Automatic Conflict Resolution**: CloudKit handles data conflicts
- **Offline Support**: Changes sync when connection is restored

## Requirements

### For Basic Use
- iOS 15.0 or later
- iPhone or iPad

### For CloudKit Sync
- iCloud account signed in on all devices
- Internet connection
- Same iCloud account on all devices

## Installation

1. **Clone the repository**
   ```bash
   git clone [repository-url]
   cd "Wellbeing Log"
   ```

2. **Open in Xcode**
   ```bash
   open "Wellbeing Log.xcodeproj"
   ```

3. **Configure CloudKit (for sync feature)**
   - Add iCloud capability in Xcode
   - Enable CloudKit within iCloud capability
   - Set container identifier: `iCloud.com.HennieAucamp.wellbeinglog`
   - Configure CloudKit Dashboard (see CLOUDKIT_SETUP.md)

4. **Build and run**
   - Select target device/simulator
   - Press Cmd+R to build and run

## Usage

### Basic Operations
1. **Add Students**: Use the main menu to add student records
2. **Track Attendance**: Sign students in/out of rooms
3. **Monitor Counts**: View real-time head counts
4. **Generate Reports**: Access statistics and analytics

### CloudKit Sync Setup
1. **Sign into iCloud** on all devices
2. **Enable iCloud** for the app in Settings
3. **Grant permissions** when prompted
4. **Access "CloudKit Room Sync"** from main menu

### Room Operations
- **Wellbeing Room**: Track emotional support needs
- **Diverse Learners Room**: Monitor learning support
- **Lunch Room**: Manage lunchtime attendance
- **Statistics**: View comprehensive reports

## File Structure

```
Wellbeing Log/
├── Wellbeing Log/
│   ├── ContentView.swift          # Main app interface
│   ├── HeadCountView.swift        # Room count display
│   ├── RoomSyncManager.swift      # CloudKit sync manager
│   ├── LiveRoomSyncView.swift     # Real-time sync interface
│   ├── StudentStore.swift         # Student data management
│   ├── SharedDataModels.swift     # Shared data structures
│   └── [Other Swift files]        # Additional functionality
├── CLOUDKIT_SETUP.md             # CloudKit configuration guide
├── APP_STORE_SUBMISSION.md       # App Store submission guide
└── README.md                     # This file
```

## CloudKit Setup

For detailed CloudKit configuration instructions, see [CLOUDKIT_SETUP.md](CLOUDKIT_SETUP.md).

## App Store Submission

For App Store submission guidelines, see [APP_STORE_SUBMISSION.md](APP_STORE_SUBMISSION.md).

## Privacy & Security

- **Local Data**: Student records stored locally on device
- **CloudKit Sync**: Optional feature requiring iCloud sign-in
- **No External Servers**: All data stays within Apple's ecosystem
- **User Control**: Users choose whether to enable sync

## Support

For technical support or feature requests, please refer to the documentation files or contact the development team.

## Version History

### Current Version
- **CloudKit Integration**: Real-time sync between devices
- **Professional UI**: Improved interface for all device sizes
- **Enhanced Security**: Apple's CloudKit infrastructure
- **Comprehensive Documentation**: Complete setup and usage guides

### Previous Versions
- Local file-based sync (deprecated)
- Basic room tracking
- Initial student management features 
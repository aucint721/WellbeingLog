# CloudKit Room Sync Setup Guide

## Overview
The app now uses professional CloudKit/iCloud functionality for real-time room synchronization between devices.

## Requirements
- **iCloud Account**: Users must be signed into iCloud on their devices
- **Internet Connection**: Required for CloudKit sync
- **App Store Distribution**: CloudKit works best with App Store distributed apps

## Setup Instructions

### 1. Xcode Project Setup
- Open the project in Xcode
- Select the project in the navigator
- Go to "Signing & Capabilities"
- Add "iCloud" capability
- Enable "CloudKit" within the iCloud capability
- Set container identifier: `iCloud.com.HennieAucamp.wellbeinglog`

### 2. CloudKit Dashboard Setup
- Go to [CloudKit Dashboard](https://icloud.developer.apple.com/dashboard/)
- Select your container: `iCloud.com.HennieAucamp.wellbeinglog`
- Create Record Types:
  - **RoomCounts**: 
    - `wellbeingCount` (Int64)
    - `diverseLearnersCount` (Int64)
    - `lunchCount` (Int64)
    - `timestamp` (Date/Time)
    - `deviceID` (String)
  - **RoomActivity**:
    - `room` (String)
    - `action` (String)
    - `studentName` (String)
    - `timestamp` (Date/Time)
    - `deviceID` (String)

### 3. User Setup
- Users must sign into iCloud on their devices
- Enable iCloud for the app in Settings > [User Name] > iCloud > Apps using iCloud
- Grant permission when prompted

## Features
- **Real-time sync**: Changes appear on all devices within 30 seconds
- **Professional reliability**: Uses Apple's CloudKit infrastructure
- **Automatic conflict resolution**: CloudKit handles data conflicts
- **Offline support**: Changes sync when connection is restored

## Troubleshooting
- **"iCloud Disconnected"**: Check iCloud sign-in and internet connection
- **"Sync failed"**: Verify CloudKit Dashboard setup and permissions
- **No updates**: Ensure both devices are signed into the same iCloud account

## Benefits over Local Sync
- ✅ Professional Apple infrastructure
- ✅ Real-time updates
- ✅ Automatic conflict resolution
- ✅ Works across any devices with same iCloud account
- ✅ No manual file sharing required
- ✅ Secure and reliable

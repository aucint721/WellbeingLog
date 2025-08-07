# Room Synchronization Setup Guide

## Overview

The Wellbeing Log app now supports real-time synchronization between multiple devices/rooms, allowing different locations to see each other's student counts simultaneously. This feature uses Apple's CloudKit to securely share data across devices.

## Features

- **Real-time Updates**: Student counts sync automatically every 30 seconds
- **Multi-room Support**: Wellbeing Room, Diverse Learners Room, and Lunch Room
- **Activity Logging**: Track all student movements across rooms
- **Connection Status**: Visual indicators for sync status
- **Offline Support**: Works locally when CloudKit is unavailable

## Setup Instructions

### 1. Enable CloudKit in Xcode

1. Open your project in Xcode
2. Select your app target
3. Go to **Signing & Capabilities**
4. Click **+ Capability**
5. Add **CloudKit**
6. Configure the CloudKit container identifier

### 2. Configure CloudKit Container

1. In Xcode, go to **Project Settings** → **Signing & Capabilities**
2. Under **CloudKit**, click **Configure**
3. Set the container identifier to: `iCloud.com.yourcompany.wellbeinglog`
4. Enable **Public Database** for sharing between devices

### 3. Set Up CloudKit Dashboard

1. Go to [CloudKit Dashboard](https://icloud.developer.apple.com/dashboard/)
2. Select your app's container
3. Create the following Record Types:

#### RoomCounts Record Type
- `wellbeingCount` (Int64)
- `diverseLearnersCount` (Int64) 
- `lunchCount` (Int64)
- `timestamp` (Date/Time)
- `deviceID` (String)

#### RoomActivity Record Type
- `room` (String)
- `action` (String)
- `studentName` (String)
- `timestamp` (Date/Time)
- `deviceID` (String)

### 4. Update App Configuration

1. Open `CloudKitConfig.swift`
2. Update the container identifier to match your app:
   ```swift
   static let containerIdentifier = "iCloud.com.yourcompany.wellbeinglog"
   ```

### 5. Test the Feature

1. Build and run the app on multiple devices
2. Sign in to the same iCloud account on all devices
3. Navigate to **Live Room Sync** in the main menu
4. Add students to different rooms on different devices
5. Verify that counts update in real-time across devices

## Usage

### Live Room Sync View

The new **Live Room Sync** button in the main menu shows:
- Real-time student counts for all rooms
- Connection status indicator
- Last sync timestamp
- Manual sync controls
- Activity log

### Automatic Synchronization

- Counts sync every 30 seconds automatically
- Manual sync available via refresh button
- Works offline with local storage
- Reconnects automatically when CloudKit is available

### Room Integration

All existing room views now show:
- Local counts when offline
- Synced counts when connected
- Automatic updates when counts change

## Troubleshooting

### Common Issues

1. **"CloudKit not available"**
   - Ensure user is signed into iCloud
   - Check internet connection
   - Verify CloudKit capability is enabled

2. **"Sync failed"**
   - Check CloudKit Dashboard configuration
   - Verify record types are created
   - Ensure proper permissions

3. **Counts not updating**
   - Force sync using refresh button
   - Check connection status indicator
   - Verify device has internet access

### Debug Information

The app includes debug logging for sync operations:
- Check Xcode console for sync messages
- Monitor connection status in Live Room Sync view
- Review activity log for recent changes

## Security & Privacy

- All data is stored in Apple's secure CloudKit infrastructure
- Data is only shared between devices signed into the same iCloud account
- No personal student information is transmitted
- Only room counts and activity logs are synced

## Performance Considerations

- Sync occurs every 30 seconds to balance real-time updates with battery life
- Data is cached locally for offline operation
- Network usage is minimal (only count updates)
- Automatic retry on connection failures

## Future Enhancements

Potential improvements for future versions:
- Real-time push notifications for count changes
- Detailed activity history across devices
- Room-specific permissions and access control
- Analytics and reporting features
- Integration with school management systems

## Support

For technical support or questions about the room synchronization feature:
1. Check the debug logs in Xcode console
2. Verify CloudKit Dashboard configuration
3. Test with multiple devices and iCloud accounts
4. Review the troubleshooting section above

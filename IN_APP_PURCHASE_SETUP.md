# In-App Purchase Setup Guide

## Overview
The Wellbeing Log app now includes a freemium model with:
- **30-day free trial** for new users
- **$9.99 one-time purchase** to unlock all features after trial expires

## App Store Connect Setup

### 1. Create In-App Purchase Product

1. **Log into App Store Connect**
   - Go to https://appstoreconnect.apple.com
   - Sign in with your Apple Developer account

2. **Navigate to Your App**
   - Select "My Apps"
   - Choose "Wellbeing Log"

3. **Create In-App Purchase**
   - Go to "Features" tab
   - Click "In-App Purchases"
   - Click the "+" button to add a new product

4. **Configure Product Details**
   - **Product Type**: Non-Consumable
   - **Product ID**: `wellbeing_log_premium`
   - **Reference Name**: Wellbeing Log Premium
   - **Display Name**: Wellbeing Log Premium
   - **Description**: Unlock all premium features of Wellbeing Log

5. **Set Pricing**
   - **Price**: $9.99 USD
   - **Availability**: All countries where your app is available

6. **Add Localizations** (Optional)
   - Add translations for different languages if needed

### 2. App Store Connect Configuration

1. **App Information**
   - Ensure your app's Bundle ID matches: `com.yourcompany.wellbeinglog`
   - Update the Bundle ID in the StoreKit configuration file

2. **App Review Information**
   - Add review notes explaining the freemium model
   - Include test account credentials if needed

### 3. Testing Configuration

1. **Update StoreKit Configuration**
   - Open `Configuration.storekit` in Xcode
   - Update `_applicationInternalID` to match your actual Bundle ID
   - Update `_developerTeamID` with your actual Team ID

2. **Test in Simulator**
   - Run the app in Xcode simulator
   - Use the StoreKit testing framework
   - Test the purchase flow

3. **Test on Device**
   - Use TestFlight for testing on real devices
   - Create sandbox test accounts in App Store Connect

## Implementation Details

### Trial Period Logic
- Uses `UserDefaults` to track trial start date
- Automatically starts 30-day trial for new users
- Tracks remaining days and shows status

### Purchase Flow
1. User sees trial status on main screen
2. When trial expires, app shows purchase view
3. User can purchase or restore previous purchases
4. After purchase, all features are unlocked permanently

### Features Gated Behind Purchase
- Student tracking (in/out)
- Statistics and reports
- Head count functionality
- Settings and data management

## Testing Checklist

### Before App Store Submission
- [ ] Test trial period with new user
- [ ] Test trial expiration
- [ ] Test purchase flow
- [ ] Test restore purchases
- [ ] Test app behavior after purchase
- [ ] Verify all features work after purchase
- [ ] Test error handling

### App Store Connect
- [ ] Create in-app purchase product
- [ ] Set correct pricing
- [ ] Add product description
- [ ] Configure availability
- [ ] Submit for review

## Important Notes

### Trial Period
- Trial starts automatically for new users
- Trial is tracked locally (UserDefaults)
- For production, consider server-side trial tracking

### Purchase Verification
- Uses StoreKit 2 for modern purchase handling
- Includes transaction verification
- Handles restore purchases functionality

### Privacy & Legal
- Update Privacy Policy to mention in-app purchases
- Update Terms of Service if needed
- Ensure compliance with App Store guidelines

## Troubleshooting

### Common Issues
1. **Product not loading**: Check product ID matches App Store Connect
2. **Purchase fails**: Verify app is signed with correct team
3. **Trial not working**: Check UserDefaults implementation
4. **Restore not working**: Verify App Store account settings

### Debug Tips
- Use Xcode's StoreKit testing framework
- Check console logs for StoreKit errors
- Test with different Apple IDs
- Verify network connectivity

## Revenue Optimization

### Pricing Strategy
- $9.99 is competitive for educational apps
- Consider regional pricing for different markets
- Monitor conversion rates and adjust if needed

### Analytics
- Track trial-to-purchase conversion
- Monitor feature usage patterns
- Analyze user retention after purchase

## Support

For issues with in-app purchases:
1. Check Apple's StoreKit documentation
2. Review App Store Connect guidelines
3. Test thoroughly before submission
4. Provide clear support documentation

## Next Steps

1. **Complete App Store Connect setup**
2. **Test thoroughly on multiple devices**
3. **Submit app for review**
4. **Monitor performance and user feedback**
5. **Consider additional premium features** 
# Apple App Store Review Response - Wellbeing Log

## Response to Guideline 2.1 - Information Needed

Thank you for reviewing our app submission. We appreciate the opportunity to clarify our business model, which is actually quite simple and straightforward.

### 1. Who are the users that will use the paid content in the app?

**Answer:** Educational institutions (schools, colleges, universities) and their staff members who need to track student wellbeing, attendance, and room management. The app is designed for teachers, administrators, and student services staff who manage student welfare programs.

### 2. Where can users purchase the content that can be accessed in the app?

**Answer:** Users purchase the premium upgrade directly within the app using Apple's In-App Purchase system. There is no external purchase mechanism. The purchase is made through the standard iOS purchase flow using the product ID `wellbeing_log_premium`.

### 3. What specific types of previously purchased content can a user access in the app?

**Answer:** This is a one-time purchase app with no previously purchased content. Users either:
- Use the app for free during a 30-day trial period (full access to all features)
- Purchase the premium upgrade ($9.99 one-time) to continue using all features after the trial expires

There is no separate content library, subscriptions, or additional purchases. The app provides the same functionality throughout - the only difference is whether the user is in the trial period or has purchased the premium upgrade.

### 4. What paid content, subscriptions, or features are unlocked within your app that do not use in-app purchase?

**Answer:** None. All paid features are handled exclusively through Apple's In-App Purchase system. There are no external payment methods, subscriptions, or content that bypasses the App Store's payment system.

## Business Model Clarification

**Wellbeing Log** is a simple educational productivity app with a straightforward business model:

- **Free Trial**: 30 days of full access to all features (no credit card required)
- **Premium Upgrade**: $9.99 one-time purchase to continue using the app after trial expires
- **No Subscriptions**: Single purchase provides lifetime access
- **No External Content**: All features are built into the app
- **No Additional Purchases**: No in-app content, subscriptions, or microtransactions

The app is designed to help educational institutions track student wellbeing and attendance. It's a professional tool for schools, not a content consumption app.

## Technical Implementation

- Trial period is tracked using UserDefaults (no external services)
- Premium status is verified through Apple's In-App Purchase validation
- All data is stored locally and synced via CloudKit (no external servers)
- No third-party payment processing or content delivery

We believe this simple, transparent model aligns perfectly with Apple's guidelines for educational productivity apps.

---

**Contact Information:**
- Developer: Hendrik Aucamp
- Email: hxauc0@eq.edu.au
- App: Wellbeing Log (Bundle ID: aucint.Wellbeing-Log)

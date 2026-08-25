# Photo Fixer

Turn bad photos into better photos.

Flutter mobile app (Android + iOS) — MVP scoped in [`project.md`](./project.md), tasks in [`tasks.md`](./tasks.md).

## Setup

```bash
flutter pub get
flutter run
```

Package ID: `com.bennbatuu.photofixer`  
Firebase project: `photofixer-4bc1f`

### Firebase Console checklist

1. Enable **Anonymous** sign-in (Authentication → Sign-in method)
2. Create Firestore database + deploy rules: `firebase deploy --only firestore:rules,storage`
3. Enable App Check (debug token for local; Play Integrity / App Attest for prod)
4. Seed `config/app` document (see `docs/firestore_schema.md`)

Client configs:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

## Stack

- Flutter + Riverpod + go_router
- Firebase (Auth, Functions, Firestore, Storage, App Check, FCM, Analytics, Crashlytics)
- Gemini via Cloud Functions only
- Native IAP (`in_app_purchase`) — no third-party payment SDKs

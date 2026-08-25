# Photo Fixer

Turn bad photos into better photos.

Flutter mobile app (Android + iOS) — MVP scoped in [`project.md`](./project.md), tasks in [`tasks.md`](./tasks.md).

## Setup

```bash
flutter pub get
flutter run
```

Package ID: `com.bennbatuu.photofixer`

Firebase client files (`google-services.json`, `GoogleService-Info.plist`) are added later — bootstrap steps are stubs until then.

## Stack

- Flutter + Riverpod + go_router
- Firebase (Auth, Functions, Firestore, Storage, App Check, FCM, Analytics, Crashlytics)
- Gemini via Cloud Functions only
- Native IAP (`in_app_purchase`) — no third-party payment SDKs

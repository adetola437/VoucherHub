# VoucherHub — Gift Card Mobile App

A Flutter mobile application that integrates directly with the VoucherHub API to provide a seamless end-to-end gift card purchase experience.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Environment Configuration](#environment-configuration)
- [Running the App](#running-the-app)
- [Building a Release](#building-a-release)
- [Test Credentials](#test-credentials)
- [Project Structure](#project-structure)

---

## Prerequisites

| Tool | Minimum Version |
|------|----------------|
| Flutter SDK | 3.19.0 |
| Dart SDK | 3.3.0 |
| Xcode (iOS) | 15.0 |
| Android Studio / SDK | API 21+ |
| CocoaPods (iOS) | 1.14+ |

Verify your Flutter setup:

```bash
flutter doctor
```

All checkmarks should be green before proceeding.

---

## Getting Started

### 1. Clone the repository

```bash
git clone <repository-url>
cd voucher_hub
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. iOS only — install CocoaPods

```bash
cd ios
pod install
cd ..
```

---

## Environment Configuration

The app reads its API base URL from a `.env` file at the project root. This file is **not** committed to version control.

### Create your `.env` file

```bash
cp .env.example .env
```

Then open `.env` and fill in the values:

```dotenv
BASE_URL=https://your-api-base-url.com/api
SWAGGER_URL=https://your-api-base-url.com/swagger
```

> ⚠️ The app will not start without a valid `BASE_URL`. Make sure this matches the VoucherHub backend you are testing against.

---

## Running the App

### Android

```bash
flutter run -d android
```

Or select a device in Android Studio and press **Run**.

### iOS (Simulator)

```bash
flutter run -d ios
```

### iOS (Physical Device)

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Set your **Team** under *Signing & Capabilities*.
3. Select your device and press **Run** in Xcode, or:

```bash
flutter run -d <your-device-id>
```

### List available devices

```bash
flutter devices
```

---

## Building a Release

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (recommended for Play Store)

```bash
flutter build appbundle --release
```

### iOS IPA (requires a paid Apple Developer account)

```bash
flutter build ipa --release
```

Then archive and export via Xcode, or use `xcrun altool` / Fastlane for CI.

---

## Test Credentials

Use these credentials on the login screen:

| Field | Value |
|-------|-------|
| Email | `test@mail.com` |
| Password | `Password1@` |

---

## Project Structure

```
lib/
├── main.dart                   # App entry point
├── config/
│   ├── di/                     # Dependency injection (GetIt)
│   └── flavor/                 # Environment constants (.env)
├── core/
│   ├── api/                    # HTTP client, interceptors, response models
│   ├── navigation/             # GoRouter configuration
│   ├── network/                # Connectivity check
│   ├── shell/                  # Bottom navigation shell
│   ├── storage/                # Secure + local storage abstractions
│   ├── theme/                  # Colors, text styles, app theme
│   ├── utils/                  # Formatters, app-wide messages
│   └── widgets/                # Shared reusable widgets
└── features/
    ├── auth/                   # Login, splash, JWT handling
    ├── products/               # Product catalogue & detail
    ├── cart/                   # Shopping cart
    ├── checkout/               # Calculate total & place order
    ├── orders/                 # Order history & detail
    ├── vouchers/               # Voucher list, detail & operations
    └── profile/                # User profile & logout
```

Each feature follows a consistent internal structure:

```
feature/
├── cubit/          # BLoC/Cubit state management
├── data/
│   ├── datasources/remote/   # API calls
│   ├── models/               # JSON serialisation
│   └── repository/           # Interface + implementation
└── presentation/
    ├── contracts/    # View & controller interfaces
    ├── controllers/  # Screen-level logic, hosts view as a part file
    └── views/        # UI widgets (part of controller)
```

# Project Overview

**Smooth App** is the next-generation Open Food Facts mobile application for Android and iPhone. It is a collaborative scanning app built to showcase the power of Open Food Facts through a smooth user experience and sleek user interface. The application allows users to scan food products, get tailored nutritional comparisons, and contribute to the Open Food Facts database.

**Main Technologies:**
- **Framework:** Flutter (Dart)
- **APIs:** Integrates with the Open Food Facts API via the `openfoodfacts-dart` plugin.

**Project Structure:**
The project is set up as a multi-package workspace inside the `packages/` directory:
- `packages/smooth_app/`: The core mobile application code.
- `packages/app_store/`: Modules for different app store integrations (Apple App Store, Google Play, URI store).
- `packages/scanner/`: Different scanning engine implementations (ML Kit for Play/App Store, ZXing for F-Droid, and shared interfaces).

# Building and Running

## Prerequisites
- **Flutter:** The app currently uses Flutter version **3.38.5**.
- **FVM (Flutter Version Management):** It is recommended to use FVM to manage the Flutter version.
  ```bash
  fvm install 3.38.5
  fvm use 3.38.5
  ```

## Setup & Execution
All run commands should be executed from within the `packages/smooth_app` directory.

1. **Install Dependencies:**
   ```bash
   cd packages/smooth_app
   flutter pub get .
   ```

2. **Run on Android:**
   ```bash
   flutter run -t lib/entrypoints/android/main_google_play.dart
   ```

3. **Run on iOS / macOS:**
   ```bash
   flutter run -t lib/entrypoints/ios/main_ios.dart
   ```

## Troubleshooting
If you encounter dependency resolution errors (e.g., "version solving failed" regarding scanner/camera dependencies), you can try cleaning the cache:
```bash
flutter pub cache clean
```
After clearing the cache, re-run `flutter pub get .`.

# Development Conventions

- **Pull Request Naming:** PR titles must follow the conventional commit scheme to automatically generate the changelog:
  - `feat`: New Features
  - `fix`: Bug Fixes
  - `docs`: Documentation changes
  - `ci`: Automation/CI changes
  - `refactor`: Code refactoring
  - `chore`: Miscellaneous tasks
- **Visual Changes:** Any pull request that impacts the UI must include before and after screenshots.
- **In-App Dev Mode:** Developers can activate an in-app "Dev Mode" for faster debugging and accessing unreleased features. Enable this by navigating to *Preferences screen > Contribute > Software Development > Dev Mode*.
- **Internationalization (i18n):** 
  - Translations are managed using Flutter's native internationalization.
  - New strings should **only** be added to `lib/l10n/app_en.arb`.
  - Do not edit other `app_*.arb` files manually, as they are automatically overwritten by CrowdIn integrations.
- **Linting:** The codebase enforces specific linting rules provided by the `openfoodfacts_flutter_lints` package alongside standard `flutter_lints`.
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Open Food Facts **Smooth App** — a Flutter mobile app for scanning food products, viewing nutrition/eco-scores, and contributing to the Open Food Facts database. Supports Android (Google Play, F-Droid, Amazon, Huawei, Samsung) and iOS.

## Build & Development Commands

All commands run from `packages/smooth_app/` unless noted otherwise.

```bash
# Flutter version (MUST match flutter-version.txt exactly)
fvm install 3.38.5 && fvm use 3.38.5

# Install dependencies
fvm flutter pub get .

# Update all packages across the workspace
./ci/pub_upgrade.sh          # run from repo root

# Run the app (pick one entry point)
fvm flutter run -t lib/entrypoints/android/main_google_play.dart
fvm flutter run -t lib/entrypoints/android/main_fdroid.dart
fvm flutter run -t lib/entrypoints/ios/main_ios.dart

# Format & analyze (required before commits)
dart format --set-exit-if-changed .
fvm flutter analyze --fatal-infos --fatal-warnings .

# Run all tests with coverage (from repo root)
./ci/testing.sh

# Run tests for a single package
cd packages/smooth_app && fvm flutter test --coverage

# Run a single test file
cd packages/smooth_app && fvm flutter test test/basic_test.dart

# Integration tests
fvm flutter drive --driver=test_driver/screenshot_driver.dart --target=integration_test/app_test.dart

# Switch scanner implementation (then run pub get)
./ci/dependencies/scanner/enable_mlkit_dependency.sh   # ML Kit (Google services)
./ci/dependencies/scanner/enable_zxing_dependency.sh   # ZXing (open source, F-Droid)
```

## Architecture

### Multi-Package Workspace

```
packages/
  smooth_app/          # Main Flutter application
  scanner/
    shared/            # Scanner interface abstraction
    ml_kit/            # ML Kit barcode scanning (Play Store / App Store)
    zxing/             # ZXing scanning (F-Droid)
  app_store/
    shared/            # App store interface abstraction
    google_play/       # Google Play integration
    apple_app_store/   # Apple App Store integration
    uri_store/         # URI-based store (F-Droid, etc.)
```

Each platform variant has its own entry point in `lib/entrypoints/` that wires up the appropriate scanner and app store implementations via a plugin architecture.

### Key Architectural Patterns

- **State management**: Provider with ChangeNotifier classes (e.g., `ProductPreferences`, `UserManagementProvider`, `PriceModel`)
- **Navigation**: GoRouter via `AppNavigator` wrapper (`lib/pages/navigator/`)
- **Local storage**: SQLite (sqflite) for relational data, Hive for caching, SharedPreferences for simple prefs, flutter_secure_storage for secrets
- **Database access**: DAO pattern — separate DAOs in `lib/database/` for products, lists, user data, locations
- **API layer**: `openfoodfacts` Dart package; query builders in `lib/query/`
- **Background tasks**: Queue-based async operations in `lib/background/` (uploads, crops, product changes)
- **Localization**: Flutter ARB-based i18n in `lib/l10n/` (130+ languages, synced via Crowdin)
- **Linting**: `openfoodfacts_flutter_lints` custom rules (see `analysis_options.yaml`)
- **Analytics**: Sentry for crash reporting, Matomo for usage tracking

### Main lib/ Organization

| Directory | Purpose |
|-----------|---------|
| `entrypoints/` | Platform-specific main() functions |
| `data_models/` | Provider/ChangeNotifier state classes |
| `database/` | DAOs and local persistence |
| `pages/` | All screens (product, scan, search, prices, onboarding, etc.) |
| `widgets/` | Reusable UI components (`smooth_*` themed widgets) |
| `helpers/` | Utility functions and extensions |
| `query/` | Open Food Facts API query builders |
| `background/` | Background task execution |
| `generic_lib/` | Generic utilities, animations (Rive), design constants |
| `themes/` | Theme configuration and color schemes |
| `l10n/` | Localization ARB files |
| `resources/` | Static resources, app icons |
| `services/` | Service abstractions |

### Platform Requirements

- Flutter 3.38.5 (enforce with FVM)
- Java JDK 21 (Android builds)
- Xcode (iOS builds on macOS)

### PR Guidelines

- Naming: `type: description` (feat, fix, docs, ci, refactor, chore)
- Include before/after screenshots for UI changes
- Dev mode available via Preferences > Contribute > Software Development

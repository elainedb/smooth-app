# Flutter & Dart Project

This is a Flutter application. Follow these conventions when working in this codebase.

## Project Structure

- Entry point: `lib/main.dart`
- Organize into logical layers: Presentation (widgets/screens), Domain (business logic), Data (models/API clients), Core (shared utilities)
- For larger features, organize by feature with presentation/domain/data subfolders
- Use `snake_case` for file names

## Code Style

- Follow Effective Dart guidelines (https://dart.dev/effective-dart)
- Use `PascalCase` for classes, `camelCase` for members/variables/functions/enums, `snake_case` for files
- Line length: 80 characters max
- Keep functions short and single-purpose (under 20 lines)
- Use arrow syntax for simple one-line functions
- Write concise, declarative Dart code; prefer functional patterns
- Avoid abbreviations; use meaningful, descriptive names
- Run `dart format` after modifying Dart files
- Run `dart fix --apply` to auto-fix common issues
- Run `dart analyze` to check for lint issues

## Dart Conventions

- Write sound null-safe code; avoid `!` unless the value is guaranteed non-null
- Use `async`/`await` for async operations with proper error handling
- Use `Future` for single async operations, `Stream` for sequences of async events
- Use pattern matching where it simplifies code
- Use records to return multiple types when a full class is overkill
- Prefer exhaustive `switch` statements/expressions (no `break` needed)
- Use `try-catch` with appropriate exception types; create custom exceptions when needed

## Flutter Conventions

- Apply SOLID principles throughout the codebase
- Favor composition over inheritance
- Prefer immutable data structures; widgets (especially `StatelessWidget`) should be immutable
- Use `const` constructors wherever possible to reduce rebuilds
- Use small, private `Widget` classes instead of helper methods returning `Widget`
- Break large `build()` methods into smaller private widget classes
- Never perform expensive operations (network calls, computations) inside `build()`
- Use `ListView.builder` or `SliverList` for long lists (lazy loading)
- Use `compute()` for expensive calculations to avoid blocking the UI thread

## State Management

- Prefer Flutter's built-in state management; do not use third-party packages unless explicitly requested
- Use `ValueNotifier` + `ValueListenableBuilder` for simple single-value local state
- Use `ChangeNotifier` + `ListenableBuilder` for complex or shared state
- Use `FutureBuilder` for single async operations, `StreamBuilder` for async event sequences
- When robust architecture is needed, use MVVM (Model-View-ViewModel)
- Use manual constructor dependency injection to keep dependencies explicit
- Separate ephemeral state from app state

## Navigation

- Use `go_router` for declarative navigation, deep linking, and web support
- Use built-in `Navigator` only for short-lived screens (dialogs, temporary views)
- Configure `go_router`'s `redirect` for authentication flows

## Data & Serialization

- Use `json_serializable` + `json_annotation` for JSON parsing/encoding
- Use `fieldRename: FieldRename.snake` when encoding to snake_case JSON keys
- Abstract data sources using Repositories/Services for testability

## Code Generation

- Ensure `build_runner` is a dev dependency when using code generation
- After modifying files requiring codegen, run: `dart run build_runner build --delete-conflicting-outputs`

## Package Management

- Add dependencies: `flutter pub add <package_name>`
- Add dev dependencies: `flutter pub add dev:<package_name>`
- Remove dependencies: `dart pub remove <package_name>`
- When suggesting new dependencies, explain their benefits

## Logging

- Use `dart:developer`'s `log` function for structured logging (integrates with DevTools)
- Never use `print` for logging

## Theming & Visual Design

- Define a centralized `ThemeData`; use `ColorScheme.fromSeed()` for harmonious palettes
- Implement both light and dark themes via `MaterialApp`'s `theme` and `darkTheme`
- Customize component themes (`appBarTheme`, `elevatedButtonTheme`, `cardTheme`) within `ThemeData`
- Use `ThemeExtension` for custom design tokens not covered by standard `ThemeData`
- Use `google_fonts` package for custom fonts; define a `TextTheme` for consistency
- Use `Theme.of(context).textTheme` for text styles in widgets
- Follow the 60-30-10 color rule: 60% primary/neutral, 30% secondary, 10% accent

## Layout

- Use `LayoutBuilder` or `MediaQuery` for responsive UIs
- Use `Expanded` to fill remaining space, `Flexible` to shrink-to-fit (don't combine both)
- Use `Wrap` instead of `Row`/`Column` when content may overflow
- Use `SingleChildScrollView` for fixed-size content larger than the viewport

## Images & Assets

- Declare all asset paths in `pubspec.yaml`
- Use `Image.asset` for local images, `Image.network` for remote images
- Always include `loadingBuilder` and `errorBuilder` with `Image.network`
- Use `cached_network_image` for cached remote images

## Accessibility

- Ensure text contrast ratio of at least 4.5:1 (WCAG 2.1)
- Test with dynamic text scaling enabled
- Use the `Semantics` widget for descriptive labels
- Test with TalkBack (Android) and VoiceOver (iOS)

## Testing

- Run tests with `flutter test`
- Use `package:test` for unit tests, `package:flutter_test` for widget tests, `package:integration_test` for integration tests
- Prefer `package:checks` for assertions over default matchers
- Follow Arrange-Act-Assert (Given-When-Then) pattern
- Prefer fakes/stubs over mocks; use `mockito` or `mocktail` only when necessary
- Aim for high test coverage across domain logic, data layer, state management, and UI

## Documentation

- Use `///` doc comments on all public APIs
- Start with a single-sentence summary, then a blank line, then details
- Comment *why*, not *what*; don't restate the obvious
- Place doc comments before annotations

## Lint Rules

Use this `analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Add additional lint rules here
```

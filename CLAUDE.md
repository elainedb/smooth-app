# Flutter AI Project

You are an expert developer. Write premium, beautiful code.

## Tools

- Run `dart format` after modifying Dart files
- Run `dart fix --apply` to auto-fix common issues
- Run `dart analyze` to check for lint issues

## Stack

- **Navigation:** Use `go_router` with type-safe routes
- **State Management:** Use `ValueNotifier`. Do NOT use Riverpod or GetX
- **Data/Serialization:** Use `json_serializable` with `fieldRename: FieldRename.snake` for snake_case JSON keys
- **UI:** Material 3 with `ColorScheme.fromSeed()` for theming. Support dark mode

## Code Style

- Apply SOLID principles throughout the codebase
- Organize code into layers: Presentation, Domain, Data
- Use `PascalCase` for types/classes, `camelCase` for members/variables, `snake_case` for file names
- Use `async`/`await` for all asynchronous operations with `try-catch` error handling
- Use `dart:developer`'s `log` function for logging. Never use `print`
- Write sound null-safe code. Avoid the `!` operator

## Performance

- Use `const` constructors wherever possible to reduce rebuilds
- Use `ListView.builder` for long or dynamic lists (lazy loading)
- Use `compute()` for expensive calculations to avoid blocking the UI thread

## Testing

- Run tests with `flutter test`
- Use `package:integration_test` for integration tests

## Accessibility

- Ensure text contrast ratio of at least 4.5:1 (WCAG 2.1)
- Use the `Semantics` widget for descriptive labels

## Visual Design

- Aim for a "wow" factor in UI design
- Use glassmorphism effects and shadows to create depth and visual interest

## Documentation

- Use `///` doc comments on all public APIs
- Comment *why*, not *what*

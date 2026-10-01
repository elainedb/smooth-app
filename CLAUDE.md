# Flutter Clean Architecture Project

Follow Clean Architecture (Robert C. Martin) with strict layer separation: Presentation, Domain, Data.

## Architecture Rules

- Inner layers MUST NOT depend on outer layers; dependencies point inward (Dependency Inversion)
- Business logic MUST remain independent of frameworks
- Apply SOLID principles throughout the codebase
- Favor composition over inheritance
- Prefer immutable data structures

## Project Structure

Organize by feature, with each feature containing `data/`, `domain/`, and `presentation/` subfolders:

```
lib/
├── core/
│   ├── errors/          # Custom exceptions and failure types
│   ├── usecases/        # Abstract use case base classes
│   ├── utils/           # Shared utilities and extensions
│   └── constants/       # Application constants
├── features/
│   └── [feature_name]/
│       ├── data/
│       │   ├── datasources/   # Remote and local data sources
│       │   ├── models/        # DTOs with JSON serialization
│       │   ├── repositories/  # Repository implementations
│       │   └── services/      # External service integrations
│       ├── domain/
│       │   ├── entities/      # Business entities (freezed)
│       │   ├── repositories/  # Repository interfaces (abstract)
│       │   └── usecases/      # Business use cases
│       └── presentation/
│           ├── bloc/          # BLoC, events, and states
│           ├── pages/         # Screen widgets
│           └── widgets/       # Feature-specific widgets
├── shared/
│   ├── widgets/         # Reusable UI components
│   ├── theme/           # App theming and styling
│   ├── routing/         # Navigation configuration
│   └── config/          # App configuration
├── di.dart              # Dependency injection setup
└── main.dart            # Application entry point
```

## Feature Implementation Order

When creating a new feature, always implement layers in this order:

1. **Domain layer first**: entities, repository interfaces, use cases
2. **Data layer second**: models, data sources, repository implementations
3. **Presentation layer third**: BLoC/events/states, pages, widgets

## Code Style

- Use `PascalCase` for classes, `camelCase` for members/variables/functions, `snake_case` for file names, `SCREAMING_SNAKE_CASE` for constants
- Line length: 100 characters max
- Use arrow syntax for simple one-line functions
- Write sound null-safe code; avoid `!` unless the value is guaranteed non-null
- Use `async`/`await` with proper error handling
- Run `dart format` after modifying Dart files
- Run `dart fix --apply` to auto-fix common issues
- Run `dart analyze` to check for lint issues

## Naming Conventions

- **Entities**: domain object names (`User`, `Product`)
- **Models**: data objects with `Model` suffix (`UserModel`, `ProductModel`)
- **Repositories**: interface without suffix, implementation with `Impl` (`UserRepository`, `UserRepositoryImpl`)
- **Use Cases**: action-based with `UseCase` suffix (`GetUserUseCase`, `CreateOrderUseCase`)
- **BLoCs**: feature-based with `Bloc` suffix (`UserBloc`, `OrderBloc`)

## Import Order

1. `dart:` system imports
2. `package:flutter/` SDK imports
3. External package imports
4. Internal imports — core
5. Internal imports — feature

## State Management

- Use `flutter_bloc` (BLoC pattern) for state management
- Define events and states using `freezed`
- Use `BlocBuilder` with `buildWhen` for selective rebuilds
- Do NOT use `setState` for complex state management
- Do NOT put business logic in widgets

## Dependency Injection

- Use `get_it` + `injectable` for DI
- Register repositories as `@LazySingleton(as: RepositoryInterface)`
- Register use cases and BLoCs as `@injectable`
- Use `@dev` / `@prod` annotations for environment-specific configuration
- Run code generation after modifying injectable classes

## Data Patterns

- Use `freezed` for all data classes (entities, models, events, states, failures)
- Use `json_serializable` + `json_annotation` for JSON serialization
- Use `Either<Failure, T>` from `dartz` for all repository return types — never throw from repositories
- Models must have `toEntity()` and `fromEntity()` conversion methods
- Use `@JsonKey(name: 'snake_case')` for API field mapping

## Error Handling

- Define an `AppException` hierarchy (`ServerException`, `CacheException`, `NetworkException`)
- Define a `Failure` sealed class using `freezed` (`ServerFailure`, `CacheFailure`, `NetworkFailure`, `ValidationFailure`)
- Repositories catch exceptions and return `Left(Failure)` — never let exceptions propagate
- BLoCs emit error states with failure messages

## Repository Pattern

- Define abstract repository interfaces in `domain/repositories/`
- Implement repositories in `data/repositories/` with `@LazySingleton` annotation
- Repositories coordinate between remote and local data sources
- Implement offline-first: check local cache, fall back to remote, cache results

## Use Case Pattern

- Each use case extends `UseCase<ReturnType, Params>` with a single `call()` method
- Use `NoParams` for parameterless use cases
- Define params with `freezed`

## Network Layer

- Use `dio` for HTTP requests
- Use `retrofit` for type-safe API clients (optional)
- Configure timeouts: 30s connect, 30s receive
- Add interceptors for logging, auth tokens, and error handling

## Navigation

- Use `go_router` for declarative navigation and deep linking

## Code Generation

- Run after creating or modifying freezed/json/injectable classes:
  `flutter packages pub run build_runner build --delete-conflicting-outputs`
- Exclude generated files in `analysis_options.yaml`: `**/*.g.dart`, `**/*.freezed.dart`

## Testing

- Run tests with `flutter test`
- Follow the testing pyramid: 70% unit, 20% widget, 10% integration
- Use Arrange-Act-Assert pattern in all tests
- Use `mocktail` for mocks, prefer fakes for complex objects
- Use `bloc_test` for BLoC testing
- Create test fixtures in shared files for reusable test data
- Every feature MUST have corresponding tests
- Minimum coverage: 80% overall, 95% for business logic, 100% for error handling

## Performance

- Use `const` constructors wherever possible
- Use `ListView.builder` for long or dynamic lists
- Implement `buildWhen` on `BlocBuilder` for selective rebuilds
- Cancel stream subscriptions in `BLoC.close()`
- Use `CachedNetworkImage` for remote images
- Use `compute()` for expensive calculations to avoid blocking the UI thread

## Accessibility

- All interactive elements must have semantic labels
- Ensure text contrast ratio of at least 4.5:1 (WCAG 2.1)
- Support keyboard navigation and screen readers
- Test with TalkBack (Android) and VoiceOver (iOS)

## Security

- Never hardcode API keys or sensitive data
- Use secure storage for tokens and credentials
- Implement proper input validation at system boundaries
- Use HTTPS for all network requests

## Documentation

- Use `///` doc comments on all public APIs
- Start with a single-sentence summary, then details after a blank line
- Comment *why*, not *what*

## Lint Rules

Use this `analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_declare_return_types
    - always_use_package_imports
    - avoid_dynamic_calls
    - avoid_empty_else
    - avoid_relative_lib_imports
    - prefer_single_quotes
    - sort_constructors_first
    - sort_unnamed_constructors_first
    - unawaited_futures
    - use_super_parameters

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  errors:
    invalid_annotation_target: ignore
```

## Forbidden Practices

- Do NOT use `setState` for complex state management
- Do NOT put business logic in widgets
- Do NOT make direct API calls from UI components
- Do NOT skip error handling in repositories
- Do NOT create features without tests
- Do NOT use `dynamic` types without strong justification
- Do NOT ignore static analysis warnings
- Do NOT use `print` for logging — use `dart:developer`'s `log`

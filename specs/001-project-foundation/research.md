# Research: Project Foundation

## Decisions & Rationale

### 1. State Management Pattern
- **Decision**: Riverpod 2.x with `@riverpod` annotations (Code Generation).
- **Rationale**: The constitution mandates Riverpod with code generation for better type safety and reduced boilerplate.
- **Alternatives considered**: BLoC (rejected due to constitution), manual Riverpod (rejected due to boilerplate).

### 2. Local Persistence Engine
- **Decision**: Hive.
- **Rationale**: Faster than SQLite for simple object storage and matches the constitution's suggestion. It's well-suited for "thought monitoring" which is mostly append-heavy.
- **Alternatives considered**: Isar (strong candidate, but Hive is simpler for initial foundation).

### 3. Folder Structure (Clean Architecture)
- **Decision**: Feature-first structure with internal Clean Architecture layers.
- **Rationale**: Scales better than layer-first. Facilitates finding code related to "tracker" or "history" quickly while maintaining separation of concerns within each feature.

### 4. Typography Integration
- **Decision**: `google_fonts` package.
- **Rationale**: Specified in `task-001.md`. Allows for quick iteration on the "Bunny Core Romantic" aesthetic without manual asset management in the foundation phase.

## Best Practices Identified

- **Riverpod**: ViewModels should be `AsyncNotifier` if they load data, or `Notifier` for synchronous state.
- **Design**: All spacing should use `AppSizes` constants to ensure the "Radius minimum of 28.0" is consistently applied.
- **Flutter**: Use `Material 3` as it's the current standard and supports the desired aesthetics well.

## Open Questions Resolved

- **Auth**: Not required for Phase 1 foundation.
- **Navigation**: Simple `MaterialPageRoute` for now, will evaluate `go_router` if complexity increases.

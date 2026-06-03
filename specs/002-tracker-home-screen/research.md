# Research: Tracker Home Screen

## 1. Hive Persistence & Thought Model
- **Decision**: Use `HiveObject` for the `Thought` model to leverage easy saving and deleting.
- **Rationale**: Hive is the project standard and offers high performance for simple event-based data.
- **Implementation**:
    - `typeId: 0` for `Thought`.
    - Adapter generation via `build_runner`.

## 2. Streak Calculation Logic
- **Decision**: Implement streak calculation in the `ThoughtRepository` implementation.
- **Rationale**: Keeps business logic out of the UI and allows for unit testing the repository.
- **Logic**:
    1. Get all entry dates sorted descending.
    2. Iterate through dates: if a day is missing (except today if not yet recorded), the streak ends.
    3. Return the count.

## 3. Riverpod AsyncNotifier for UI State
- **Decision**: Use `@riverpod` with `AsyncNotifier` to handle the asynchronous loading of stats.
- **Rationale**: Complies with Constitution Section 5 and ensures smooth state transitions (loading/data/error).
- **State**: A custom `TrackerState` class containing `count`, `streak`, and `lastEntry`.

## 4. Custom UI Components (Bunny Core)
- **Decision**: Use `CustomPainter` or `Stack` with `Container` for the heart icon and circular bunny button.
- **Rationale**: Standard Flutter widgets are sufficient for the designs seen in the mockup (using `BoxDecoration` with `shape: BoxShape.circle` and `BorderRadius.circular(28.0)`).
- **Icons**: Use `material_design_icons_flutter` or standard `Icons` if suitable icons exist (e.g., `pets` for bunny, `favorite_border` for heart).

## 5. View-ViewModel Separation
- **Decision**: ViewModels will strictly follow the Notifier pattern.
- **Rationale**: Alignment with project constitution and testability.

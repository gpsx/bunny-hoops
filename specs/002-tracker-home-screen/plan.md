# Implementation Plan: Tracker Home Screen

**Branch**: `002-tracker-home-screen` | **Date**: 2026-05-07 | **Spec**: [/specs/002-tracker-home-screen/spec.md](/Users/cit/Documents/GitHub/Bunny%20hoops/specs/002-tracker-home-screen/spec.md)

## Summary
Implement the main Tracker screen where users can record thoughts by tapping a central bunny button. This includes Hive persistence for entries, Riverpod-managed state for UI metrics (streak, daily total), and custom "Bunny Core" UI components.

## Technical Context
- **Language/Version**: Dart (Flutter SDK >= 3.0.0)
- **Primary Dependencies**: `flutter_riverpod`, `riverpod_annotation`, `hive`, `hive_flutter`, `google_fonts`.
- **Storage**: Hive (Local persistence).
- **Testing**: Unit tests for `TrackerViewModel` and `ThoughtRepository`.
- **Target Platform**: Android, iOS, macOS, Web.
- **Project Type**: Mobile App (Flutter).
- **Performance Goals**: Action feedback (counter increment) < 100ms.
- **Constraints**: "Bunny Core Romantic" design system compliance.

## Constitution Check
*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Pillar 2 (Tech Stack)**: Using Riverpod, Hive, and Clean Architecture. **[PASS]**
- **Pillar 3 (Design)**: Colors (#FFB7CE, #FFFDF5, etc.) and shapes (Radius 28/50) are integrated. **[PASS]**
- **Pillar 4 (Standards)**: No hard-coded values; using centralized constants. **[PASS]**
- **Pillar 5 (Architecture)**: ViewModels follow the `_$NameNotifier` pattern. **[PASS]**
- **Pillar 6 (Testing)**: Unit tests for business logic are included in the plan. **[PASS]**

## Project Structure

### Documentation (this feature)

```text
specs/002-tracker-home-screen/
├── plan.md              # This file
├── research.md          # Research findings (persistence, streak logic)
├── data-model.md        # Thought entity definition
├── quickstart.md        # Verification steps
├── contracts/           # ThoughtRepository interface
└── tasks.md             # Implementation tasks (Phase 2)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── theme/           # Updated with specific component styles
│   └── widgets/         # [NEW] BunnyRecordButton, DailyCounterDisplay, MetricCard
├── features/
│   └── tracker/
│       ├── models/      # Thought model with Hive adapter
│       ├── views/       # TrackerView (Main screen)
│       └── view_models/ # TrackerViewModel (State management)
├── data/
│   └── repositories/    # Hive-based ThoughtRepository implementation
└── main.dart            # Update with Hive initialization
```

**Structure Decision**: Single project with feature-first organization as mandated by the constitution.

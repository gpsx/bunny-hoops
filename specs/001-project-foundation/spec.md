# Feature Specification: Project Foundation

**Feature Branch**: `001-project-foundation`  
**Created**: 2026-05-07  
**Status**: Draft  
**Input**: User description: "Setup do projeto Bunny hoops com base no task-001.md e constitution.md"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Project Initialization (Priority: P1)

As a developer, I want to have a clean and structured Flutter project setup so that I can start building features according to the project constitution.

**Why this priority**: Essential first step. Without a foundation, no other work can proceed.

**Independent Test**: The project should compile and run on an emulator/device, showing a "Foundation Ready" placeholder.

**Acceptance Scenarios**:

1. **Given** the repository is initialized, **When** I check the project structure, **Then** I should see the standard directory layout (lib/core, lib/features, lib/data, etc.).
2. **Given** the pubspec.yaml is configured, **When** I run `flutter pub get`, **Then** all dependencies (Riverpod, Hive, Google Fonts) should be installed correctly.

---

### User Story 2 - Design System Implementation (Priority: P2)

As a developer, I want to have all design constants (colors, sizes, strings) available in code so that I can maintain visual consistency without hard-coding values.

**Why this priority**: Ensures the "Bunny Core Romantic" aesthetic is followed from the start and avoids technical debt.

**Independent Test**: The UI should display colors and fonts that match the "Bunny Core Romantic" palette defined in the constitution.

**Acceptance Scenarios**:

1. **Given** the app is running, **When** I look at the main screen, **Then** I should see the background color #FFFDF5 and text using the "Plus Jakarta Sans" font.
2. **Given** I am writing a new widget, **When** I access `AppColors` or `AppStrings`, **Then** I should find the pre-defined values for the project.

---

### Edge Cases

- What happens if the environment does not have Flutter/Dart installed? (Standard CLI error, handled outside the app).
- How does the system handle missing font files or failed network requests for Google Fonts? (Should have a fallback font).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Project MUST be named `bunny_hoops`.
- **FR-002**: Project MUST use Flutter SDK version >=3.0.0.
- **FR-003**: System MUST implement a specific directory structure:
    - `lib/core/` (constants, theme, widgets)
    - `lib/features/` (tracker, history)
    - `lib/data/` (repositories, datasources)
- **FR-004**: System MUST define a central theme following the "Bunny Core Romantic" aesthetic.
- **FR-005**: System MUST include the following core colors:
    - Primary: #FFB7CE (Blush Pink)
    - Secondary: #FF8C42 (Soft Orange)
    - Background: #FFFDF5 (Cream)
    - Text: #8D7B7B (Warm Grey)
- **FR-006**: System MUST use the `Plus Jakarta Sans` font.
- **FR-007**: System MUST be configured to use `Riverpod` for state management with code generation.
- **FR-008**: System MUST be prepared for `Hive` persistence.

### Key Entities *(include if feature involves data)*

- **ThemeData**: Represents the visual style of the application, including colors and typography.
- **AppConstants**: Represents the fixed values used throughout the application (Strings, Sizes, Colors).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: App builds and launches successfully in under 60 seconds on a standard developer machine.
- **SC-002**: 100% of UI elements use constants from the design system files instead of hard-coded values.
- **SC-003**: `flutter analyze` returns zero errors and zero warnings (using `flutter_lints`).
- **SC-004**: All required directories are present and contain the initialized placeholder files.

## Assumptions

- The developer has the Flutter SDK and necessary tools installed.
- "Bunny Core Romantic" design specs in `constitution.md` are final for this phase.
- `Google Fonts` will be accessible during development for font loading.

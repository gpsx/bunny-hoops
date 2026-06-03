# Tasks: Project Foundation

**Feature**: Project Foundation | **Plan**: [/specs/001-project-foundation/plan.md](/Users/cit/Documents/GitHub/Bunny%20hoops/specs/001-project-foundation/plan.md)

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Create project structure (lib/core, lib/features, lib/data) per implementation plan
- [x] T002 Initialize Flutter project with dependencies in `pubspec.yaml`
- [x] T003 [P] Configure linting and formatting in `analysis_options.yaml`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core design tokens and theme infrastructure

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T004 Create `lib/core/theme/app_colors.dart` with Bunny Core Romantic palette
- [x] T005 [P] Create `lib/core/constants/app_values.dart` with standard spacing and radius (28.0/50.0)
- [x] T006 [P] Create `lib/core/constants/app_strings.dart` with initial app strings
- [x] T007 Create `lib/core/theme/app_theme.dart` using Material 3 and Plus Jakarta Sans

**Checkpoint**: Foundation ready - constants and theme are available for use

---

## Phase 3: User Story 1 - Project Initialization (Priority: P1) 🎯 MVP

**Goal**: Run the app with a "Bunny hoops Foundation Ready" placeholder and valid structure.

**Independent Test**: The app compiles and displays the "Foundation Ready" message using the "Bunny Core Romantic" theme.

### Implementation for User Story 1

- [x] T008 [US1] Implement `lib/main.dart` with `ProviderScope` and `MaterialApp` config
- [x] T009 [US1] Implement `InitialPlaceholder` widget in `lib/main.dart`
- [ ] T010 [US1] Run `flutter pub get` and verify dependencies are resolved
- [x] T011 [US1] Verify app launch on emulator/device showing the correct placeholder text

**Checkpoint**: At this point, the project is technically ready for feature development.

---

## Phase 4: User Story 2 - Design System Implementation (Priority: P2)

**Goal**: Ensure all core models and interfaces are defined according to the data model and contracts.

**Independent Test**: Verify that the `Thought` model and `ThoughtRepository` interface exist and follow the spec.

### Implementation for User Story 2

- [x] T012 [P] [US1] Create `Thought` model in `lib/features/tracker/models/thought.dart`
- [x] T013 [P] [US1] Create `ThoughtRepository` interface in `lib/data/repositories/thought_repository.dart`
- [x] T014 [US2] Verify `MaterialApp` theme uses `AppColors` and `AppSizes` correctly in `lib/main.dart`

**Checkpoint**: Core contracts and design system are fully integrated.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Final validation and cleanup

- [ ] T015 [P] Run `flutter analyze` and fix any linting issues
- [ ] T016 Run `quickstart.md` validation steps to ensure setup is reproducible
- [ ] T017 Final check of folder structure against Constitution.md Section 7

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup (T001).
- **User Stories (Phase 3+)**: Depend on Foundational completion (T004-T007).
- **Polish (Phase 5)**: Depends on all implementation tasks.

### User Story Dependencies

- **User Story 1 (P1)**: Foundation for everything.
- **User Story 2 (P2)**: Can be done in parallel with US1 implementation but needs the structure from Setup.

### Parallel Opportunities

- T003 can run in parallel with T001/T002.
- T005 and T006 can run in parallel with T004.
- T012 and T013 can run in parallel within Phase 4.
- T015 can run in parallel with other polish tasks.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Complete US1 (T008-T011).
3. **STOP and VALIDATE**: Ensure the app runs and follows the design system basic rules.

### Incremental Delivery

1. Foundation ready (Phase 1 + 2).
2. App scaffold running (Phase 3).
3. Core contracts and models defined (Phase 4).
4. Polish and validation (Phase 5).

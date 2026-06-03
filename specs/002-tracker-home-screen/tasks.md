# Tasks: Tracker Home Screen

**Feature**: Tracker Home Screen | **Plan**: [/specs/002-tracker-home-screen/plan.md](/Users/cit/Documents/GitHub/Bunny%20hoops/specs/002-tracker-home-screen/plan.md)

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Persistence and project initialization

- [x] T001 Register Hive adapter and initialize `thoughts` box in `lib/main.dart`
- [x] T002 [P] Configure `Thought` model Hive annotations in `lib/features/tracker/models/thought.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core data layer implementation

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T003 Implement `ThoughtRepository` implementation with Hive in `lib/data/repositories/thought_repository_impl.dart`
- [x] T004 Create `thoughtRepositoryProvider` in `lib/data/repositories/thought_repository_impl.dart`
- [x] T005 Run `flutter pub run build_runner build` to generate Hive adapters

**Checkpoint**: Data layer is ready for state management

---

## Phase 3: User Story 1 - Record a Thought (Priority: P1) 🎯 MVP

**Goal**: Tap the central bunny button to record a thought and see the daily count increment.

**Independent Test**: Tapping the bunny button updates the heart-shaped counter on the screen and persists the entry.

### Implementation for User Story 1

- [x] T006 [P] [US1] Create `DailyCounterDisplay` atomic widget with heart icon in `lib/core/widgets/daily_counter_display.dart`
- [x] T007 [P] [US1] Create `BunnyRecordButton` atomic widget with bunny icon in `lib/core/widgets/bunny_record_button.dart`
- [x] T008 [US1] Implement `TrackerViewModel` (Notifier) with `recordNewThought` logic in `lib/features/tracker/view_models/tracker_view_model.dart`
- [x] T009 [US1] Create `TrackerView` layout and bind to `TrackerViewModel` in `lib/features/tracker/views/tracker_view.dart`
- [x] T010 [US1] Add unit test for `recordNewThought` logic in `test/unit/tracker_view_model_test.dart`

**Checkpoint**: User Story 1 is functional and testable on its own.

---

## Phase 4: User Story 2 - View Progress Metrics (Priority: P2)

**Goal**: View the usage streak and the time of the last entry today.

**Independent Test**: The streak and last entry cards display accurate values based on historical data.

### Implementation for User Story 2

- [x] T011 [P] [US2] Create `MetricCard` atomic widget in `lib/core/widgets/metric_card.dart`
- [x] T012 [US2] Implement streak calculation logic in `ThoughtRepositoryImpl`
- [x] T013 [US2] Update `TrackerViewModel` to include `streak` and `lastEntry` in the state
- [x] T014 [US2] Integrate `MetricCard`s (Last Entry & Streak) into `TrackerView`
- [x] T015 [US2] Add unit test for streak calculation in `test/unit/thought_repository_test.dart`

**Checkpoint**: All metrics from the design are fully implemented and accurate.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Final UI refinements and navigation

- [x] T016 [P] Create `AmandaBottomNav` widget in `lib/core/widgets/amanda_bottom_nav.dart`
- [x] T017 [P] Create `HistoryView` placeholder in `lib/features/history/views/history_view.dart`
- [x] T018 [P] Ensure 100% adherence to design tokens (Colors, Spacing, Radius) in all new widgets
- [x] T019 Final code generation run and `flutter analyze` check

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Phase 1 (T001-T002).
- **User Stories (Phase 3+)**: Depend on Foundational completion.
- **Polish (Phase 5)**: Depends on all implementation tasks.

### User Story Dependencies

- **User Story 1 (P1)**: MVP.
- **User Story 2 (P2)**: Extends US1 metrics.

### Parallel Opportunities

- T002, T006, T007, T011, T016 can all run in parallel as they are independent files.
- Unit tests can be written in parallel with the code implementation they verify.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational.
2. Build `DailyCounterDisplay` and `BunnyRecordButton`.
3. Connect logic via `TrackerViewModel`.
4. **STOP and VALIDATE**: Test the record flow on Chrome/Emulator.

### Incremental Delivery

1. Foundation (Phase 1 + 2).
2. Record functionality (Phase 3).
3. Metric displays (Phase 4).
4. Final navigation and polish (Phase 5).

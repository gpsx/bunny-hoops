---
description: "Task list for Android Home Widget integration"
---

# Tasks: Android Home Widget

**Input**: Design documents from `/specs/004-android-widget/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, quickstart.md

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure.

- [x] T001 Initialize `home_widget` dependency in `pubspec.yaml`
- [x] T002 [P] Create initial `xml` layout directories in `android/app/src/main/res/layout` and `values`
- [x] T003 Register `HomeWidgetProvider` and background receiver in `android/app/src/main/AndroidManifest.xml`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core native Android components needed before Flutter can push or receive widget events.

- [x] T004 Create `widget_layout.xml` in `android/app/src/main/res/layout/widget_layout.xml` mirroring the Bunny Core UI (Heart + Text)
- [x] T005 [P] Map Bunny Core colors to `android/app/src/main/res/values/colors.xml`
- [x] T006 Create `WidgetProvider.kt` in `android/app/src/main/kotlin/.../WidgetProvider.kt` to handle widget updates natively.

**Checkpoint**: Foundation ready - user story implementation can now begin.

---

## Phase 3: User Story 1 - View Daily Thoughts Count on Home Screen (Priority: P1) 🎯 MVP

**Goal**: Show the daily count on the widget when updated from the app.

**Independent Test**: Can be fully tested by adding a thought inside the app and verifying the home screen widget updates its number.

### Implementation for User Story 1

- [x] T007 [US1] Create a shared utility `HomeWidgetService` in `lib/core/services/home_widget_service.dart` to save `daily_count` and `last_update_timestamp`.
- [x] T008 [US1] Update `TrackerViewModel` to call `HomeWidgetService.updateData()` and `HomeWidget.updateWidget()` after recording a thought.
- [x] T009 [US1] Update `WidgetProvider.kt` to read `daily_count` and `last_update_timestamp` from SharedPreferences and render the layout.

**Checkpoint**: At this point, User Story 1 should be fully functional. Recording a thought in the app updates the Android widget.

---

## Phase 4: User Story 2 - Record Thought via Widget (Priority: P1)

**Goal**: Instantly record a thought by tapping the widget (Headless Execution).

**Independent Test**: Can be fully tested by killing the app, tapping the widget heart, and verifying the counter updates.

### Implementation for User Story 2

- [x] T010 [US2] Create Dart headless background callback `interactiveCallback(Uri? uri)` in `lib/core/services/home_widget_service.dart`.
- [x] T011 [US2] Implement Hive logic inside the headless callback to save a new `Thought` and update `SharedPreferences`.
- [x] T012 [US2] Register background callback in `main.dart`.
- [x] T013 [US2] Add PendingIntent click listener in `WidgetProvider.kt` / `widget_layout.xml` to trigger the background callback.

**Checkpoint**: User Story 1 and 2 should both work. Tapping the widget records a thought directly.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories.

- [x] T014 [P] Implement Midnight Reset logic inside `WidgetProvider.kt` (check if `last_update_timestamp` is from yesterday and force render 0).
- [x] T015 Run `quickstart.md` manual verification steps.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup completion
- **User Stories (Phase 3+)**: Depend on Foundational phase completion
- **Polish (Final Phase)**: Depends on user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational
- **User Story 2 (P1)**: Can start after User Story 1

### Parallel Opportunities

- T002 and T005 (XML resource creation) can run in parallel.
- Foundational Android XML UI (T004) can be worked on in parallel with Flutter Service creation (T007).

## Implementation Strategy

### MVP First
1. Complete Phase 1 and 2 (Basic XML and Plugin setup).
2. Complete Phase 3 (Pushing data from Flutter to Widget).
3. **VALIDATE**: See if the widget renders correctly on the emulator.
4. Complete Phase 4 (Headless Task Execution).

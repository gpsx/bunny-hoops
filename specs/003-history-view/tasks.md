---
description: "Task list for History View implementation"
---

# Tasks: History View

**Input**: Design documents from `/specs/003-history-view/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, quickstart.md

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure. Because this is a feature addition to an existing app, setup is minimal.

- [x] T001 Create basic view file `HistoryView` replacing placeholder in `lib/features/history/views/history_view.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core state definitions needed by the ViewModels and UI.

- [x] T002 Implement view models `HistoryState` and `DayAggregate` in `lib/features/history/view_models/history_state.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin.

---

## Phase 3: User Story 1 - View Total Thoughts (Priority: P1) 🎯 MVP

**Goal**: Users want to see the total number of thoughts they have recorded since they started using the app.

**Independent Test**: Can be fully tested by verifying that the large pink number in the header matches the total number of entries in the local database.

### Implementation for User Story 1

- [x] T003 [P] [US1] Create atomic widget `TotalThoughtsCard` in `lib/core/widgets/total_thoughts_card.dart`
- [x] T004 [US1] Create `HistoryViewModel` in `lib/features/history/view_models/history_view_model.dart` and implement total thoughts calculation logic.
- [x] T005 [P] [US1] Add unit tests for total thoughts calculation in `test/unit/history_view_model_test.dart`
- [x] T006 [US1] Integrate `TotalThoughtsCard` into `HistoryView` and map to ViewModel state.

**Checkpoint**: At this point, User Story 1 should be fully functional. The header with the total number should display accurately.

---

## Phase 4: User Story 2 - View Chronological History (Priority: P1)

**Goal**: Users want to see a list of their past activity grouped by day, so they can review their daily consistency over time.

**Independent Test**: Can be fully tested by adding records on different dates and verifying they are grouped correctly and sorted from newest to oldest.

### Implementation for User Story 2

- [x] T007 [P] [US2] Create atomic widget `HistoryDayTile` in `lib/features/history/views/widgets/history_day_tile.dart`
- [x] T008 [US2] Implement date aggregation logic (grouping by date) inside `HistoryViewModel`.
- [x] T009 [P] [US2] Add unit tests for date grouping logic in `test/unit/history_view_model_test.dart`
- [x] T010 [US2] Integrate `ListView.builder` into `HistoryView` and map to `groupedHistory` state.

**Checkpoint**: At this point, both User Story 1 AND 2 should work independently. The list of thoughts grouped by days should be displayed.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories and design review.

- [x] T011 [P] Ensure all new UI components strictly follow Bunny Core Romantic design tokens (Radius 28.0, AppColors.primary, Plus Jakarta Sans).
- [x] T012 Verify state update trigger when returning from Tracker View.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in sequential priority order.
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2)
- **User Story 2 (P1)**: Can start after User Story 1, depends on the `HistoryViewModel` created in US1.

### Parallel Opportunities

- T003 (Widget creation) can run in parallel with T004 (ViewModel logic).
- T007 (Widget creation) can run in parallel with T008 (ViewModel logic).
- T005 and T009 (Unit Tests) can run in parallel with the View integration tasks.

## Implementation Strategy

### MVP First

1. Complete Phase 1 and Phase 2.
2. Complete Phase 3 (User Story 1).
3. **VALIDATE**: See the total count on the screen.
4. Complete Phase 4 (User Story 2) to finalize the feature.

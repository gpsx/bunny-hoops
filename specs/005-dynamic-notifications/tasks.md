---
description: "Task list for Dynamic Notifications & App Branding feature implementation"
---

# Tasks: Dynamic Notifications & App Branding

**Input**: Design documents from `/specs/005-dynamic-notifications/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Add `flutter_local_notifications` dependency to `pubspec.yaml`
- [x] T002 Add required notification permissions (`POST_NOTIFICATIONS`) to `android/app/src/main/AndroidManifest.xml`
- [x] T003 Add placeholder strings for notification titles and default message to `lib/core/constants/app_strings.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T004 Implement `NotificationService` wrapper in `lib/core/services/notification_service.dart` for local notifications initialization and payload handling.
- [x] T005 Update `SettingsRepository` in `lib/data/repositories/settings_repository.dart` to support reading and saving the `active_profile` string.

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - App Branding & Identity (Priority: P1) 🎯 MVP

**Goal**: Update the app name to "Bunny Hoops" and set the new rabbit emoji icon.

**Independent Test**: Can be fully tested by installing the app and checking the home screen launcher.

### Implementation for User Story 1

- [x] T006 [P] [US1] Update the `android:label` to "Bunny Hoops" in `android/app/src/main/AndroidManifest.xml`
- [x] T007 [P] [US1] Update `CFBundleDisplayName` to "Bunny Hoops" in `ios/Runner/Info.plist`
- [x] T008 [US1] Generate and replace app icons with the stylized rabbit emoji (using `flutter_launcher_icons` or manual replacement in `android/app/src/main/res/` and `ios/Runner/Assets.xcassets/`)

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 3 - Custom Notification Messages (Priority: P1)

**Goal**: Allow users to type custom messages in a text field that are sent as notification bodies, defaulting to a specific message if empty.

**Independent Test**: Enter text, press record, verify notification body. Run widget, verify default message.

### Tests for User Story 3

- [x] T008a [P] [US3] Add unit tests for new message parameter and notification logic in `test/features/tracker/view_models/tracker_view_model_test.dart`.

### Implementation for User Story 3

- [x] T009 [US3] Add a styled `TextField` (pill-shaped, light pink background, **maxLength: 100**) to `lib/features/tracker/views/tracker_view.dart` under the record button.
- [x] T010 [US3] Update `recordNewThought` in `lib/features/tracker/view_models/tracker_view_model.dart` to accept an optional message parameter.
- [x] T011 [US3] Integrate `NotificationService.showNotification` inside `recordNewThought`, using the custom message or the default string if empty.
- [x] T012 [US3] Clear the `TextField` in `TrackerView` after a successful thought record.
- [x] T013 [US3] Update the background isolate callback for the Android Widget (likely in `main.dart` or `lib/core/services/home_widget_service.dart`) to always trigger the notification using the default message string.

**Checkpoint**: At this point, custom messages and widget overrides should work independently of dynamic titles.

---

## Phase 5: User Story 2 - Character Selection & Persistence (Priority: P2)

**Goal**: Select active profile (Dado or Coelho) using a toggle button and persist it in local storage.

**Independent Test**: Toggle the profile icon, close the app, reopen it, and verify the selection persists.

### Tests for User Story 2

- [x] T013a [P] [US2] Add unit tests for `ProfileViewModel` state changes and persistence in `test/features/tracker/view_models/profile_view_model_test.dart`.

### Implementation for User Story 2

- [x] T014 [P] [US2] Create a Riverpod `ProfileViewModel` (`_$ProfileNotifier`) in `lib/features/tracker/view_models/profile_view_model.dart` that reads/writes `active_profile` via `SettingsRepository`.
- [x] T015 [P] [US2] Create a `ProfileToggleButton` widget in `lib/core/widgets/profile_toggle_button.dart` that watches `ProfileViewModel` and switches icons.
- [x] T016 [US2] Integrate `ProfileToggleButton` into the AppBar of `lib/features/tracker/views/tracker_view.dart`.

**Checkpoint**: The UI for profile selection is fully functional and persists data correctly.

---

## Phase 6: User Story 4 - Dynamic Notification Titles (Priority: P2)

**Goal**: Notification title dynamically changes based on the active profile ("Amandinha..." or "Sarky...").

**Independent Test**: Set the profile, record a thought, and check the notification title.

### Implementation for User Story 4

- [x] T017 [US4] Update `TrackerViewModel` and the Widget Background task to read the current `active_profile` state before sending the notification.
- [x] T018 [US4] Apply the conditional logic: If profile is Dado, use title "Amandinha esta pensando em vc ❤️🐰🤘". If profile is Coelho, use "Sarky esta pensando em vc ❤️🦦🤘".

**Checkpoint**: All user stories should now be independently functional

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [x] T019 Run quickstart.md validation to ensure all scenarios pass (including killing the app and testing widget).
- [x] T020 Review code against Constitution Check (Clean Architecture, no hardcoded values in UI, Riverpod usage).

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - Note: User Story 3 (P1) and User Story 1 (P1) were moved up in priority over User Story 2 (P2) to ensure MVP functionality of tracking with notifications works first.
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Setup (Phase 1).
- **User Story 3 (P1)**: Can start after Foundational (Phase 2).
- **User Story 2 (P2)**: Can start after Foundational (Phase 2).
- **User Story 4 (P2)**: Depends on User Story 2 (Needs profile state) and User Story 3 (Needs notification logic).

### Parallel Opportunities

- T006, T007, and T008 (User Story 1) can run in parallel with Foundational tasks.
- User Story 2 UI/ViewModel tasks (T014, T015) can run in parallel with User Story 3 text field tasks.

---

## Implementation Strategy

### MVP First (User Story 1 & 3)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3 & 4 (App Branding and Custom Notifications). This guarantees the app can track thoughts and send basic notifications.
4. **STOP and VALIDATE**: Test User Story 3 independently.

### Incremental Delivery

1. Foundation ready.
2. App is branded and can send basic notifications with custom text (MVP).
3. Add Profile toggle state and persistence (US2).
4. Connect Profile state to the notification titles (US4) to finish the dynamic requirements.

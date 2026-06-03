# Implementation Plan: Dynamic Notifications & App Branding

**Branch**: `[005-dynamic-notifications]` | **Date**: 2026-05-09 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/005-dynamic-notifications/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

This feature adds rich local notifications triggered by tracking thoughts. It includes UI updates to select the active user profile (Dado vs Coelho) and input a custom message, utilizing `flutter_local_notifications` for the mechanism. It also rebrands the application formally to "Bunny Hoops" and introduces a new rabbit emoji app icon.

## Technical Context

**Language/Version**: Dart 3.x, Kotlin 1.9+  
**Primary Dependencies**: `flutter_local_notifications` (NEW), `hive_flutter`, `home_widget`  
**Storage**: Hive (`settings` box for profile persistence)  
**Testing**: Flutter test (ViewModels)  
**Target Platform**: Android (primary for now, via home widget integration)
**Project Type**: Mobile Application  
**Performance Goals**: N/A  
**Constraints**: Widget must trigger headless notification without needing the UI isolate to build.  
**Scale/Scope**: Local usage.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Design System**: The new UI elements (Text Field and Profile Toggle) must adhere to the design system (Bunny Core/Midnight Rose) using dynamic themes (`Theme.of(context)`).
- **Hard-coded values**: Strings for the notification titles and default descriptions must be added to `app_strings.dart` or handled via variables.
- **State Management**: Profile state must be managed via Riverpod (`Notifier`).
- **Persistence**: Profile state must be stored in the abstract repository or directly in the existing `settings` box via `SettingsRepository`.

## Project Structure

### Documentation (this feature)

```text
specs/005-dynamic-notifications/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── constants/
│   │   └── app_strings.dart (Update strings)
│   ├── services/
│   │   ├── notification_service.dart (NEW)
│   │   └── home_widget_service.dart (Update widget callback)
│   └── widgets/
│       └── profile_toggle_button.dart (NEW)
│
├── features/
│   └── tracker/
│       ├── view_models/
│       │   └── profile_view_model.dart (NEW)
│       └── views/
│           └── tracker_view.dart (Add toggle and text field)
│
├── data/
│   └── repositories/
│       └── settings_repository.dart (Update to handle active_profile)
```

**Structure Decision**: Kept within the established clean architecture boundaries, adding a new service for notifications and a new view model for the profile state.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | N/A |

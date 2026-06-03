# Implementation Plan: Android Home Widget

**Feature Branch**: `[004-android-widget]`  
**Created**: 2026-05-07  
**Status**: Draft

## 1. Technical Context

### Target Architecture
- **Layer**: View (Native Android UI) / ViewModel (Flutter Headless Task) / Data (SharedPreferences + Hive).
- **Core Pattern**: Event-driven native bridge. App state changes push to `SharedPreferences` via `home_widget`. Widget clicks trigger Dart headless tasks via `HomeWidgetProvider`.
- **Dependencies**: `home_widget` package.

### Constraints & Unknowns
- How to efficiently trigger the Hive database insertion from a Headless task without initializing the full Flutter UI? (Resolved in research: use `Hive.initFlutter()` and open the specific box).
- How to manage the midnight reset constraint strictly on the widget without waking up the app? (Resolved: The widget will store the date of the last update. The Android side will check if `last_updated_date < today_midnight`, and if so, visually show 0).

## 2. Constitution Check

- **Data Privacy**: No user identifiable data is stored on the home screen, only the integer count.
- **Tech Stack**: Uses standard Flutter packages and Android standard widgets (AppWidgetProvider).
- **Quality**: Avoids monolithic code. Isolates native code to its specific Android directories.
- **State Management**: Widget state is synchronized from `TrackerViewModel` and `HistoryViewModel` (when new thoughts are added) utilizing Riverpod side-effects.
- **Design Tokens**: Matches Bunny Core (Radius 28.0+, #FFB7CE).

## 3. Implementation Phases

### Phase 0: Research & Foundation
- Setup `home_widget` dependencies.
- Verify headless task setup in `main.dart`.

### Phase 1: Data Contract & Sync
- Setup `SharedPreferences` syncing within the existing Riverpod providers.

### Phase 2: Native Android UI
- Construct `widget_layout.xml` mirroring the `DailyCounterDisplay`.
- Register the `HomeWidgetProvider` in `AndroidManifest.xml`.

### Phase 3: Action Handlers
- Implement the "Click to Record" headless task to open Hive, insert a new `Thought`, update the count, and signal the widget to update.
- Ensure the main app state also reflects these changes if opened.

## 4. Verification Plan

- [ ] Add widget to Android Emulator home screen.
- [ ] Tap the widget, verify the number increments.
- [ ] Open the app, verify the main screen number matches the widget.
- [ ] Force-close the app, tap the widget, verify it still works.
- [ ] Simulate midnight transition and verify logic.

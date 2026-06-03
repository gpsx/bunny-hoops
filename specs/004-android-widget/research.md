# Research & Technical Decisions: Android Home Widget

**Feature**: Android Home Widget
**Date**: 2026-05-07

## 1. Native Communication Strategy
**Decision**: Use `home_widget` package.
**Rationale**: It is the industry standard for Flutter-to-Home-Widget communication. It abstracts the `MethodChannel` and `SharedPreferences` implementation details, providing a clean Dart API to push data and listen for background clicks.
**Alternatives considered**: 
- Writing custom `MethodChannels`. (Rejected: Too much boilerplate, reinvents the wheel).
- `flutter_widgetkit` (Rejected: Primarily focused on iOS).

## 2. Background Execution (Click to Record)
**Decision**: Use `HomeWidget.registerBackgroundCallback`.
**Rationale**: Allows executing a top-level Dart function when the widget is clicked, even if the Flutter Activity is not running. 
**Implementation Detail**: The background callback must call `Hive.initFlutter()` and open the `thoughts` box, calculate the new thought, save it, update `SharedPreferences`, and call `HomeWidget.updateWidget()`.

## 3. Midnight Reset Logic
**Decision**: Android Widget-side timestamp evaluation.
**Rationale**: Flutter background tasks cannot be easily scheduled to run exactly at midnight without introducing heavy dependencies like `workmanager`. Instead, the Flutter app will push the `last_update_timestamp` along with the `daily_count`. The Android XML layout or `AppWidgetProvider` (Kotlin/Java) will evaluate if the timestamp is from a previous day. If it is, the UI will forcefully render "0". When the user clicks to record, the Dart headless task will see it's a new day, set the count to 1, and update the timestamp.

## 4. UI Rendering
**Decision**: Native XML Layouts.
**Rationale**: `home_widget` requires native views. We will create a `layout/widget_layout.xml` mimicking the Bunny Core style using standard Android `LinearLayout`, `ImageView`, and `TextView`.

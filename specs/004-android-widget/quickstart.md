# Quickstart: Android Home Widget

**Feature**: Android Home Widget
**Date**: 2026-05-07

## Purpose
This document explains how to manually verify the Android Home Widget integration.

## Setup Instructions

1. **Install Dependencies**: Ensure `flutter pub get` has been run to fetch `home_widget`.
2. **Build the App**: Run the app on an Android Emulator or physical Android device. (Web and iOS are not supported for this specific Epic).
    ```bash
    flutter run -d android
    ```

## Verification Steps

### 1. Verify Data Sync
1. Open the app and record a thought.
2. Go to the Android home screen.
3. Long press on an empty space, select "Widgets".
4. Find "Bunny hoops" in the list and drag the widget to your home screen.
5. **Expected Outcome**: The widget should immediately display the same number as the daily counter inside the app.

### 2. Verify Background Execution (Click to Record)
1. Close the app completely (swipe it away from the recent apps list).
2. Tap the heart/record button on the Android widget.
3. **Expected Outcome**: The number on the widget should increment by 1 after a brief moment.
4. Open the app again.
5. **Expected Outcome**: The daily counter inside the app should match the widget's new value, confirming that the background task successfully updated the persistent Hive database.

### 3. Verify Midnight Reset
1. Go to your Android device settings.
2. Change the system date to tomorrow.
3. Lock and unlock the screen to force a widget refresh, or tap the widget.
4. **Expected Outcome**: The widget counter should reset to 0 (or 1 if you tapped it).

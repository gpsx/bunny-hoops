# Quickstart: Tracker Home Screen

## Verification Steps

1. **Build Runner**: Run the code generation to create Hive and Riverpod adapters.
   ```bash
   /Users/cit/Documents/flutter/bin/flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Launch App**: Start the app on your preferred device/browser.
   ```bash
   /Users/cit/Documents/flutter/bin/flutter run -d chrome
   ```

3. **Record Thought**:
   - Locate the large pink circular button with the bunny icon.
   - Tap the button.
   - Verify that the "Daily Total" count increments.
   - Verify that the "Last entry" card updates to the current time.

4. **Persistence Test**:
   - Stop the app.
   - Restart the app.
   - Verify that the daily count and streak are still visible and accurate.

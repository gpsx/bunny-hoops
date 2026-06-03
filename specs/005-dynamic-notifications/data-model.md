# Data Model: Dynamic Notifications

## Entities

### `ProfileSettings`
This is not a complex Hive Object, but rather a simple key-value pair stored in the `settings` Hive box.

- **Storage Method**: Hive (Box name: `settings`)
- **Key**: `active_profile`
- **Type**: `String`
- **Values**:
  - `'dado'` (Represents the Dado profile)
  - `'coelho'` (Represents the Coelho profile)
- **Default**: `'dado'`

## State Transitions
1. User taps the profile toggle button in `TrackerView`.
2. The `ProfileNotifier` updates the state from `'dado'` to `'coelho'` (or vice-versa).
3. The new value is saved to the `settings` Hive box.
4. UI reacts to the state change, switching the displayed icon.
5. Notification logic uses the current state when a thought is registered to determine the title string.

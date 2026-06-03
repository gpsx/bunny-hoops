# Data Model: Android Home Widget

**Feature**: Android Home Widget
**Date**: 2026-05-07

## Transient State (SharedPreferences)

The widget relies on a simple key-value store shared between the Android native environment and the Flutter environment via the `home_widget` package.

### `WidgetData` (Virtual Entity)

| Key | Type | Description | Default |
|-----|------|-------------|---------|
| `daily_count` | `int` | The number of thoughts recorded today. | `0` |
| `last_update_timestamp` | `int` | Epoch timestamp (milliseconds) of the last update. | `0` |

### Interaction with Persistent State

- When a new `Thought` is created in Hive (via the app OR the headless task), the system calculates the current day's total.
- The `daily_count` and `last_update_timestamp` are immediately overwritten in the `SharedPreferences` to ensure the Android widget has the latest snapshot.
- The widget itself DOES NOT read from Hive. It only reads from `SharedPreferences`.

## Contracts

No public APIs or external HTTP contracts are introduced in this Epic.
The only contract is the Native Channel structure established by `home_widget`.

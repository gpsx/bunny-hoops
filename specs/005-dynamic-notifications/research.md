# Research: Dynamic Notifications

## Technical Approach for Notifications

**Decision**: Use `flutter_local_notifications` package for local notifications.
**Rationale**: It's the standard, most reliable package for cross-platform local notifications in Flutter. It supports custom payloads, which allows us to pass specific text and titles. Since we don't need push notifications from a server, this avoids the complexity of Firebase Cloud Messaging.

## Approach for Profile Persistence

**Decision**: Use an existing Hive box (e.g., the `settings` box created previously) to store the `active_profile` string.
**Rationale**: Avoids initializing a new storage mechanism when Hive is already set up and used extensively.

## Android Widget Compatibility

**Decision**: The Android Widget background service will ignore the UI's `TextController` (which it can't access anyway since it runs headlessly) and simply use the default message when constructing the notification.
**Rationale**: Follows the specification while dealing with the technical limitation that UI state isn't directly available to background isolates unless specifically synced.

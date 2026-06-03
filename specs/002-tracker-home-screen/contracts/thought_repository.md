# Contract: ThoughtRepository

## Overview
Defines the interface for persisting and retrieving thought entries.

## Interface Definition

```dart
abstract class ThoughtRepository {
  /// Saves a new thought to local storage.
  Future<void> saveThought(Thought thought);

  /// Retrieves all thoughts recorded on a specific day.
  List<Thought> getThoughtsByDay(DateTime date);

  /// Calculates the current daily streak of the user.
  int calculateStreak();

  /// Returns the most recent thought recorded today.
  Thought? getLastEntryToday();
}
```

## Implementation Details
- Implementation will use `Hive` as the storage engine.
- Repository will be provided via a Riverpod `Provider`.

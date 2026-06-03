# Quickstart: History View

Since this is an internal application feature, this quickstart focuses on how developers can test and interact with the History View locally.

## Running the App

1. Start the Flutter application:
   ```bash
   flutter run -d chrome
   ```
   *(Or target an iOS/Android emulator)*

2. By default, the app opens on the `TrackerView`.
3. To test the History View, tap the "Clock" icon on the bottom navigation bar.

## Simulating Data for History View

To fully test the chronological grouping without waiting for days to pass, you can temporarily inject fake data into the Hive box.

Add this snippet temporarily to a button or at startup:

```dart
final repo = ref.read(thoughtRepositoryProvider);
final now = DateTime.now();

await repo.saveThought(Thought(id: '1', content: 't1', createdAt: now));
await repo.saveThought(Thought(id: '2', content: 't2', createdAt: now));
await repo.saveThought(Thought(id: '3', content: 'y1', createdAt: now.subtract(const Duration(days: 1))));
await repo.saveThought(Thought(id: '4', content: 'o1', createdAt: now.subtract(const Duration(days: 5))));
```

Navigate to the History screen and verify:
- "Hoje" shows 2
- "Ontem" shows 1
- "[Date]" shows 1
- Total is 4.

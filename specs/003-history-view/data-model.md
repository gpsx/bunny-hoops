# Data Model: History View

The History View heavily relies on the existing `Thought` model created in Epic 02. No new persistent data models are required for this feature.

## Existing Entity: `Thought`

Located in `lib/features/tracker/models/thought.dart`.

| Field | Type | Description |
|-------|------|-------------|
| `id` | `String` | Unique identifier. |
| `content` | `String` | The recorded thought. |
| `createdAt` | `DateTime` | Timestamp of creation. Used for chronological sorting and grouping. |
| `tags` | `List<String>` | Unused in this view. |

## View State Models

To efficiently render the UI, the `HistoryViewModel` will transform the raw `List<Thought>` into view-specific models.

### `HistoryState`

The state object exposed by the `HistoryViewModel`.

| Field | Type | Description |
|-------|------|-------------|
| `totalThoughts` | `int` | The absolute total count of all recorded thoughts. |
| `groupedHistory` | `List<DayAggregate>` | A chronological list of daily aggregations. |

### `DayAggregate`

A transient model used only in the UI layer to represent a grouped row in the history list.

| Field | Type | Description |
|-------|------|-------------|
| `dateLabel` | `String` | Pre-formatted string for display (e.g., "Hoje", "Ontem", "18 de Out"). |
| `count` | `int` | Number of thoughts recorded on that specific date. |

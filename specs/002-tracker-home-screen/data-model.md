# Data Model: Tracker Home Screen

## Entities

### Thought
Represents a single entry of a "lovely thought".

- **Type**: HiveObject
- **Adapter ID**: 0
- **Fields**:
  - `createdAt` (DateTime): The timestamp when the thought was recorded.

## Relationships
- Thoughts are stored in a single Hive box named `thoughts_box`.
- The repository filters this list to provide stats (daily count, streak).

## Persistence Layer
- **Box Name**: `thoughts`
- **Adapter**: `ThoughtAdapter` (Generated)

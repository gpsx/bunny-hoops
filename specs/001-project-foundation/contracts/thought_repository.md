# Contract: ThoughtRepository

## Interface Definition

The `ThoughtRepository` is responsible for persisting and retrieving thoughts.

### Methods

#### `Future<List<Thought>> getThoughts()`
- **Description**: Retrieves all stored thoughts.
- **Returns**: A list of `Thought` objects.

#### `Future<void> saveThought(Thought thought)`
- **Description**: Persists a new thought.
- **Parameters**: `thought` (The thought entity to save).

#### `Future<void> deleteThought(String id)`
- **Description**: Removes a thought by ID.
- **Parameters**: `id` (The unique identifier).

## Implementation Rules
- Must use Hive for the concrete implementation in this phase.
- Must be abstracted to allow easy switching to Isar or other engines later.

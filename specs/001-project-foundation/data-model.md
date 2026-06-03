# Data Model: Bunny hoops

## Entities

### Thought (Ponto de Pensamento)
Represents a captured thought or feeling.

| Field | Type | Description | Validation |
|-------|------|-------------|------------|
| id | String | Unique identifier (UUID) | Not null |
| content | String | The text of the thought | Not empty |
| createdAt | DateTime | When the thought was recorded | Not null |
| tags | List<String> | Categories for the thought | Optional |

## Relationships
- A `Thought` is an independent entry in the local database.
- Future: `User` has many `Thoughts`.

## Persistence (Hive)
- **Box Name**: `thoughts_box`
- **Adapter**: `ThoughtAdapter` (generated via `hive_generator`)

# Feature Specification: History View

**Feature Branch**: `[003-history-view]`  
**Created**: 2026-05-07  
**Status**: Draft  
**Input**: User description: "utilize a task-003.md e o constitution.md e a imagem como base de design"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View Total Thoughts (Priority: P1)

Users want to see the total number of thoughts they have recorded since they started using the app, to feel a sense of accomplishment.

**Why this priority**: Seeing the total count provides immediate gratification and reinforces the habit of using the tracker. It is the most prominent element in the design.

**Independent Test**: Can be fully tested by verifying that the large pink number in the header matches the total number of entries in the local database.

**Acceptance Scenarios**:

1. **Given** the user has recorded 42 thoughts historically, **When** they navigate to the History tab, **Then** they see a card displaying "TOTAL DE PENSAMENTOS" with the number "42" and a bunny icon.
2. **Given** the user records a new thought in the Tracker tab, **When** they switch to the History tab, **Then** the total count instantly updates to reflect the new entry.

---

### User Story 2 - View Chronological History (Priority: P1)

Users want to see a list of their past activity grouped by day, so they can review their daily consistency over time.

**Why this priority**: The core purpose of the history screen is to display past records. Grouping by day makes the list scannable and easy to understand.

**Independent Test**: Can be fully tested by adding records on different dates and verifying they are grouped correctly and sorted from newest to oldest.

**Acceptance Scenarios**:

1. **Given** the user has 5 records today and 3 yesterday, **When** they view the history list, **Then** they see a card for "Hoje" with "5" and a card for "Ontem" with "3".
2. **Given** the user has records from older dates, **When** they scroll the list, **Then** older dates are formatted as "[Day] de [Month]" (e.g., "18 de Out") and displayed in descending chronological order.

---

### Edge Cases

- What happens when the user has never recorded a thought?
  - The total counter displays "0" and the history list shows a friendly empty state message encouraging them to record their first thought.
- How does system handle a very large history list (e.g., years of data)?
  - The list uses a standard recycling view (e.g., `ListView.builder`) to ensure smooth scrolling and low memory consumption regardless of the number of items.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST calculate and display the sum of all recorded thoughts since the first use.
- **FR-002**: System MUST aggregate historical records by unique dates (ignoring time of day).
- **FR-003**: System MUST display aggregated records in a descending chronological list.
- **FR-004**: System MUST format dates as "Hoje", "Ontem", or "[Day] de [Month]" (e.g., "18 de Out") for older dates.
- **FR-005**: System MUST automatically update the history state when new records are added from the Tracker screen without requiring an app restart.
- **FR-006**: System MUST allow navigation between the Tracker and History screens via the bottom navigation bar.

### Key Entities

- **Thought**: Represents a recorded thought. Key attributes used here are the creation timestamp (`createdAt`) to determine grouping and ordering.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: History list loads and renders in under 200 milliseconds, even with 10,000+ historical records.
- **SC-002**: The total thoughts counter is 100% accurate based on the underlying database.
- **SC-003**: 100% adherence to the "Bunny Core Romantic" design tokens (Colors, Typography, Border Radius) as specified in the UI reference.

## Assumptions

- The app is single-user and does not require cloud synchronization for this iteration.
- The `Thought` model and the local persistence layer (Hive) created in Epic 02 are fully functional and available for querying.
- The default language for date formatting is Portuguese (pt-BR), as implied by the UI mockups ("Hoje", "Ontem", "18 de Out").

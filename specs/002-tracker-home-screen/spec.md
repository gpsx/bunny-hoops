# Feature Specification: Tracker Home Screen

**Feature Branch**: `002-tracker-home-screen`  
**Created**: 2026-05-07  
**Status**: Draft  
**Input**: User description based on `task-002.md` for developing the main Tracker screen.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Record a Thought
As a user, I want to tap a central bunny button so that I can easily record a new "lovely thought" and see my daily count increase.

**Why this priority**: Core value proposition of the app.
**Independent Test**: Tapping the bunny button increments the displayed daily total and updates the "Last entry" time.

### User Story 2 - View Progress Metrics
As a user, I want to see my current streak and the total thoughts I've recorded today so that I stay motivated to continue my monitoring.

**Why this priority**: Encourages engagement and provides immediate feedback.
**Independent Test**: The daily total and streak cards display accurate data fetched from the local database.

---

### Acceptance Scenarios

1. **Given** I am on the Tracker screen, **When** I tap the central Bunny button, **Then** the daily total count increases by 1 and the "Last entry" card updates to the current time.
2. **Given** I have recorded thoughts on consecutive days, **When** I open the app, **Then** the "Streak" card displays the correct number of consecutive days.
3. **Given** I am on the Tracker screen, **When** I tap the "History" icon in the bottom navigation bar, **Then** the app navigates to the History screen.

---

### Edge Cases

- **Multiple rapid taps**: The system should handle rapid successive taps on the record button without creating duplicate entries or corrupting the count (debounce or sequential processing).
- **Date Change**: When the day changes while the app is open, the daily total should reset to 0 (or refresh to show the new day's total).
- **Empty State**: If no thoughts have been recorded yet, the "Last entry" should show a placeholder like "--:--".

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display a central circular button with a bunny icon and the label "Record Thought".
- **FR-002**: System MUST increment the daily thought counter upon tapping the record button.
- **FR-003**: System MUST persist each recorded thought with a timestamp using Hive.
- **FR-004**: System MUST calculate and display the current daily total of thoughts.
- **FR-005**: System MUST calculate and display the current usage streak (consecutive days with at least one entry).
- **FR-006**: System MUST display the time (HH:mm) of the most recent entry for the current day.
- **FR-007**: System MUST provide a custom Bottom Navigation Bar to toggle between 'Tracker' and 'History' views.
- **FR-008**: UI components MUST adhere to the "Bunny Core Romantic" design system (colors, fonts, 28.0/50.0 border radius).

### Key Entities *(include if feature involves data)*

- **Thought**: Represents a recorded thought entry (Attributes: `DateTime createdAt`).
- **TrackerState**: Represents the UI state (Attributes: `count`, `streak`, `lastEntry`).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Thought recording happens with no perceptible UI lag (< 100ms for counter update).
- **SC-002**: Data persists correctly after app restart (Daily total and streak remain accurate).
- **SC-003**: 100% of UI elements on the Tracker screen match the "Bunny Core" design specs (Radius 28.0 for cards, 50.0 for buttons).
- **SC-004**: Navigation between screens is smooth and maintains state.

## Assumptions

- Hive is properly initialized from the project foundation phase.
- The "History" screen exists or will be implemented in a subsequent phase (placeholder navigation is acceptable for now).
- Local time is used for all timestamp and day-boundary calculations.

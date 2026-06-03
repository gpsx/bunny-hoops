# Feature Specification: Dynamic Notifications & App Branding

**Feature Branch**: `[005-dynamic-notifications]`  
**Created**: 2026-05-09
**Status**: Draft  
**Input**: User description: "implemente esse darkmode, tem algumas diretivas de design tb para adicionarmos esse segundo é a nossa estetica bunny core, para a implementacao do dark mode, coloca um botaozinho no lado superior esquerdo com a lua e o sol q alternam no clique tbm quero q isso seja salvo no banco de dados para consulta quando o app abrir o padrao vai ser o tema claro. Use task-005.md e constitution.md e a imagem de referencia do campo de texto"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - App Branding & Identity (Priority: P1)

As a user, I want the app to have its proper name ("Bunny Hoops") and a recognizable rabbit emoji icon so that it feels like a personalized and complete application on my home screen.

**Why this priority**: Branding establishes the app's identity and is the first thing the user sees on their device.

**Independent Test**: Can be fully tested by installing the app and checking the home screen launcher for the correct name and icon.

**Acceptance Scenarios**:

1. **Given** the app is installed, **When** I look at the device launcher, **Then** the app name displays exactly as "Bunny Hoops".
2. **Given** the app is installed, **When** I look at the device launcher, **Then** the app icon is the configured stylized rabbit emoji.

---

### User Story 2 - Character Selection & Persistence (Priority: P2)

As a user, I want to select my active profile (Dado or Coelho) using a toggle button so that the app knows who is currently registering thoughts and can format notifications correctly.

**Why this priority**: Profile selection is a prerequisite for the dynamic notification logic.

**Independent Test**: Can be fully tested by toggling the profile icon, closing the app, reopening it, and verifying the selection persists.

**Acceptance Scenarios**:

1. **Given** I am on the Tracker view, **When** I tap the toggle button in the top right corner, **Then** the icon switches between Dado and Coelho.
2. **Given** I have selected a specific profile, **When** I close and reopen the app, **Then** the previously selected profile is still active.

---

### User Story 3 - Custom Notification Messages (Priority: P1)

As a user, I want to type a custom message in a text field before recording a thought, so that the resulting notification contains my specific message. If I don't type anything, a sweet default message should be used.

**Why this priority**: This is the core functionality of the epic, adding rich interaction to the habit tracker.

**Independent Test**: Can be fully tested by entering text, pressing the record button, and verifying the received local notification's body content.

**Acceptance Scenarios**:

1. **Given** the message text field is empty, **When** I record a thought via the main app button, **Then** the notification body displays the default text ("Oi meu amor tava pensando em vc agorinha, te amo mt").
2. **Given** I have typed "Bom dia!" in the message text field, **When** I record a thought via the main app button, **Then** the notification body displays "Bom dia!" and the text field clears.
3. **Given** I use the Android Home Screen Widget to record a thought, **When** the widget triggers the background action, **Then** the notification body displays the default text, ignoring any text that might be in the app's UI.

---

### User Story 4 - Dynamic Notification Titles (Priority: P2)

As a user, I want the notification title to dynamically change based on the active profile so that it feels like the notification is coming from my partner.

**Why this priority**: Personalizes the experience and makes the notifications emotionally resonant.

**Independent Test**: Can be fully tested by setting the profile, recording a thought, and checking the notification title.

**Acceptance Scenarios**:

1. **Given** the active profile is "Dado", **When** a thought is recorded, **Then** the notification title is "Amandinha esta pensando em vc ❤️🐰🤘".
2. **Given** the active profile is "Coelho", **When** a thought is recorded, **Then** the notification title is "Sarky esta pensando em vc ❤️🦦🤘".

### Edge Cases

- What happens when the app is completely closed (killed) and a thought is recorded via the widget? The background isolate must correctly initialize the notification service and send the default message.
- How does the system handle extremely long custom messages in the text field? The text field should allow multiline input but the notification will naturally truncate it according to OS constraints.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST update the application label to "Bunny Hoops".
- **FR-002**: System MUST update the application icon to the provided rabbit emoji design in all required densities.
- **FR-003**: Users MUST be able to toggle their active profile (Dado or Coelho) via a button in the top right of the Tracker view.
- **FR-004**: System MUST persist the active profile selection in local storage (Hive).
- **FR-005**: Users MUST be provided with a styled text input field below the record button to enter a custom message.
- **FR-006**: System MUST clear the text input field after a thought is successfully recorded via the main UI.
- **FR-007**: System MUST trigger a local notification when a thought is recorded.
- **FR-008**: System MUST set the notification title to "Amandinha esta pensando em vc ❤️🐰🤘" if the active profile is Dado.
- **FR-009**: System MUST set the notification title to "Sarky esta pensando em vc ❤️🦦🤘" if the active profile is Coelho.
- **FR-010**: System MUST set the notification body to the content of the text input field if it is not empty.
- **FR-011**: System MUST set the notification body to the default message ("Oi meu amor tava pensando em vc agorinha, te amo mt") if the text input field is empty.
- **FR-012**: System MUST always set the notification body to the default message when a thought is recorded via the Android Home Screen Widget.

### Key Entities

- **Profile Settings**: Represents the user's current identity selection (Dado or Coelho), persisted locally.
- **Notification Payload**: The constructed data (title and body) passed to the OS notification manager based on current state and input.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of recorded thoughts from the main UI with a custom message trigger a notification containing that exact message.
- **SC-002**: 100% of recorded thoughts from the main UI without a custom message trigger a notification containing the default message.
- **SC-003**: 100% of recorded thoughts from the Android Widget trigger a notification containing the default message.
- **SC-004**: Profile toggle state survives app restarts reliably.
- **SC-005**: The app launcher displays "Bunny Hoops" and the new icon.

## Assumptions

- The `flutter_local_notifications` package will be used for triggering local notifications.
- The user has already granted or will grant permission to receive notifications upon app install or first use (Android 13+ requires runtime permission).
- The text field UI will strictly follow the provided reference image (pill-shaped, slight pink background, specific placeholder text).

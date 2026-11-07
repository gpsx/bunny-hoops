# ADR 0006: Centralize message state, profile identity, and widget synchronization

- Status: Proposed
- Date: 2026-11-06

## Context

The application currently treats an active profile as a string (`dado` or
`coelho`) in several independent places. Each place interprets it differently:
the profile selector, notification title, FCM topic, home-widget callback, and
tracker state can disagree.

This has produced visible defects:

- A thought sent as lontra is labeled as if it were sent by Amandinha.
- The profile icon previously represented the opposite of the stored profile.
- Tracker, history, gallery, notifications, and the home widget do not receive
  updates through one shared state flow.
- The widget count can move backwards because it counts a different set of
  thoughts than the tracker.
- User-visible text is split between `AppStrings` and hard-coded literals.
- `TrackerViewModel`, `NotificationService`, and `HomeWidgetService` combine
  presentation, persistence, notification delivery, and synchronization
  responsibilities.

The app must remain local-first while these problems are corrected. Existing
Hive history must not be deleted or rewritten incompatibly.

## Decision

### 1. Make profile identity explicit

Replace string comparisons with a `Profile` value type or enum. `lontra` is
the canonical identity everywhere in new code; the legacy term `dado` must not
be introduced in identifiers, user-visible text, storage values, or FCM topics.
The profile owns the display name, icon, sender identity, and FCM sender topic:

| Profile | Person | Icon | Sender topic | Recipient subscribes |
| --- | --- | --- | --- | --- |
| `lontra` | Sarky / lontra | 🦦 | `lontra_thoughts` | coelho |
| `coelho` | Amandinha / coelho | 🐰 | `coelho_thoughts` | lontra |

The active profile represents the **sender**, not the recipient nor the next
profile selected by the toggle. A single notification-payload factory derives
the title, body, topic, and image metadata from that profile. Therefore, a
thought sent as lontra is labeled as sent by Sarky and is delivered to the
coelho subscriber.

Existing Hive values of `dado` must be migrated atomically to `lontra` before
the old branch is removed. During a short notification rollout, lontra devices
subscribe to both `dado_thoughts` and `lontra_thoughts`, while new sends use
`lontra_thoughts`. The legacy subscription is removed only after all supported
app versions have migrated. Parsing must reject unknown values rather than
silently choosing a profile.

### 2. Establish one thought mutation boundary

Create a repository/use-case boundary for:

- recording a local sent thought;
- recording an incoming thought;
- reading the current daily sent count;
- observing thought changes; and
- synchronizing the Android home-widget projection.

Views, FCM handlers, and home-widget callbacks must not write directly to Hive.
They invoke the same command/use case instead. The repository retains Hive as
the local store and exposes typed results/errors. This separates persistence
from delivery and presentation in line with the Single Responsibility and
Dependency Inversion principles.

The sender's local thought persists before a notification is dispatched. A
remote-send failure is surfaced as a retryable delivery failure; it must not
show a local notification on the sender's device, because that impersonates a
received message.

### 3. Use a reactive source of truth

The repository observes the Hive thought box and publishes one state stream.
Tracker, history, day detail, and gallery consume that stream or providers
derived from it. Refreshes are serialized so a slower request cannot overwrite
a newer state.

Each incoming FCM message carries a stable thought identifier when durable
sync is introduced. Until then, received-message writes must at least be
deduplicated at the repository boundary, rather than independently by
foreground and background handlers.

### 4. Define the widget contract

The tracker and Android home widget display the same value: the number of
**sent thoughts whose local date is today**. Received thoughts do not change
that count.

The count is calculated in one repository query with an injected clock and a
single local-date boundary rule. Every thought mutation then triggers one
atomic widget update containing the count and update timestamp. The widget
must render the supplied value; it must not independently recompute from a
different Hive query. This prevents the apparent forward/backward updates.

### 5. Centralize user-visible strings

Move every Dart user-visible literal to `lib/core/constants/app_strings.dart`
or feature-specific string classes if that file becomes too broad. Strings
include titles, errors, profile descriptions, widget text, button labels,
empty states, and accessibility labels.

Native Android widget resources remain in Android resource files. The next
internationalization effort may replace these constants with Flutter
localizations; this ADR does not require adding a localization framework now.

### 6. Keep adapters small and testable

The following components are adapters around the use cases, not alternative
business-logic paths:

- `NotificationService`: FCM permissions, token/topic registration, and
  display only.
- notification payload factory: maps a sender profile and thought to FCM data.
- `HomeWidgetService`: persists the already-calculated widget projection and
  requests an Android redraw.
- `TrackerViewModel`: view state and user interaction only.

Dependencies are injected through interfaces/providers. Platform details and
Firebase calls remain behind adapters, allowing the domain and repository
logic to be tested without Android or Firebase.

### 7. Preserve history across updates and devices

The application must preserve local history through every compatible app
update. Hive remains the local-first cache, but it is not the only copy of
important data:

- Updates must install in place and must never uninstall the app, clear app
  data, change the application identifier, or change signing identity.
- Before any Hive schema migration, the app creates a versioned backup and
  performs the migration atomically. If migration fails, it restores the prior
  local data and reports the failure.
- The app provides a user-initiated export of the thought history to a
  user-selected location. This export is a portable structured format, not a
  raw Hive file, so it remains usable after future schema changes.
- The app displays the most recent successful local backup and cloud-sync
  timestamps. A release must not claim migration success until records and
  images have been verified.

Firebase is the durable off-device copy for this personal two-person project:

- Firebase Authentication identifies the two people with separate accounts.
- Cloud Firestore stores the shared thought documents and sync metadata.
- Firebase Storage stores image files; Firestore stores their paths and
  metadata.
- Each account may access only one shared couple document and its child
  thoughts/images. Firestore and Storage rules enforce this allowlist.
- Hive keeps the offline cache and an outbox; Firestore is the recoverable
  cross-device history after device loss, uninstall, or replacement.
- FCM remains notification delivery only. It is not a backup or history
  mechanism.

For an app used only by two people, this provides simple recovery without
exposing history publicly or requiring a general multi-tenant product model.

## Consequences

### Positive

- Sender name, icon, topic, and recipient have one documented contract.
- Every surface observes the same data changes.
- Widget count becomes deterministic and cannot include received thoughts by
  accident.
- Notification failures are visible and diagnosable without misleading local
  alerts.
- Strings are auditable and ready for later localization.
- Smaller responsibilities reduce duplicate update code and make tests focused.
- Local updates, device replacement, and uninstall no longer have a single
  point of failure once verified cloud sync and export are available.

### Costs and risks

- The refactor touches persistence, background execution, and UI providers;
  it must be phased to avoid data loss.
- FCM topic delivery is not a history store and may still be delayed. Durable
  cross-device history requires the separate cloud-sync ADR work.
- Changing internal profile types needs a backward-compatible Hive migration.
- Cloud history requires Firebase Authentication, Firestore/Storage rules, and
  an initial backfill from the chosen canonical device.

## Implementation plan

1. Add the typed profile model and payload factory; migrate `dado` values and
   topics to `lontra`; correct the sender-title mapping; and add tests for
   both profile directions and the legacy migration.
2. Move remaining Dart UI literals into the appropriate string classes without
   changing displayed copy unintentionally.
3. Extract repository commands and daily-count query while retaining the
   existing Hive schema.
4. Make all feature providers derive from the repository change stream and add
   concurrency tests for rapid writes.
5. Route FCM foreground/background and widget writes through the commands,
   with duplicate-message protection.
6. Replace the widget's independent count with the shared projection and test
   sent, received, midnight, and rapid-tap scenarios.
7. Add a versioned local export/restore flow and backup-status UI; exercise an
   upgrade and failed-migration recovery without deleting a Hive box.
8. Add two-account Firebase Authentication, a couple membership document,
   Firestore/Storage rules, an offline outbox, and verified initial backfill
   from one canonical device.
9. Add delivery status/retry UI. Keep FCM separate from the durable Firestore
   history sync.

## Validation

Before each phase is released, verify:

- lontra -> coelho shows Sarky as sender and coelho -> lontra shows Amandinha;
- both foreground and background receivers get the same persisted result;
- tracker, history, day detail, gallery, and widget converge after a sent or
  received thought;
- widget count changes only for sent thoughts from the current local day;
- rapid consecutive updates cannot roll a displayed value backwards;
- existing Hive boxes open successfully and retain all legacy thoughts.
- an in-place update retains local data, a failed migration restores it, and
  exported history can be restored on a clean device;
- a signed-in member can recover history and images from Firestore after
  reinstall, while a non-member cannot read either.

## Alternatives considered

### Keep profile strings and repair each conditional

Rejected. It repeats the same mapping knowledge throughout the app and is how
the current title/icon/topic inconsistencies arose.

### Make the home widget calculate its own count

Rejected. It duplicates query and date-boundary logic in a separate execution
path, creating the current drift.

### Use FCM notifications as the message history

Rejected. FCM is delivery-oriented, can be delayed or dropped, and cannot
recover history after reinstall. Hive remains local-first and future cloud
sync is the durable source.

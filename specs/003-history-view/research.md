# Phase 0: Research & Technical Decisions - History View

## 1. Date Aggregation Algorithm

**Decision**: The aggregation of thoughts by date will occur in the ViewModel (`HistoryViewModel`) rather than the Repository. The Repository will continue to return a flat list of `Thought` objects.

**Rationale**: 
- **Separation of Concerns**: The database (Hive) is a simple key-value store. Filtering and grouping are presentation/business logic concerns, not data layer concerns.
- **Performance**: Hive is extremely fast at retrieving all items. Grouping them in memory in Dart (using `fold` or a simple loop) over a few thousand items takes less than 10ms, which is well within the 200ms budget.
- **Reusability**: Keeping the `ThoughtRepository` simple (`getThoughts()`) allows other parts of the app to fetch the raw list if needed.

**Alternatives Considered**:
- Grouping inside the Repository: Rejected because it tightly couples the data layer to the specific needs of the History View.

## 2. Date Formatting

**Decision**: Use Dart's built-in `DateTime` operations to check for "Hoje" (Today) and "Ontem" (Yesterday), and standard string interpolation or `intl` package (if already available) for "[Day] de [Month]".

**Rationale**:
- Native `DateTime` comparisons (matching year, month, day) are sufficient for "Hoje" and "Ontem".
- Month translation can be done with a simple switch/map if the `intl` package is not desired for such a small scope, minimizing dependencies.

## 3. List Performance

**Decision**: Use `ListView.builder` for the history list.

**Rationale**:
- `ListView.builder` creates items lazily, meaning it only builds the widgets for the items currently visible on the screen. This guarantees 60fps scrolling even with 10,000+ grouped historical records.

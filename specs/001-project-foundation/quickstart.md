# Quickstart: Project Foundation

## Prerequisites
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code with Flutter extension
- An emulator or physical device

## Setup Steps

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Generate Code**:
   (Required for Riverpod and Hive adapters)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Run the App**:
   ```bash
   flutter run
   ```

## Verification
- App should launch showing "Bunny hoops Foundation Ready".
- No lint errors in `lib/` or `test/`.
- Folder structure matches the constitution.

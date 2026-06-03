# Quickstart: Testing Dynamic Notifications

## Setup Verification

1. Install the app on an emulator or physical device.
2. Check the Home Screen / App Launcher.
3. Verify that the app is named **Bunny Hoops**.
4. Verify that the app icon displays the new stylized rabbit emoji.

## Testing Profile Selection

1. Open the app and navigate to the **Tracker** tab.
2. Observe the profile toggle button in the top right corner.
3. Tap the toggle button to switch between the **Dado** and **Coelho** icons.
4. Kill the app completely (swipe away from recent apps).
5. Open the app again.
6. Verify that the last selected profile icon is still active.

## Testing Dynamic Notifications

1. With the **Dado** profile active:
   - Do NOT enter any text in the message field.
   - Tap the large record button.
   - Verify that you receive a local notification titled "Amandinha esta pensando em vc ❤️🐰🤘".
   - Verify the notification body is "Oi meu amor tava pensando em vc agorinha, te amo mt".
   
2. With the **Coelho** profile active:
   - Type "Estou morrendo de saudades!" in the message field.
   - Tap the large record button.
   - Verify that you receive a local notification titled "Sarky esta pensando em vc ❤️🦦🤘".
   - Verify the notification body is "Estou morrendo de saudades!".
   - Verify the text field is cleared after the action completes.

## Testing Widget Override

1. Add the **Bunny Hoops** widget to your Android Home Screen.
2. Tap the heart icon on the widget to register a thought.
3. Wait a few seconds for the background task to complete.
4. Verify you receive a notification with the correct title (based on the saved profile) and the default body ("Oi meu amor tava pensando em vc agorinha, te amo mt"), regardless of what was last typed in the app's text field.

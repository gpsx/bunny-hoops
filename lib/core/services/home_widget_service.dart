import 'package:home_widget/home_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../features/tracker/models/thought.dart';
import '../constants/app_strings.dart';
import '../models/profile.dart';
import '../notifications/thought_notification_payload.dart';
import '../../data/repositories/thought_repository_impl.dart';

class HomeWidgetService {
  static const String _appGroupId =
      'group.bunny_hoops'; // Required for iOS, but we use it globally.
  static const String _androidName = 'WidgetProvider';

  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(_appGroupId);
  }

  static Future<void> updateData(int dailyCount) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await HomeWidget.saveWidgetData<int>('daily_count', dailyCount);
    await HomeWidget.saveWidgetData<int>('last_update_timestamp', now);
    await HomeWidget.updateWidget(
      androidName: _androidName,
    );
  }
}

@pragma('vm:entry-point')
Future<void> interactiveCallback(Uri? uri) async {
  if (uri?.host == 'record') {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ThoughtAdapter());
    }

    // Ensure the box is opened
    final box = await Hive.openBox<Thought>('thoughts');

    final newThought = Thought(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: AppStrings.defaultThought,
      createdAt: DateTime.now(),
      isSent: true,
    );

    final thoughtRepository = ThoughtRepositoryImpl(box);
    await thoughtRepository.saveThought(newThought);

    final now = DateTime.now();
    final todayCount = await thoughtRepository.getSentThoughtCountForDay(now);

    // Save to SharedPreferences for the widget to see
    await HomeWidget.saveWidgetData<int>('daily_count', todayCount);
    await HomeWidget.saveWidgetData<int>(
        'last_update_timestamp', now.millisecondsSinceEpoch);

    // Trigger widget update
    await HomeWidget.updateWidget(
      androidName: HomeWidgetService._androidName,
    );

    // Dynamic Notifications logic for widget
    final settingsBox = await Hive.openBox('settings');
    final activeProfile =
        Profile.fromStorage(settingsBox.get('active_profile'));
    const payloadFactory = ThoughtNotificationPayloadFactory();
    final payload = payloadFactory.create(
      sender: activeProfile,
      body: AppStrings.widgetThought,
    );

    try {
      // Firebase must be initialized in the background isolate before calling Cloud Functions.
      await Firebase.initializeApp();
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('broadcastThoughtV1');
      print(
        '[BH] widget sending as profile=${activeProfile.storageValue} '
        'to topic="${payload.topic}"',
      );
      final result = await callable.call(<String, dynamic>{
        'title': payload.title,
        'body': payload.body,
        'topic': payload.topic,
      });
      print('[BH] widget broadcast result: ${result.data}');
    } catch (e) {
      // If Firebase fails, do NOT fall back to local notification.
      // A local notification would fire on the sender's own device, which is wrong.
      // ignore: avoid_print
      print("Widget: Failed to broadcast via Cloud Function: $e");
    }

    // Close boxes to flush changes
    await box.close();
  }
}

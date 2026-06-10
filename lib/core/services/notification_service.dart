import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/tracker/models/thought.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Save received message to Hive so it appears in chat history
  // even when the app is fully closed.
  if (message.notification == null) return;

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ThoughtAdapter());
  }

  final box = await Hive.openBox<Thought>('thoughts');

  final String? imageUrl = message.notification?.android?.imageUrl ?? message.data['image'];

  final received = Thought(
    id: '${DateTime.now().millisecondsSinceEpoch}_recv',
    content: message.notification!.body ?? '',
    createdAt: DateTime.now(),
    isSent: false,
    imageUrl: imageUrl,
  );

  await box.add(received);
  await box.close();
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> updateTopicSubscription(String profile) async {
    try {
      // If I am 'dado', I listen to 'coelho_thoughts'.
      // If I am 'coelho', I listen to 'dado_thoughts'.
      final listenTopic = profile == 'dado' ? 'coelho_thoughts' : 'dado_thoughts';

      await FirebaseMessaging.instance.unsubscribeFromTopic('couple_thoughts');
      await FirebaseMessaging.instance.unsubscribeFromTopic('dado_thoughts');
      await FirebaseMessaging.instance.unsubscribeFromTopic('coelho_thoughts');

      await FirebaseMessaging.instance.subscribeToTopic(listenTopic);
    } catch (e) {
      // ignore: avoid_print
      print('Failed to update FCM topic subscription: $e');
    }
  }

  Future<void> initialize(String currentProfile) async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap if needed
      },
    );

    // Explicitly create the Android notification channel with MAX importance.
    // FCM background notifications use this channel ID; without it, Android
    // falls back to a low-importance channel → silent notification.
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          'bunny_hoops_channel',
          'Bunny Hoops Notifications',
          description: 'Notificações de pensamentos do casal 🐰🦦',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        ),
      );
    }

    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      await updateTopicSubscription(currentProfile);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        if (message.notification != null) {
          // Show the local notification banner while app is in foreground
          showNotification(
            id: message.hashCode,
            title: message.notification!.title ?? 'Bunny Hoops',
            body: message.notification!.body ?? '',
          );

          // Save received message to Hive for chat history (foreground path)
          try {
            final String? imageUrl = message.notification?.android?.imageUrl ?? message.data['image'];
            final box = Hive.box<Thought>('thoughts');
            final received = Thought(
              id: '${DateTime.now().millisecondsSinceEpoch}_recv',
              content: message.notification!.body ?? '',
              createdAt: DateTime.now(),
              isSent: false,
              imageUrl: imageUrl,
            );
            await box.add(received);
          } catch (e) {
            debugPrint('Failed to save received thought to Hive: $e');
          }
        }
      });
    } catch (e) {
      // Ignore if Firebase isn't initialized yet
    }

    _isInitialized = true;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'bunny_hoops_channel',
      'Bunny Hoops Notifications',
      channelDescription: 'Notifications for tracked thoughts',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

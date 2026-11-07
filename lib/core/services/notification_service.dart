import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_strings.dart';
import '../models/profile.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint(
      '[BH] background message: from=${message.from} body=${message.notification?.body}');
  // Firestore synchronization imports the thought when the app resumes.
  // Writing Hive from a background isolate races the foreground sync isolate.
}

class NotificationService {
  static const _fcmRegistrationVersion = 2;
  static const _fcmRegistrationVersionKey = 'fcm_registration_version';

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> updateTopicSubscription(Profile profile) async {
    try {
      final listenTopics = profile.subscriptionTopics;

      debugPrint(
        '[BH] profile=${profile.storageValue} -> will listen to "$listenTopics"',
      );

      for (final t in [
        'couple_thoughts',
        'dado_thoughts',
        'lontra_thoughts',
        'coelho_thoughts'
      ]) {
        if (listenTopics.contains(t)) continue;
        try {
          await FirebaseMessaging.instance.unsubscribeFromTopic(t);
        } catch (e) {
          debugPrint('[BH] unsubscribe "$t" failed: $e');
        }
      }

      final settings = Hive.box('settings');
      final registeredVersion = settings.get(_fcmRegistrationVersionKey);
      if (registeredVersion != _fcmRegistrationVersion) {
        debugPrint('[BH] refreshing stale FCM registration');
        await FirebaseMessaging.instance.deleteToken();
      }

      // Re-register the selected topic after profile changes and app updates.
      // FCM treats the operation as idempotent and this clears a stale device
      // registration without deleting the user's local app data.
      for (final topic in listenTopics) {
        await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
        await FirebaseMessaging.instance.subscribeToTopic(topic);
      }
      final token = await FirebaseMessaging.instance.getToken();
      await settings.put(_fcmRegistrationVersionKey, _fcmRegistrationVersion);
      debugPrint('[BH] subscribed to "$listenTopics" OK. FCM token=$token');
    } catch (e) {
      debugPrint('[BH] Failed to update FCM topic subscription: $e');
    }
  }

  Future<void> initialize(Profile currentProfile) async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_heart');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
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
      final androidPlugin =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          AppStrings.notificationChannelId,
          AppStrings.notificationChannelName,
          description: AppStrings.notificationChannelDescription,
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
        debugPrint(
            '[BH] onMessage received: from=${message.from} title=${message.notification?.title} body=${message.notification?.body}');
        if (message.notification != null) {
          // Show the local notification banner while app is in foreground
          await showNotification(
            id: message.hashCode,
            title: message.notification!.title ??
                AppStrings.notificationFallbackTitle,
            body: message.notification!.body ?? '',
            imageUrl: message.notification?.android?.imageUrl ??
                message.data['image'],
          );
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
    String? imageUrl,
  }) async {
    final imageBytes =
        imageUrl == null ? null : await _downloadNotificationImage(imageUrl);
    final androidNotificationDetails = AndroidNotificationDetails(
      AppStrings.notificationChannelId,
      AppStrings.notificationChannelName,
      channelDescription: AppStrings.notificationChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      icon: 'ic_heart',
      styleInformation: imageBytes == null
          ? null
          : BigPictureStyleInformation(
              ByteArrayAndroidBitmap(imageBytes),
              contentTitle: title,
              summaryText: body,
            ),
    );

    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }

  Future<Uint8List?> _downloadNotificationImage(String imageUrl) async {
    final client = HttpClient();
    try {
      final request =
          await client.getUrl(Uri.parse(imageUrl)).timeout(const Duration(seconds: 10));
      final response = await request.close().timeout(const Duration(seconds: 10));
      if (response.statusCode != HttpStatus.ok) {
        debugPrint(
            '[BH] notification image download failed: HTTP ${response.statusCode}');
        return null;
      }

      final bytes = await response.fold<List<int>>(
        <int>[],
        (buffer, chunk) => buffer..addAll(chunk),
      ).timeout(const Duration(seconds: 10));
      return Uint8List.fromList(bytes);
    } on FormatException catch (error) {
      debugPrint('[BH] notification image URL is invalid: $error');
    } on HttpException catch (error) {
      debugPrint('[BH] notification image download failed: $error');
    } on SocketException catch (error) {
      debugPrint('[BH] notification image download failed: $error');
    } on TimeoutException {
      debugPrint('[BH] notification image download timed out');
    } finally {
      client.close(force: true);
    }
    return null;
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

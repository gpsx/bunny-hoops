import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // We can just rely on the OS to display the background notification since we send notification payloads.
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
      print("Failed to update FCM topic subscription: $e");
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
    
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      
      await updateTopicSubscription(currentProfile);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          showNotification(
            id: message.hashCode,
            title: message.notification!.title ?? 'Bunny Hoops',
            body: message.notification!.body ?? '',
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
  }) async {
    // initialize must be called with a profile from main.dart now
    // await initialize();

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

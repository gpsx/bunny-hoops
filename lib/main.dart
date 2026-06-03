import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/constants/app_strings.dart';
import 'features/tracker/models/thought.dart';
import 'features/home/views/main_view.dart';
import 'core/services/home_widget_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Note: Firebase setup requires google-services.json to be present in android/app/
  // and GoogleService-Info.plist in ios/Runner/. If missing, it will throw an error.
  await Hive.initFlutter();
  Hive.registerAdapter(ThoughtAdapter());
  await Hive.openBox<Thought>('thoughts');
  await Hive.openBox('settings');

  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    
    // Read saved profile and initialize NotificationService with the correct topic
    final settingsBox = Hive.box('settings');
    final savedProfile = settingsBox.get('active_profile', defaultValue: 'dado') as String;
    final notificationService = NotificationService();
    await notificationService.initialize(savedProfile);
  } catch (e) {
    debugPrint("Firebase initialization failed (missing config files?): $e");
  }
  
  await HomeWidgetService.initialize();
  HomeWidget.registerBackgroundCallback(interactiveCallback);
  
  runApp(
    const ProviderScope(
      child: BunnyHoopsApp(),
    ),
  );
}

class BunnyHoopsApp extends ConsumerWidget {
  const BunnyHoopsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const MainView(),
    );
  }
}

class InitialPlaceholder extends StatelessWidget {
  const InitialPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Bunny hoops\nFoundation Ready',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

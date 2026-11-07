import 'dart:async';

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
import 'core/models/profile.dart';
import 'core/services/cloud_history_service.dart';
import 'core/services/coelho_installation_service.dart';
import 'data/repositories/settings_repository.dart';
import 'data/repositories/thought_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var shouldAnnounceCoelhoInstallation = false;

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
    final rawProfile = settingsBox.get('active_profile');
    final savedProfile = Profile.fromStorage(rawProfile);
    if (rawProfile != savedProfile.storageValue) {
      await settingsBox.put('active_profile', savedProfile.storageValue);
    }
    final notificationService = NotificationService();
    await notificationService.initialize(savedProfile);

    final settings = SettingsRepositoryImpl(settingsBox);
    shouldAnnounceCoelhoInstallation = rawProfile == null &&
        savedProfile == Profile.coelho &&
        !settings.hasAnnouncedCoelhoInstallation();
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

  unawaited(_initializeCloudHistory());
  if (shouldAnnounceCoelhoInstallation) {
    unawaited(_announceCoelhoInstallation());
  }
}

Future<void> _announceCoelhoInstallation() async {
  final announced = await CoelhoInstallationService().announce();
  if (announced) {
    await SettingsRepositoryImpl(Hive.box('settings'))
        .saveCoelhoInstallationAnnounced();
  }
}

Future<void> _initializeCloudHistory() async {
  try {
    final cloudHistory = CloudHistoryService(
      repository: ThoughtRepositoryImpl(Hive.box<Thought>('thoughts')),
      settings: SettingsRepositoryImpl(Hive.box('settings')),
    );
    await cloudHistory.initialize();
  } catch (error, stackTrace) {
    debugPrint('[BH] cloud sync initialization failed: $error\n$stackTrace');
  }
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

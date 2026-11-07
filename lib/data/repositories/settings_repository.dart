import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/profile.dart';

abstract class SettingsRepository {
  ThemeMode getThemeMode();
  Future<void> saveThemeMode(ThemeMode mode);

  Profile getActiveProfile();
  Future<void> saveActiveProfile(Profile profile);
  DateTime? getLastCloudSync();
  Future<void> saveLastCloudSync(DateTime value);
  bool hasAnnouncedCoelhoInstallation();
  Future<void> saveCoelhoInstallationAnnounced();
}

class SettingsRepositoryImpl implements SettingsRepository {
  static const _boxName = 'settings';
  static const _themeModeKey = 'theme_mode';
  static const _activeProfileKey = 'active_profile';

  final Box _box;

  SettingsRepositoryImpl(this._box);

  @override
  ThemeMode getThemeMode() {
    final modeIndex =
        _box.get(_themeModeKey, defaultValue: ThemeMode.light.index);
    return ThemeMode.values[modeIndex];
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _box.put(_themeModeKey, mode.index);
  }

  @override
  Profile getActiveProfile() {
    return Profile.fromStorage(_box.get(_activeProfileKey));
  }

  @override
  Future<void> saveActiveProfile(Profile profile) async {
    await _box.put(_activeProfileKey, profile.storageValue);
  }

  @override
  DateTime? getLastCloudSync() {
    final value = _box.get('last_cloud_sync') as String?;
    return value == null ? null : DateTime.tryParse(value);
  }

  @override
  Future<void> saveLastCloudSync(DateTime value) async {
    await _box.put('last_cloud_sync', value.toIso8601String());
  }

  @override
  bool hasAnnouncedCoelhoInstallation() {
    return _box.get('coelho_installation_announced', defaultValue: false) as bool;
  }

  @override
  Future<void> saveCoelhoInstallationAnnounced() async {
    await _box.put('coelho_installation_announced', true);
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final box = Hive.box('settings');
  return SettingsRepositoryImpl(box);
});

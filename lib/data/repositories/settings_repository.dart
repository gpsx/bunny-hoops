import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class SettingsRepository {
  ThemeMode getThemeMode();
  Future<void> saveThemeMode(ThemeMode mode);
  
  String getActiveProfile();
  Future<void> saveActiveProfile(String profile);
}

class SettingsRepositoryImpl implements SettingsRepository {
  static const _boxName = 'settings';
  static const _themeModeKey = 'theme_mode';
  static const _activeProfileKey = 'active_profile';
  
  final Box _box;

  SettingsRepositoryImpl(this._box);

  @override
  ThemeMode getThemeMode() {
    final modeIndex = _box.get(_themeModeKey, defaultValue: ThemeMode.light.index);
    return ThemeMode.values[modeIndex];
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _box.put(_themeModeKey, mode.index);
  }

  @override
  String getActiveProfile() {
    return _box.get(_activeProfileKey, defaultValue: 'dado') as String;
  }

  @override
  Future<void> saveActiveProfile(String profile) async {
    await _box.put(_activeProfileKey, profile);
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final box = Hive.box('settings');
  return SettingsRepositoryImpl(box);
});

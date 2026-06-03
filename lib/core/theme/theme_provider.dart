import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/settings_repository.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    final repository = ref.read(settingsRepositoryProvider);
    return repository.getThemeMode();
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final repository = ref.read(settingsRepositoryProvider);
    await repository.saveThemeMode(newMode);
    state = newMode;
  }
}

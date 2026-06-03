# 📜 Epic 01: Project Foundation & Structural Setup

## 1. Visão Geral
Este arquivo consolida a tarefa de inicialização técnica do Bunny hoops. O objetivo é configurar dependências, estrutura de pastas, constantes de design e o entry-point do app seguindo o Constitution.md.

---

## 2. Configuração de Dependências (pubspec.yaml)
```yaml
name: bunny_hoops
description: "A new Flutter project for tracking lovely thoughts."
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  google_fonts: ^6.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  riverpod_generator: ^2.4.0
  build_runner: ^2.4.8
  riverpod_lint: ^2.3.10
  custom_lint: ^0.6.4
```
3. Estrutura de Pastas (Shell Script)
Bash
# Comandos para criar a estrutura de diretórios
mkdir -p lib/core/constants
mkdir -p lib/core/theme
mkdir -p lib/core/widgets
mkdir -p lib/data/repositories
mkdir -p lib/data/datasources
mkdir -p lib/features/tracker/models
mkdir -p lib/features/tracker/views
mkdir -p lib/features/tracker/view_models
mkdir -p lib/features/history/views
4. Implementação de Arquivos Core
4.1 - lib/core/theme/app_colors.dart
Dart
import 'package:flutter/material.dart';

class AppColors {
  // Bunny Core Romantic Palette
  static const primary = Color(0xFFFFB7CE);    // Blush Pink
  static const secondary = Color(0xFFFF8C42);  // Soft Orange
  static const background = Color(0xFFFFFDF5); // Cream
  static const neutral = Color(0xFF8D7B7B);    // Warm Grey
  static const white = Color(0xFFFFFFFF);
  static const textDark = Color(0xFF4A4A4A);
}
4.2 - lib/core/constants/app_values.dart
Dart
class AppSizes {
  // Padding & Margin
  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;

  // Border Radius (Constitution Compliance)
  static const double rCard = 28.0;
  static const double rButton = 50.0;
  
  // Icon Sizes
  static const double iSmall = 20.0;
  static const double iMedium = 32.0;
  static const double iLarge = 48.0;
}
4.3 - lib/core/constants/app_strings.dart
Dart
class AppStrings {
  // App General
  static const appName = 'Bunny hoops';
  
  // Tracker Screen
  static const dailyTotal = 'DAILY TOTAL';
  static const lovelyThoughtsToday = 'Lovely thoughts captured today';
  static const recordThought = 'Record Thought';
  static const lastEntry = 'Last entry';
  static const streak = 'Streak';
  static const goal = 'Goal:';
  
  // History Screen
  static const historyTitle = 'History';
}
5. Entry Point (lib/main.dart)
Dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Inicializar Hive aqui na Task de Persistência
  
  runApp(
    const ProviderScope(
      child: BunnyHoopsApp(),
    ),
  );
}

class BunnyHoopsApp extends StatelessWidget {
  const BunnyHoopsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bunny hoops',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(
          bodyColor: AppColors.textDark,
          displayColor: AppColors.neutral,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          background: AppColors.background,
        ),
      ),
      home: const InitialPlaceholder(),
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
6. Checklist de Conclusão
[ ] Dependências instaladas via flutter pub get.

[ ] Estrutura de pastas validada.

[ ] Constantes (Cores, Medidas, Strings) criadas sem erros.

[ ] Main configurada com ProviderScope e ThemeData.
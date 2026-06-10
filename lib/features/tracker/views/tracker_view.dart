import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_values.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/daily_counter_display.dart';
import '../../../core/widgets/bunny_record_button.dart';
import '../../../core/widgets/metric_card.dart';

import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/profile_toggle_button.dart';
import '../view_models/tracker_view_model.dart';

class TrackerView extends ConsumerStatefulWidget {
  const TrackerView({super.key});

  @override
  ConsumerState<TrackerView> createState() => _TrackerViewState();
}

class _TrackerViewState extends ConsumerState<TrackerView> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(trackerViewModelProvider);
    final themeMode = ref.watch(themeNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onPressed: () {
            ref.read(themeNotifierProvider.notifier).toggleTheme();
          },
        ),
        title: const Text('Bunny hoops'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
        actions: const [
          ProfileToggleButton(),
        ],
      ),
      body: stateAsync.when(
        data: (state) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p24),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    const SizedBox(height: AppSizes.p40),
                    DailyCounterDisplay(count: state.count),
                    const Spacer(),
                    BunnyRecordButton(
                      isLoading: state.isLoading,
                      onPressed: () async {
                        final text = _messageController.text;
                        _messageController.clear();
                        FocusScope.of(context).unfocus(); // Also dismiss keyboard
                        await ref.read(trackerViewModelProvider.notifier).recordNewThought(message: text);
                      },
                    ),
                    const SizedBox(height: AppSizes.p24),
                    TextField(
                      controller: _messageController,
                      maxLength: 100,
                      readOnly: state.isLoading,
                      decoration: InputDecoration(
                        hintText: AppStrings.customMessageHint,
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.rButton),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.p20, vertical: AppSizes.p16),
                        counterText: '',
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.camera_alt_rounded),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: state.isLoading ? null : () => ref.read(trackerViewModelProvider.notifier).pickImage(ImageSource.camera),
                            ),
                            IconButton(
                              icon: const Icon(Icons.photo_library_rounded),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: state.isLoading ? null : () => ref.read(trackerViewModelProvider.notifier).pickImage(ImageSource.gallery),
                            ),
                            const SizedBox(width: AppSizes.p8),
                          ],
                        ),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: SizeTransition(sizeFactor: animation, child: child));
                      },
                      child: state.selectedImagePath != null
                          ? Column(
                              key: const ValueKey('image_preview'),
                              children: [
                                const SizedBox(height: AppSizes.p16),
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(AppSizes.rCard),
                                      child: Image.file(
                                        File(state.selectedImagePath!),
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: AppSizes.p8,
                                      right: AppSizes.p8,
                                      child: GestureDetector(
                                        onTap: state.isLoading ? null : () => ref.read(trackerViewModelProvider.notifier).removeSelectedImage(),
                                        child: Container(
                                          padding: const EdgeInsets.all(AppSizes.p4),
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close, color: Colors.white, size: AppSizes.iSmall),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : const SizedBox.shrink(key: ValueKey('empty_preview')),
                    ),
                    const Spacer(),
                    _buildMetricsRow(state),
                    const SizedBox(height: AppSizes.p40),
                  ],
                ),
              ),
            ],
        ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildMetricsRow(TrackerState state) {
    return Row(
      children: [
        Expanded(
          child: MetricCard(
            label: 'Last entry',
            value: state.lastEntry,
            icon: Icons.access_time,
          ),
        ),
        const SizedBox(width: AppSizes.p16),
        Expanded(
          child: MetricCard(
            label: 'Streak',
            value: '${state.streak} Days',
            icon: Icons.trending_up,
          ),
        ),
      ],
    );
  }
}


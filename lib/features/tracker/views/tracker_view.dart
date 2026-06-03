import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                      onPressed: () async {
                        await ref.read(trackerViewModelProvider.notifier).recordNewThought(message: _messageController.text);
                        _messageController.clear();
                      },
                    ),
                    const SizedBox(height: AppSizes.p24),
                    TextField(
                      controller: _messageController,
                      maxLength: 100,
                      decoration: InputDecoration(
                        hintText: AppStrings.customMessageHint,
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.rButton),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.p20, vertical: AppSizes.p16),
                        counterText: '', // Hide counter
                      ),
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


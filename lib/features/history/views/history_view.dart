import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_values.dart';
import '../../../core/widgets/total_thoughts_card.dart';
import '../../../core/theme/theme_provider.dart';
import '../view_models/history_view_model.dart';
import 'day_detail_view.dart';
import 'widgets/history_day_tile.dart';

class HistoryView extends ConsumerWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(historyViewModelProvider);
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
      ),
      body: stateAsync.when(
        data: (state) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.p24),
              TotalThoughtsCard(totalCount: state.totalThoughts),
              const SizedBox(height: AppSizes.p32),
              Row(
                children: [
                  Text(
                    'HISTORY',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withValues(alpha: 0.6),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(width: AppSizes.p16),
                  Expanded(
                    child: Divider(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.2),
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.p24),
              Expanded(
                child: state.groupedHistory.isEmpty
                    ? Center(
                        child: Text(
                          'No records yet.\nStart tracking your thoughts!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: state.groupedHistory.length,
                        itemBuilder: (context, index) {
                          final dayAggr = state.groupedHistory[index];
                          return HistoryDayTile(
                            dateLabel: dayAggr.dateLabel,
                            count: dayAggr.count,
                            hasMessages: dayAggr.hasMessages,
                            onTap: () {
                              if (!dayAggr.hasMessages) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Este dia não possui mensagens detalhadas.',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppSizes.p12),
                                    ),
                                  ),
                                );
                                return;
                              }
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => DayDetailView(
                                    dateLabel: dayAggr.dateLabel,
                                    date: dayAggr.date,
                                  ),
                                ),
                              );
                            },
                          );
                        },
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
}

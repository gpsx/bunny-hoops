import 'package:flutter/material.dart';
import '../../../../core/constants/app_values.dart';

class HistoryDayTile extends StatelessWidget {
  final String dateLabel;
  final int count;
  final VoidCallback onTap;
  final bool hasMessages;

  const HistoryDayTile({
    super.key,
    required this.dateLabel,
    required this.count,
    required this.onTap,
    this.hasMessages = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.p16),
      child: Material(
        color: Theme.of(context).cardTheme.color ??
            Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSizes.rCard),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.rCard),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p32,
              vertical: AppSizes.p24,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateLabel,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Row(
                  children: [
                    Text(
                      count.toString(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (hasMessages) ...[
                      const SizedBox(width: AppSizes.p8),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: AppSizes.iSmall,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

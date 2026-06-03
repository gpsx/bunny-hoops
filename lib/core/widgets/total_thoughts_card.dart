import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_values.dart';

class TotalThoughtsCard extends StatelessWidget {
  final int totalCount;

  const TotalThoughtsCard({
    super.key,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSizes.p32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(28.0),
      ),
      child: Column(
        children: [
          Text(
            'TOTAL THOUGHTS',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: AppSizes.p16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                totalCount.toString(),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 64,
                    ),
              ),
              const SizedBox(width: AppSizes.p8),
              Icon(
                Icons.cruelty_free,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.p8),
          Text(
            'Precious moments recorded',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                ),
          ),
        ],
      ),
    );
  }
}

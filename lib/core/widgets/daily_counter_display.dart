import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../constants/app_values.dart';

class DailyCounterDisplay extends StatelessWidget {
  final int count;
  final String label;

  const DailyCounterDisplay({
    super.key,
    required this.count,
    this.label = 'Lovely thoughts captured today',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.favorite,
              size: 200,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            ),
            Text(
              '$count',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 64,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.p8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

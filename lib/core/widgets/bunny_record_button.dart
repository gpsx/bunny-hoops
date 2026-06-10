import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../constants/app_values.dart';

class BunnyRecordButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final bool isLoading;

  const BunnyRecordButton({
    super.key,
    required this.onPressed,
    this.label = 'Record Thought',
    this.isLoading = false,
  });

  @override
  State<BunnyRecordButton> createState() => _BunnyRecordButtonState();
}

class _BunnyRecordButtonState extends State<BunnyRecordButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    if (widget.isLoading) return;
    setState(() => _scale = 0.92);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap: widget.isLoading ? null : widget.onPressed,
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: widget.isLoading 
                    ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)
                    : Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: widget.isLoading ? [] : [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: widget.isLoading 
                ? Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      strokeWidth: 4,
                    ),
                  )
                : Icon(
                    Icons.pets,
                    size: 60,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.p16),
        Text(
          widget.label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

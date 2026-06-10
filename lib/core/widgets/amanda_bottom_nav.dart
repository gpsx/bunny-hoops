import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_values.dart';

class AmandaBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AmandaBottomNav({
    super.key,
    this.currentIndex = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.rCard),
          topRight: Radius.circular(AppSizes.rCard),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size: AppSizes.iMedium),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_filled, size: AppSizes.iMedium),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library, size: AppSizes.iMedium),
            label: 'Gallery',
          ),
        ],
      ),
    );
  }
}

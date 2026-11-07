import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/tracker/view_models/profile_view_model.dart';

class ProfileToggleButton extends ConsumerWidget {
  const ProfileToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeProfile = ref.watch(profileNotifierProvider);

    return IconButton(
      icon: Text(
        activeProfile.icon,
        style: const TextStyle(fontSize: 24),
      ),
      tooltip: 'Perfil ativo: ${activeProfile.displayName}. Toque para trocar.',
      onPressed: () {
        ref.read(profileNotifierProvider.notifier).toggleProfile();
      },
    );
  }
}

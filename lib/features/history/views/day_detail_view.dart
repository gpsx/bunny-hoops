import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_values.dart';
import '../../tracker/models/thought.dart';
import '../view_models/day_detail_view_model.dart';
import 'widgets/message_bubble.dart';
import '../../gallery/views/full_screen_image_viewer.dart';

class DayDetailView extends ConsumerWidget {
  final String dateLabel;
  final DateTime date;

  const DayDetailView({
    super.key,
    required this.dateLabel,
    required this.date,
  });

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thoughtsAsync = ref.watch(dayThoughtsProvider(date));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: AppSizes.iSmall,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          dateLabel,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: thoughtsAsync.when(
        data: (thoughts) {
          if (thoughts.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🐰',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: AppSizes.p16),
                  Text(
                    'Nenhuma mensagem aqui ainda.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p16,
              vertical: AppSizes.p24,
            ),
            itemCount: thoughts.length,
            itemBuilder: (context, index) {
              final thought = thoughts[index];
              
              // Find the index of this thought in the photos list of the day
              final photosOfDay = thoughts.where((t) => t.imageUrl != null && t.imageUrl!.isNotEmpty).toList();
              final photoIndex = photosOfDay.indexWhere((t) => t.id == thought.id);

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.p16),
                child: MessageBubble(
                  id: thought.id,
                  content: thought.content,
                  time: _formatTime(thought.createdAt),
                  isSent: thought.wasSent,
                  imageUrl: thought.imageUrl,
                  onImageTap: photoIndex != -1 
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImageViewer(
                              photos: photosOfDay,
                              initialIndex: photoIndex,
                            ),
                          ),
                        );
                      }
                    : null,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
      ),
    );
  }
}

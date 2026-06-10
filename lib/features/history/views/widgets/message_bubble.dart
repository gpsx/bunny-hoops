import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_values.dart';

import 'package:cached_network_image/cached_network_image.dart';

class MessageBubble extends StatelessWidget {
  final String content;
  final String time;
  final bool isSent;
  final String? imageUrl;
  final String id;
  final VoidCallback? onImageTap;

  const MessageBubble({
    super.key,
    required this.id,
    required this.content,
    required this.time,
    required this.isSent,
    this.imageUrl,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final Color bubbleColor;
    final Color textColor;
    final Color timeColor;

    if (isSent) {
      bubbleColor = isLight ? AppColors.lightPrimary : AppColors.darkPrimaryContainer;
      textColor = isLight ? AppColors.lightOnPrimary : AppColors.darkOnPrimary;
      timeColor = (isLight ? AppColors.lightOnPrimary : AppColors.darkOnPrimary)
          .withValues(alpha: 0.65);
    } else {
      bubbleColor = isLight ? AppColors.lightSurfaceContainer : AppColors.darkSurfaceContainer;
      textColor = isLight ? AppColors.lightOnSurface : AppColors.darkOnSurface;
      timeColor = isLight
          ? AppColors.lightOnSurfaceVariant.withValues(alpha: 0.7)
          : AppColors.darkOnSurfaceVariant.withValues(alpha: 0.7);
    }

    final borderRadius = isSent
        ? const BorderRadius.only(
            topLeft: Radius.circular(AppSizes.rCard),
            topRight: Radius.circular(AppSizes.rCard),
            bottomLeft: Radius.circular(AppSizes.rCard),
            bottomRight: Radius.circular(AppSizes.p4),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(AppSizes.p4),
            topRight: Radius.circular(AppSizes.rCard),
            bottomLeft: Radius.circular(AppSizes.rCard),
            bottomRight: Radius.circular(AppSizes.rCard),
          );

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.p16,
            vertical: AppSizes.p12,
          ),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: borderRadius,
          ),
          child: Column(
            crossAxisAlignment:
                isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (imageUrl != null && imageUrl!.isNotEmpty) ...[
                GestureDetector(
                  onTap: onImageTap,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.p8),
                    child: Hero(
                      tag: 'gallery_image_$id',
                      child: CachedNetworkImage(
                        imageUrl: imageUrl!,
                        placeholder: (context, url) => Container(
                          height: 150,
                          width: 150,
                          color: isLight ? Colors.black12 : Colors.white12,
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                if (content.isNotEmpty) const SizedBox(height: AppSizes.p8),
              ],
              if (content.isNotEmpty)
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textColor,
                        height: 1.4,
                      ),
                ),
              const SizedBox(height: AppSizes.p4),
              Text(
                time,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: timeColor,
                      fontSize: 11,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

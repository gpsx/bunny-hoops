import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../tracker/models/thought.dart';
import '../../../core/constants/app_values.dart';

class FullScreenImageViewer extends StatefulWidget {
  final List<Thought> photos;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.photos,
    required this.initialIndex,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thought = widget.photos[_currentIndex];
    
    // Formatting date and time
    final timeStr = "${thought.createdAt.hour.toString().padLeft(2, '0')}:${thought.createdAt.minute.toString().padLeft(2, '0')}";
    final dateStr = "${thought.createdAt.day.toString().padLeft(2, '0')}/${thought.createdAt.month.toString().padLeft(2, '0')}/${thought.createdAt.year}";

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "${_currentIndex + 1} of ${widget.photos.length}",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photos.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final photoThought = widget.photos[index];
              return InteractiveViewer(
                minScale: 1.0,
                maxScale: 4.0,
                child: Center(
                  child: Hero(
                    tag: 'gallery_image_${photoThought.id}',
                    child: CachedNetworkImage(
                      imageUrl: photoThought.imageUrl!,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Bottom overlay with text
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: AppSizes.p24,
                right: AppSizes.p24,
                top: AppSizes.p24,
                bottom: AppSizes.p24 + MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.0),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (thought.content.isNotEmpty)
                    Text(
                      thought.content,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            height: 1.4,
                          ),
                    ),
                  if (thought.content.isNotEmpty)
                    const SizedBox(height: AppSizes.p8),
                  Text(
                    "$dateStr at $timeStr",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../tracker/models/thought.dart';
import '../../../data/repositories/thought_repository_impl.dart';

part 'gallery_view_model.g.dart';

class GalleryState {
  final List<Thought> photos;
  final bool hasMore;
  final bool isLoadingMore;

  GalleryState({
    required this.photos,
    required this.hasMore,
    required this.isLoadingMore,
  });

  GalleryState copyWith({
    List<Thought>? photos,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return GalleryState(
      photos: photos ?? this.photos,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

@riverpod
class GalleryViewModel extends _$GalleryViewModel {
  static const int _pageSize = 30;
  List<Thought> _allPhotos = [];

  @override
  FutureOr<GalleryState> build() async {
    final repository = ref.watch(thoughtRepositoryProvider);
    final allThoughts = await repository.getThoughts();
    
    // Filter only thoughts with images and sort most recent first
    _allPhotos = allThoughts.where((t) => t.imageUrl != null && t.imageUrl!.isNotEmpty).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final initialPhotos = _allPhotos.take(_pageSize).toList();
    
    return GalleryState(
      photos: initialPhotos,
      hasMore: _allPhotos.length > _pageSize,
      isLoadingMore: false,
    );
  }

  Future<void> loadMore() async {
    final currentState = state.valueOrNull;
    if (currentState == null || !currentState.hasMore || currentState.isLoadingMore) return;

    state = AsyncData(currentState.copyWith(isLoadingMore: true));
    
    // Simulate a tiny delay for smooth UX
    await Future.delayed(const Duration(milliseconds: 300));

    final currentLength = currentState.photos.length;
    final nextPhotos = _allPhotos.skip(currentLength).take(_pageSize).toList();
    final updatedPhotos = [...currentState.photos, ...nextPhotos];

    state = AsyncData(GalleryState(
      photos: updatedPhotos,
      hasMore: updatedPhotos.length < _allPhotos.length,
      isLoadingMore: false,
    ));
  }
}

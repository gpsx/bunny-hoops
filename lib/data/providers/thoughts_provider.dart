import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/tracker/models/thought.dart';
import '../repositories/thought_repository_impl.dart';

final thoughtsProvider = StreamProvider<List<Thought>>((ref) {
  return ref.watch(thoughtRepositoryProvider).watchThoughts();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/review_repository_impl.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';

final reviewNotifierProvider = StateNotifierProvider<ReviewNotifier, AsyncValue<List<Review>>>((ref) {
  return ReviewNotifier(ref.watch(reviewRepositoryProvider));
});

class ReviewNotifier extends StateNotifier<AsyncValue<List<Review>>> {
  final ReviewRepository _repository;

  ReviewNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> loadReviews(String userId) async {
    state = const AsyncValue.loading();
    try {
      final reviews = await _repository.getReviewsForUser(userId);
      state = AsyncValue.data(reviews);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addReview(Review review) async {
    try {
      await _repository.addReview(review);
      // Ideally update the state if it matches current user
      final currentList = state.valueOrNull ?? [];
      state = AsyncValue.data([...currentList, review]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

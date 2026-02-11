import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl();
});

class ReviewRepositoryImpl implements ReviewRepository {
  final List<Review> _reviews = [];

  @override
  Future<void> addReview(Review review) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _reviews.add(review);
  }

  @override
  Future<List<Review>> getReviewsForUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _reviews.where((r) => r.revieweeId == userId).toList();
  }
}

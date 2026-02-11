import '../entities/review.dart';

abstract class ReviewRepository {
  Future<void> addReview(Review review);
  Future<List<Review>> getReviewsForUser(String userId);
}

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/listing.dart';

abstract class ListingRepository {
  Future<Either<Failure, List<Listing>>> getListings({
    String? category,
    String? searchQuery,
    String? userId,
    String? location,
    String? condition,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, Listing>> getListingById(String id);
  Future<Either<Failure, Listing>> createListing(Listing listing);
  Future<Either<Failure, Listing>> updateListing(Listing listing);
  Future<Either<Failure, void>> deleteListing(String id);
  Future<Either<Failure, void>> markAsSold(String id, String buyerId, {String? buyerName, String? buyerEmail});
  Future<Either<Failure, List<Listing>>> getFavorites();
  Future<Either<Failure, void>> addToFavorites(String id);
  Future<Either<Failure, void>> removeFromFavorites(String id);
}

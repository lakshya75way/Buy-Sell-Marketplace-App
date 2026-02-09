import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/listing.dart';
import '../../domain/repositories/listing_repository.dart';
import '../datasources/listing_local_data_source.dart';
import '../datasources/listing_remote_data_source.dart';

class ListingRepositoryImpl implements ListingRepository {
  final ListingRemoteDataSource remoteDataSource;
  final ListingLocalDataSource localDataSource;

  ListingRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
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
  }) async {
    try {
      final listings = await remoteDataSource.getListings(
        category: category,
        searchQuery: searchQuery,
        location: location,
        condition: condition,
        minPrice: minPrice,
        maxPrice: maxPrice,
        page: page,
        limit: limit,
      );
      
      // Cache only if it's the first page and no filters (simplification for offline)
      if (page == 1 && category == null && searchQuery == null && location == null && minPrice == null && maxPrice == null) {
        localDataSource.cacheListings(listings);
      }
      
      if (userId != null) {
        return Right(listings.where((l) => l.sellerId == userId).toList());
      }
      return Right(listings);
    } catch (e) {
      // Offline fallback
      if (page == 1 && category == null && searchQuery == null && location == null && minPrice == null && maxPrice == null) {
         final localListings = await localDataSource.getLastListings();
         if (localListings.isNotEmpty) {
           return Right(localListings);
         }
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Listing>> getListingById(String id) async {
    try {
      final listing = await remoteDataSource.getListingById(id);
      return Right(listing);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Listing>> createListing(Listing listing) async {
    try {
      final createdValues = await remoteDataSource.createListing(listing);
      return Right(createdValues);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Listing>> updateListing(Listing listing) async {
    try {
      final updated = await remoteDataSource.updateListing(listing);
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteListing(String id) async {
    try {
      await remoteDataSource.deleteListing(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsSold(String id, String buyerId, {String? buyerName, String? buyerEmail}) async {
    try {
      final listing = await remoteDataSource.getListingById(id);
      await remoteDataSource.updateListing(listing.copyWith(
        status: ListingStatus.sold, 
        buyerId: buyerId,
        buyerName: buyerName,
        buyerEmail: buyerEmail,
      ));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Listing>>> getFavorites() async {
    try {
      final ids = await localDataSource.getFavoriteIds();
      
      
      final allListings = await remoteDataSource.getListings();
      final favorites = allListings.where((l) => ids.contains(l.id)).toList();
      return Right(favorites);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(String id) async {
    try {
      await localDataSource.addFavorite(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String id) async {
     try {
      await localDataSource.removeFavorite(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}

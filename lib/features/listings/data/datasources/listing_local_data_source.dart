import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/listing.dart';

abstract class ListingLocalDataSource {
  Future<List<String>> getFavoriteIds();
  Future<void> addFavorite(String id);
  Future<void> removeFavorite(String id);
  Future<void> cacheListings(List<Listing> listings);
  Future<List<Listing>> getLastListings();
}

class ListingLocalDataSourceImpl implements ListingLocalDataSource {
  final Box box;

  ListingLocalDataSourceImpl(this.box);

  static const _favoritesKey = 'favorite_ids';

  @override
  Future<List<String>> getFavoriteIds() async {
    return List<String>.from(box.get(_favoritesKey, defaultValue: []) as List);
  }

  @override
  Future<void> addFavorite(String id) async {
    final favorites = await getFavoriteIds();
    if (!favorites.contains(id)) {
      favorites.add(id);
      await box.put(_favoritesKey, favorites);
    }
  }

  @override
  Future<void> removeFavorite(String id) async {
    final favorites = await getFavoriteIds();
    favorites.remove(id);
    await box.put(_favoritesKey, favorites);
  }

  static const _cachedListingsKey = 'cached_listings';

  @override
  Future<void> cacheListings(List<Listing> listings) async {
    final jsonList = listings.map((l) => l.toJson()).toList();
    await box.put(_cachedListingsKey, jsonList);
  }

  @override
  Future<List<Listing>> getLastListings() async {
    final data = box.get(_cachedListingsKey);
    if (data != null && data is List) {
      return data.map((json) => Listing.fromJson(Map<String, dynamic>.from(json))).toList();
    }
    return [];
  }
}

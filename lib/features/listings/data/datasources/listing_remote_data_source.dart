import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/listing.dart';

abstract class ListingRemoteDataSource {
  Future<List<Listing>> getListings({
    String? category,
    String? searchQuery,
    String? location,
    String? condition,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 20,
  });
  Future<Listing> getListingById(String id);
  Future<Listing> createListing(Listing listing);
  Future<Listing> updateListing(Listing listing);
  Future<void> deleteListing(String id);
}

class ListingRemoteDataSourceImpl implements ListingRemoteDataSource {
  List<Listing> _listings = [];
  final _delay = const Duration(milliseconds: 500);
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/listings.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> jsonList = json.decode(content);
        _listings = jsonList.map((json) {
           return Listing.fromJson(json);
        }).toList();
      } else {
        // Seed initial mock data
        _listings = [
          Listing(
            id: '1',
            sellerId: 'user_1',
            sellerName: 'John Doe',
            title: 'iPhone 15 Pro Max - Like New',
            description: 'Titanium Blue, 256GB. Barely used, comes with original box and accessories.',
            price: 95000,
            category: ListingCategory.electronics,
            condition: ListingCondition.likeNew,
            images: ['https://images.unsplash.com/photo-1696446701796-da61225697cc?auto=format&fit=crop&q=80&w=1000'],
            sellerEmail: 'john@example.com',
            sellerPhone: '+919876543210',
            location: 'Mumbai, MH',
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
          Listing(
            id: '2',
            sellerId: 'user_2',
            sellerName: 'Jane Smith',
            title: 'Royal Enfield Classic 350',
            description: '2022 model, low mileage. Well maintained and serviced regularly.',
            price: 185000,
            category: ListingCategory.vehicles,
            condition: ListingCondition.good,
            images: ['https://images.unsplash.com/photo-1558981403-c5f9899a28bc?auto=format&fit=crop&q=80&w=1000'],
            sellerEmail: 'jane@smith.com',
            sellerPhone: '+918765432109',
            location: 'Delhi, DL',
            createdAt: DateTime.now().subtract(const Duration(days: 5)),
          ),
          Listing(
            id: '3',
            sellerId: 'user_3',
            sellerName: 'Modern Home',
            title: 'L-Shaped Velvet Sofa',
            description: 'Deep green velvet, very comfortable. Perfect for modern living rooms.',
            price: 45000,
            category: ListingCategory.home,
            condition: ListingCondition.newCondition,
            images: ['https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&q=80&w=1000'],
            sellerEmail: 'sales@modernhome.com',
            sellerPhone: '+917654321098',
            location: 'Bangalore, KA',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ];
        await _save();
      }
    } catch (e) {
      debugPrint('Error loading listings: $e');
      _listings = [];
    }
    _initialized = true;
  }

  Future<void> _save() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/listings.json');
      final jsonList = _listings.map((l) => l.toJson()).toList(); // I need toJson too.
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      debugPrint('Error saving listings: $e');
    }
  }

  @override
  Future<List<Listing>> getListings({
    String? category,
    String? searchQuery,
    String? location,
    String? condition,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 20,
  }) async {
    await _init();
    await Future.delayed(_delay);
    final filtered = _listings.where((l) {
      if (category != null && category.isNotEmpty && l.category.name != category) return false;
      if (searchQuery != null && searchQuery.isNotEmpty && !l.title.toLowerCase().contains(searchQuery.toLowerCase()) && !l.description.toLowerCase().contains(searchQuery.toLowerCase())) return false;
      if (location != null && location.isNotEmpty && !l.location.toLowerCase().contains(location.toLowerCase())) return false;
      if (condition != null && condition.isNotEmpty && l.condition.name != condition) return false;
      if (minPrice != null && l.price < minPrice) return false;
      if (maxPrice != null && l.price > maxPrice) return false;
      return true;
    }).toList();

    final startIndex = (page - 1) * limit;
    if (startIndex >= filtered.length) return [];
    
    final endIndex = startIndex + limit;
    return filtered.sublist(startIndex, endIndex > filtered.length ? filtered.length : endIndex);
  }

  @override
  Future<Listing> getListingById(String id) async {
    await _init();
    await Future.delayed(_delay);
    return _listings.firstWhere((l) => l.id == id);
  }

  @override
  Future<Listing> createListing(Listing listing) async {
    await _init();
    await Future.delayed(_delay);
    final newListing = listing.copyWith(id: const Uuid().v4(), createdAt: DateTime.now());
    _listings.add(newListing);
    await _save();
    return newListing;
  }

  @override
  Future<Listing> updateListing(Listing listing) async {
    await _init();
    await Future.delayed(_delay);
    final index = _listings.indexWhere((l) => l.id == listing.id);
    if (index != -1) {
      _listings[index] = listing.copyWith(updatedAt: DateTime.now());
      await _save();
      return _listings[index];
    }
    throw Exception('Listing not found');
  }

  @override
  Future<void> deleteListing(String id) async {
    await _init();
    await Future.delayed(_delay);
    _listings.removeWhere((l) => l.id == id);
    await _save();
  }
}

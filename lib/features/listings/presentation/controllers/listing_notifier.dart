import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/listing.dart';
import '../../domain/entities/offer.dart';
import '../../domain/entities/sort_option.dart';
import '../../domain/repositories/listing_repository.dart';
import '../providers/listing_providers.dart';

enum ListingStateStatus { initial, loading, loaded, error }

class ListingState {
  final ListingStateStatus status;
  final List<Listing> listings;
  final List<Listing> favorites;
  final String? errorMessage;
  final int page;
  final bool hasReachedMax;

  const ListingState({
    this.status = ListingStateStatus.initial,
    this.listings = const [],
    this.favorites = const [],
    this.errorMessage,
    this.page = 1,
    this.hasReachedMax = false,
  });

  ListingState copyWith({
    ListingStateStatus? status,
    List<Listing>? listings,
    List<Listing>? favorites,
    String? errorMessage,
    int? page,
    bool? hasReachedMax,
  }) {
    return ListingState(
      status: status ?? this.status,
      listings: listings ?? this.listings,
      favorites: favorites ?? this.favorites,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class ListingNotifier extends StateNotifier<ListingState> {
  final ListingRepository _repository;

  ListingNotifier(this._repository) : super(const ListingState()) {
    loadListings();
    loadFavorites();
  }


  Future<void> loadListings({
    String? category,
    String? searchQuery,
    String? location,
    ListingCondition? condition,
    double? minPrice,
    double? maxPrice,
    SortOption sortBy = SortOption.latest,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore && (state.hasReachedMax || state.status == ListingStateStatus.loading)) return;

    if (!isLoadMore) {
      state = state.copyWith(status: ListingStateStatus.loading, page: 1, hasReachedMax: false, listings: []);
    }

    final page = isLoadMore ? state.page + 1 : 1;

    final result = await _repository.getListings(
      category: category,
      searchQuery: searchQuery,
      location: location,
      condition: condition?.name,
      minPrice: minPrice,
      maxPrice: maxPrice,
      page: page,
      limit: 20,
    );
    result.fold(
      (failure) => state = state.copyWith(
        status: ListingStateStatus.error,
        errorMessage: failure.message,
      ),
      (listings) {
        final sortedList = List<Listing>.from(listings);

        
        switch (sortBy) {
          case SortOption.priceAsc:
            sortedList.sort((a, b) => a.price.compareTo(b.price));
            break;
          case SortOption.priceDesc:
            sortedList.sort((a, b) => b.price.compareTo(a.price));
            break;
          case SortOption.latest:
            sortedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            break;
          case SortOption.popularity:
            sortedList.sort((a, b) => b.id.length.compareTo(a.id.length)); 
            break;
        }

        final newList = isLoadMore ? [...state.listings, ...sortedList] : sortedList;
        
        state = state.copyWith(
          status: ListingStateStatus.loaded,
          listings: newList,
          page: page,
          hasReachedMax: listings.length < 20,
        );
      },
    );
  }

  Future<void> loadFavorites() async {
    final result = await _repository.getFavorites();
    result.fold(
      (failure) {},
      (favorites) => state = state.copyWith(favorites: favorites),
    );
  }

  Future<void> createListing(Listing listing) async {
    state = state.copyWith(status: ListingStateStatus.loading);
    final result = await _repository.createListing(listing);
    result.fold(
      (failure) => state = state.copyWith(
        status: ListingStateStatus.error,
        errorMessage: failure.message,
      ),
      (newListing) {
        state = state.copyWith(
          status: ListingStateStatus.loaded,
          listings: [...state.listings, newListing],
        );
      },
    );
  }

  Future<void> updateListing(Listing listing) async {
    state = state.copyWith(status: ListingStateStatus.loading);
    final result = await _repository.updateListing(listing);
    result.fold(
      (failure) => state = state.copyWith(
        status: ListingStateStatus.error,
        errorMessage: failure.message,
      ),
      (updatedListing) {
        final updatedList = state.listings.map((l) {
          return l.id == updatedListing.id ? updatedListing : l;
        }).toList();
        state = state.copyWith(
          status: ListingStateStatus.loaded,
          listings: updatedList,
        );
      },
    );
  }

  Future<void> toggleFavorite(String listingId) async {
    final isFavorite = state.favorites.any((l) => l.id == listingId);
    if (isFavorite) {
      await _repository.removeFromFavorites(listingId);
    } else {
      await _repository.addToFavorites(listingId);
    }
    await loadFavorites();
  }

  Future<void> deleteListing(String id) async {
    state = state.copyWith(status: ListingStateStatus.loading);
    final result = await _repository.deleteListing(id);
    result.fold(
      (failure) => state = state.copyWith(
        status: ListingStateStatus.error,
        errorMessage: failure.message,
      ),
      (_) {
        final updatedListings = state.listings.where((l) => l.id != id).toList();
        state = state.copyWith(
          status: ListingStateStatus.loaded,
          listings: updatedListings,
        );
      },
    );
  }

  Future<void> buyListing(String listingId, String buyerId, {String? buyerName, String? buyerEmail}) async {
    state = state.copyWith(status: ListingStateStatus.loading);

    await Future.delayed(const Duration(seconds: 2));
    final result = await _repository.markAsSold(listingId, buyerId, buyerName: buyerName, buyerEmail: buyerEmail);
    result.fold(
      (failure) => state = state.copyWith(
        status: ListingStateStatus.error,
        errorMessage: failure.message,
      ),
      (_) {
        final updatedListings = state.listings.map((l) {
          if (l.id == listingId) {
            return l.copyWith(
              status: ListingStatus.sold, 
              buyerId: buyerId,
              buyerName: buyerName,
              buyerEmail: buyerEmail,
            );
          }
          return l;
        }).toList();
        state = state.copyWith(
          status: ListingStateStatus.loaded,
          listings: updatedListings,
        );
      },
    );
  }

  Future<void> markAsSold(String listingId) async {
    state = state.copyWith(status: ListingStateStatus.loading);
    final result = await _repository.markAsSold(listingId, 'MANUAL_SALE');
    result.fold(
      (failure) => state = state.copyWith(
        status: ListingStateStatus.error,
        errorMessage: failure.message,
      ),
      (_) {
        final updatedListings = state.listings.map((l) {
          if (l.id == listingId) return l.copyWith(status: ListingStatus.sold, buyerId: 'MANUAL_SALE');
          return l;
        }).toList();
        state = state.copyWith(
          status: ListingStateStatus.loaded,
          listings: updatedListings,
        );
      },
    );
  }

  Future<void> makeOffer(String listingId, Offer offer) async {
    final listings = state.listings;
    final index = listings.indexWhere((l) => l.id == listingId);
    if (index != -1) {
      final listing = listings[index];
      final currentOffers = listing.offers ?? [];
      final updatedListing = listing.copyWith(
        offers: [...currentOffers, offer],
      );
      
      await updateListing(updatedListing);
    }
  }

  Future<void> acceptOffer(String listingId, String offerId) async {
    final listings = state.listings;
    final index = listings.indexWhere((l) => l.id == listingId);
    if (index != -1) {
      final listing = listings[index];
      final currentOffers = listing.offers ?? [];
      
      final updatedOffers = currentOffers.map((o) {
        if (o.id == offerId) {
          return o.copyWith(status: OfferStatus.accepted);
        }
        if (o.status == OfferStatus.pending) {
           return o.copyWith(status: OfferStatus.rejected);
        }
        return o;
      }).toList();

      final acceptedOffer = updatedOffers.firstWhere((o) => o.id == offerId);
      
      final updatedListing = listing.copyWith(
        offers: updatedOffers,
        status: ListingStatus.sold, 
        buyerId: acceptedOffer.buyerId,
        buyerName: acceptedOffer.buyerName,
      );

       await updateListing(updatedListing);
    }
  }

  Future<void> rejectOffer(String listingId, String offerId) async {
    final listings = state.listings;
    final index = listings.indexWhere((l) => l.id == listingId);
    if (index != -1) {
      final listing = listings[index];
      final currentOffers = listing.offers ?? [];
      
      final updatedOffers = currentOffers.map((o) {
        if (o.id == offerId) {
          return o.copyWith(status: OfferStatus.rejected);
        }
        return o;
      }).toList();

      final updatedListing = listing.copyWith(offers: updatedOffers);
      await updateListing(updatedListing);
    }
  }
}

final listingNotifierProvider =
    StateNotifierProvider<ListingNotifier, ListingState>((ref) {
  return ListingNotifier(ref.watch(listingRepositoryProvider));
});

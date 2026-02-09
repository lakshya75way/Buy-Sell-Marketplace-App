import '../../domain/entities/listing.dart';
import '../../domain/entities/sort_option.dart';

class ListingFilters {
  final String searchQuery;
  final ListingCategory? category;
  final double? minPrice;
  final double? maxPrice;
  final String? location;
  final ListingCondition? condition;
  final SortOption sortBy;

  ListingFilters({
    this.searchQuery = '',
    this.category,
    this.condition,
    this.minPrice,
    this.maxPrice,
    this.location,
    this.sortBy = SortOption.latest,
  });

  ListingFilters copyWith({
    String? searchQuery,
    ListingCategory? category,
    ListingCondition? condition,
    double? minPrice,
    double? maxPrice,
    String? location,
    SortOption? sortBy,
    bool clearCategory = false,
  }) {
    return ListingFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      category: clearCategory ? null : (category ?? this.category),
      condition: condition ?? this.condition,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      location: location ?? this.location,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

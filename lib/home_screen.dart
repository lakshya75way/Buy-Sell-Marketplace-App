import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/widgets/empty_state.dart';
import 'features/listings/domain/entities/listing.dart';
import 'features/listings/domain/entities/sort_option.dart';
import 'features/listings/presentation/controllers/listing_filters.dart';
import 'features/listings/presentation/controllers/listing_notifier.dart';
import 'features/listings/presentation/widgets/listing_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  ListingFilters _filters = ListingFilters();
  bool _isSearchActive = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _isSearchActive = _filters.searchQuery.isNotEmpty || 
                        _filters.category != null || 
                        _filters.location != null || 
                        _filters.minPrice != null || 
                        _filters.maxPrice != null;
    });
    ref.read(listingNotifierProvider.notifier).loadListings(
      searchQuery: _filters.searchQuery,
      category: _filters.category?.name,
      location: _filters.location,
      condition: _filters.condition,
      minPrice: _filters.minPrice,
      maxPrice: _filters.maxPrice,
      sortBy: _filters.sortBy,
    );
  }

  void _onSearch(String value) {
    _filters = _filters.copyWith(searchQuery: value.trim());
    _applyFilters();
  }

  void _onCategorySelected(ListingCategory category) {
    if (_filters.category == category) {
      _filters = _filters.copyWith(clearCategory: true);
    } else {
      _filters = _filters.copyWith(category: category);
    }
    _applyFilters();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterSheet(
        initialFilters: _filters,
        onApply: (newFilters) {
          setState(() => _filters = newFilters);
          _applyFilters();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listingState = ref.watch(listingNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.only(top: 100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        'Find Amazing Items',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
              title: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearch,
                  decoration: InputDecoration(
                    hintText: 'Search electronics, bikes...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.tune, 
                        size: 20, 
                        color: _filters.location != null || _filters.minPrice != null || _filters.maxPrice != null || _filters.sortBy != SortOption.latest
                          ? theme.colorScheme.primary 
                          : Colors.grey
                      ),
                      onPressed: _showFilterSheet,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ),
              ),
              centerTitle: false,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          if (!_isSearchActive)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Text(
                      'Categories',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: ListingCategory.values.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final category = ListingCategory.values[index];
                        final isSelected = _filters.category == category;
                        return GestureDetector(
                          onTap: () => _onCategorySelected(category),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? theme.colorScheme.primary 
                                      : theme.colorScheme.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getCategoryIcon(category), 
                                  color: isSelected ? Colors.white : theme.colorScheme.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                category.name.toUpperCase(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  color: isSelected ? theme.colorScheme.primary : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          if (_isSearchActive)
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: ListingCategory.values.map((category) {
                    final isSelected = _filters.category == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(category.name.toUpperCase()),
                        selected: isSelected,
                        onSelected: (_) => _onCategorySelected(category),
                        selectedColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                        labelStyle: TextStyle(
                          color: isSelected ? theme.colorScheme.primary : Colors.grey[700],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        checkmarkColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        showCheckmark: false,
                        backgroundColor: Colors.grey[100],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    _isSearchActive ? 'Search Results' : 'Recently Added',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (!_isSearchActive)
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _filters = ListingFilters();
                          _isSearchActive = true;
                        });
                        ref.read(listingNotifierProvider.notifier).loadListings(
                          searchQuery: '',
                          category: null,
                        );
                      },
                      child: const Text('See All'),
                    ),
                ],
              ),
            ),
          ),
          
          if (listingState.status == ListingStateStatus.loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (listingState.listings.isEmpty)
             SliverFillRemaining(
              child: EmptyState(
                icon: Icons.search_off_rounded,
                title: 'No items found',
                message: 'Try adjusting your search or filters.',
                onAction: () {
                  setState(() {
                    _searchController.clear();
                    _filters = ListingFilters();
                    _isSearchActive = false;
                  });
                  ref.read(listingNotifierProvider.notifier).loadListings();
                },
                actionLabel: 'Clear Search',
              ),
            )
          else ...[
            Builder(
              builder: (context) {
                final activeListings = listingState.listings.where((l) => l.status != ListingStatus.sold).toList();
                
                if (activeListings.isEmpty) {
                  return const SliverFillRemaining(
                    child: EmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'No available items',
                      message: 'Check back later for new listings.',
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ListingCard(listing: activeListings[index]),
                        );
                      },
                      childCount: activeListings.length,
                    ),
                  ),
                );
              },
            ),
          ],
            
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create-listing'),
        icon: const Icon(Icons.add),
        label: const Text('Sell Item'),
      ),
    );
  }

  IconData _getCategoryIcon(ListingCategory category) {
    switch (category) {
      case ListingCategory.electronics: return Icons.devices;
      case ListingCategory.fashion: return Icons.checkroom;
      case ListingCategory.home: return Icons.chair;
      case ListingCategory.vehicles: return Icons.directions_car;
      case ListingCategory.sports: return Icons.sports_basketball;
      case ListingCategory.other: return Icons.more_horiz;
    }
  }
}

class _FilterSheet extends StatefulWidget {
  final ListingFilters initialFilters;
  final Function(ListingFilters) onApply;

  const _FilterSheet({required this.initialFilters, required this.onApply});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late ListingFilters _currentFilters;
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentFilters = widget.initialFilters;
    _minPriceController.text = _currentFilters.minPrice?.toStringAsFixed(0) ?? '';
    _maxPriceController.text = _currentFilters.maxPrice?.toStringAsFixed(0) ?? '';
    _locationController.text = _currentFilters.location ?? '';
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentFilters = ListingFilters(searchQuery: _currentFilters.searchQuery);
                    _minPriceController.clear();
                    _maxPriceController.clear();
                    _locationController.clear();
                  });
                },
                child: const Text('Reset All'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          Text('Sort By', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: SortOption.values.map((option) {
              final isSelected = _currentFilters.sortBy == option;
              String label;
              switch(option) {
                case SortOption.latest: label = 'Latest'; break;
                case SortOption.priceAsc: label = 'Price: Low to High'; break;
                case SortOption.priceDesc: label = 'Price: High to Low'; break;
                case SortOption.popularity: label = 'Popular'; break;
              }
              return ChoiceChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) setState(() => _currentFilters = _currentFilters.copyWith(sortBy: option));
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          Text('Location', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: _locationController,
            decoration: const InputDecoration(
              hintText: 'e.g. Mumbai, Bangalore',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            onChanged: (val) => _currentFilters = _currentFilters.copyWith(location: val),
          ),
          const SizedBox(height: 24),

          Text('Item Condition', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: ListingCondition.values.map((condition) {
              final isSelected = _currentFilters.condition == condition;
              return ChoiceChip(
                label: Text(condition.name.toUpperCase()),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _currentFilters = _currentFilters.copyWith(
                    condition: selected ? condition : null,
                  ));
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          Text('Price Range', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minPriceController,
                  decoration: const InputDecoration(hintText: 'Min ₹'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final price = double.tryParse(val);
                    _currentFilters = _currentFilters.copyWith(minPrice: price);
                  },
                ),
              ),
              const SizedBox(width: 16),
              const Text('to'),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _maxPriceController,
                  decoration: const InputDecoration(hintText: 'Max ₹'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final price = double.tryParse(val);
                    _currentFilters = _currentFilters.copyWith(maxPrice: price);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          FilledButton(
            onPressed: () {
              widget.onApply(_currentFilters);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}

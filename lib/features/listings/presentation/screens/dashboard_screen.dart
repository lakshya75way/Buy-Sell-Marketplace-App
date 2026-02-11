import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/navigation_providers.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../auth/presentation/controllers/auth_notifier.dart';
import '../../domain/entities/listing.dart';
import '../controllers/listing_notifier.dart';
import '../widgets/listing_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listings = ref.watch(listingNotifierProvider).listings;
    final favorites = ref.watch(listingNotifierProvider).favorites;
    final user = ref.watch(authNotifierProvider.select((s) => s.user));
    
    final myListings = listings.where((l) => l.sellerId == user?.id).toList();
    final activeListings = myListings.where((l) => l.status == ListingStatus.active).toList();
    final soldListings = myListings.where((l) => l.status == ListingStatus.sold).toList();

    final totalRevenue = soldListings
      .where((l) => l.buyerId != 'MANUAL_SALE')
      .fold<double>(0, (sum, l) => sum + l.price);

    final initialIndex = ref.read(dashboardTabProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('My Dashboard'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                _buildStat(
                  context,
                  label: 'Active',
                  value: activeListings.length.toString(),
                  icon: Icons.storefront,
                ),
                _buildDivider(),
                _buildStat(
                  context,
                  label: 'Sold',
                  value: soldListings.where((l) => l.buyerId != 'MANUAL_SALE').length.toString(),
                  icon: Icons.shopping_bag,
                ),
                _buildDivider(),
                _buildStat(
                  context,
                  label: 'Revenue',
                  value: '₹${totalRevenue >= 1000 ? '${(totalRevenue / 1000).toStringAsFixed(1)}k' : totalRevenue.toStringAsFixed(0)}',
                  icon: Icons.payments,
                  color: Colors.green,
                ),
              ],
            ),
          ),
          
          Expanded(
            child: DefaultTabController(
              initialIndex: initialIndex,
              length: 3,
              child: Builder(
                builder: (context) {
                  return _DashboardContent(
                    activeListings: activeListings,
                    soldListings: soldListings,
                    favorites: favorites,
                  );
                }
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create-listing'),
        icon: const Icon(Icons.add),
        label: const Text('New Listing'),
      ),
    );
  }

  Widget _buildStat(BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    Color? color,
  }) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: color ?? theme.colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade300,
    );
  }
}

class _DashboardContent extends ConsumerWidget {
  final List<Listing> activeListings;
  final List<Listing> soldListings;
  final List<Listing> favorites;

  const _DashboardContent({
    required this.activeListings,
    required this.soldListings,
    required this.favorites,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(dashboardTabProvider, (_, next) {
      final controller = DefaultTabController.of(context);
      if (controller.index != next) {
        controller.animateTo(next);
      }
    });

    return Column(
      children: [
        TabBar(
          isScrollable: false,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          onTap: (index) {
             ref.read(dashboardTabProvider.notifier).state = index;
          },
          tabs: [
            Tab(text: 'Active (${activeListings.length})'),
            Tab(text: 'Sold (${soldListings.length})'),
            Tab(text: 'Saved (${favorites.length})'),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              _ListingList(
                listings: activeListings,
                emptyTitle: 'No active listings',
                emptyMessage: 'List something to start selling!',
                emptyIcon: Icons.storefront_outlined,
              ),
              _ListingList(
                listings: soldListings,
                emptyTitle: 'No sales yet',
                emptyMessage: 'Your sold items will appear here.',
                emptyIcon: Icons.receipt_long_outlined,
              ),
              _ListingList(
                listings: favorites,
                emptyTitle: 'No saved items',
                emptyMessage: 'Items you favorite will show up here.',
                emptyIcon: Icons.favorite_border_rounded,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ListingList extends StatelessWidget {
  final List<Listing> listings;
  final String emptyTitle;
  final String emptyMessage;
  final IconData emptyIcon;

  const _ListingList({
    required this.listings,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.emptyIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (listings.isEmpty) {
      return EmptyState(
        icon: emptyIcon,
        title: emptyTitle,
        message: emptyMessage,
      );
    }
    
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: listings.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return ListingCard(listing: listings[index], allowClickSold: true);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/listing_skeleton.dart';
import '../../../auth/presentation/controllers/auth_notifier.dart';
import '../../domain/entities/listing.dart';
import '../controllers/listing_notifier.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text('Transaction History'),
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            tabs: [
              Tab(text: 'Purchases'),
              Tab(text: 'Sales'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _PurchasesList(),
            _SalesList(),
          ],
        ),
      ),
    );
  }
}

class _PurchasesList extends ConsumerWidget {
  const _PurchasesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listingNotifierProvider);
    final user = ref.read(authNotifierProvider).user;
    final userId = user?.id;
    
    final myPurchases = userId != null 
        ? state.listings.where((l) => l.buyerId == userId && l.status == ListingStatus.sold).toList()
        : <Listing>[];

    if (state.status == ListingStateStatus.loading) {
      return const ListingSkeleton();
    }

    if (myPurchases.isEmpty) {
      return const EmptyState(
        icon: Icons.shopping_bag_outlined,
        title: 'No purchases yet',
        message: 'Start browsing to find great deals!',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: myPurchases.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final purchase = myPurchases[index];
        return _OrderCard(listing: purchase);
      },
    );
  }
}

class _OrderCard extends ConsumerWidget {
  final Listing listing;

  const _OrderCard({required this.listing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy');
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => context.push('/order-details', extra: listing),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 14, color: Colors.green[700]),
                        const SizedBox(width: 4),
                        Text(
                          'COMPLETED',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    dateFormat.format(listing.updatedAt ?? listing.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AppImage(
                      imageUrl: listing.images.isNotEmpty ? listing.images.first : '',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listing.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Seller: ${listing.sellerName}',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹${listing.price.toStringAsFixed(0)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SalesList extends ConsumerWidget {
  const _SalesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listingNotifierProvider);
    final user = ref.read(authNotifierProvider).user;
    final userId = user?.id;

    final mySales = userId != null
        ? state.listings.where((l) => l.sellerId == userId && l.status == ListingStatus.sold).toList()
        : <Listing>[];

    if (state.status == ListingStateStatus.loading) {
      return const ListingSkeleton();
    }

    if (mySales.isEmpty) {
      return const EmptyState(
        icon: Icons.sell_outlined,
        title: 'No sales yet',
        message: 'Create a listing to start selling!',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: mySales.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final sale = mySales[index];
        return _SaleCard(listing: sale);
      },
    );
  }
}

class _SaleCard extends ConsumerWidget {
  final Listing listing;

  const _SaleCard({required this.listing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy');
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => context.push('/sale-details', extra: listing),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sell, size: 14, color: Colors.blue[700]),
                        const SizedBox(width: 4),
                        Text(
                          'SOLD',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    dateFormat.format(listing.updatedAt ?? listing.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AppImage(
                      imageUrl: listing.images.isNotEmpty ? listing.images.first : '',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listing.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Price: ₹${listing.price.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Earning: ₹${listing.price.toStringAsFixed(0)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

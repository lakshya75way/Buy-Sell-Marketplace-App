import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import 'package:assessment_5_flutter/features/auth/presentation/controllers/auth_notifier.dart';
import '../../../../core/widgets/app_image.dart';
import '../../domain/entities/listing.dart';
import '../../presentation/controllers/listing_notifier.dart';

class ListingCard extends ConsumerWidget {
  final Listing listing;
  final VoidCallback? onTap;
  final bool allowClickSold;

  const ListingCard({
    super.key,
    required this.listing,
    this.onTap,
    this.allowClickSold = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(listingNotifierProvider).favorites;
    final user = ref.watch(authNotifierProvider).user;
    final isFavorite = favorites.any((l) => l.id == listing.id);
    final isBuyer = user?.id == listing.buyerId;
    final isSeller = user?.id == listing.sellerId;
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: (listing.status == ListingStatus.sold && !allowClickSold)
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('This item is already sold and no longer available.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            : (onTap ?? () {
                if (listing.status == ListingStatus.sold) {
                  if (isBuyer) {
                    context.push('/order-details', extra: listing);
                    return;
                  } else if (isSeller) {
                    context.push('/sale-details', extra: listing);
                    return;
                  }
                }
                context.push('/listing/${listing.id}', extra: listing);
              }),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: AppImage(
                    imageUrl: listing.images.isNotEmpty ? listing.images.first : '',
                    fit: BoxFit.cover,
                  ),
                ),
                if (listing.status == ListingStatus.sold)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black54,
                      child: Center(
                        child: Transform.rotate(
                          angle: -0.5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              color: (isBuyer || isSeller) ? Colors.green.withValues(alpha: 0.8) : Colors.red.withValues(alpha: 0.8),
                            ),
                            child: Text(
                              isBuyer ? 'PURCHASED' : (isSeller ? 'SOLD' : 'SOLD'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      listing.category.name.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (!isSeller)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: () {
                        ref.read(listingNotifierProvider.notifier).toggleFavorite(listing.id);
                      },
                    ),
                  ),
                Positioned(
                  top: 4,
                  left: isSeller ? 4 : 44,
                  child: IconButton(
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    onPressed: () => _shareListing(listing),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(listing.price),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          listing.location,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatDate(listing.createdAt),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays < 1) {
      return 'Today';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return DateFormat.yMMMd().format(date);
    }
  }

  void _shareListing(Listing listing) {
    SharePlus.instance.share(
      ShareParams(
        text: 'Check out this ${listing.title} for ₹${listing.price.toStringAsFixed(0)} on Marketplace!\n\n'
          'Description: ${listing.description}\n'
          'Location: ${listing.location}\n\n'
          'View it here: marketplace://open/listing/${listing.id}',
      ),
    );
  }
}

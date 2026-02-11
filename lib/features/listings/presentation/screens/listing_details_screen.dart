import 'package:assessment_5_flutter/core/widgets/app_image.dart';
import 'package:assessment_5_flutter/features/auth/presentation/controllers/auth_notifier.dart';
import 'package:assessment_5_flutter/features/chat/presentation/controllers/chat_notifier.dart';
import 'package:assessment_5_flutter/features/listings/domain/entities/listing.dart';
import 'package:assessment_5_flutter/features/listings/domain/entities/offer.dart';
import 'package:assessment_5_flutter/features/listings/presentation/controllers/listing_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ListingDetailsScreen extends ConsumerStatefulWidget {
  final String listingId;
  final Listing? listing;

  const ListingDetailsScreen({super.key, required this.listingId, this.listing});

  @override
  ConsumerState<ListingDetailsScreen> createState() => _ListingDetailsScreenState();
}

class _ListingDetailsScreenState extends ConsumerState<ListingDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final notifier = ref.read(listingNotifierProvider.notifier);
      final listings = ref.read(listingNotifierProvider).listings;
      if (listings.isEmpty) {
        notifier.loadListings();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(listingNotifierProvider).favorites;
    final listings = ref.watch(listingNotifierProvider).listings;
    final state = ref.watch(listingNotifierProvider);
    final theme = Theme.of(context);
    
    final Listing? effectiveListing = widget.listing ?? 
        listings.where((l) => l.id == widget.listingId).firstOrNull ??
        favorites.where((l) => l.id == widget.listingId).firstOrNull;

    if (effectiveListing == null) {
       return Scaffold(
         appBar: AppBar(title: const Text('Details')),
         body: Center(
           child: state.status == ListingStateStatus.loading 
             ? const CircularProgressIndicator()
             : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Listing not found'),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
         ),
       );
    }
    
    final displayListing = effectiveListing;
    final isFavorite = favorites.any((l) => l.id == displayListing.id);
    final user = ref.watch(authNotifierProvider).user;
    final isSeller = user?.id == displayListing.sellerId;
    final isBuyer = user?.id == displayListing.buyerId;

    debugPrint('Rendering ListingDetailsScreen for: ${displayListing.title} (ID: ${displayListing.id}) Status: ${displayListing.status}');

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            backgroundColor: theme.colorScheme.primary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (displayListing.images.isNotEmpty || (displayListing.videos?.isNotEmpty ?? false))
                    PageView.builder(
                      itemCount: displayListing.images.length + (displayListing.videos?.length ?? 0),
                      itemBuilder: (context, index) {
                        final isImage = index < displayListing.images.length;
                        if (isImage) {
                          return AppImage(
                            imageUrl: displayListing.images[index],
                            fit: BoxFit.cover,
                          );
                        } else {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              AppImage(
                                imageUrl: displayListing.images.isNotEmpty ? displayListing.images.first : '',
                                fit: BoxFit.cover,
                              ),
                              Container(color: Colors.black26),
                              const Center(
                                child: Icon(Icons.play_circle_fill, size: 80, color: Colors.white70),
                              ),
                              const Positioned(
                                bottom: 12,
                                left: 12,
                                child: Chip(
                                  label: Text('VIDEO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    )
                  else
                    Container(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      child: Center(
                        child: Icon(Icons.image_outlined, size: 80, color: theme.colorScheme.primary.withValues(alpha: 0.3)),
                      ),
                    ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black45,
                        ],
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              if (!isSeller)
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                      size: 20,
                    ),
                  ),
                  onPressed: () {
                    ref.read(listingNotifierProvider.notifier).toggleFavorite(displayListing.id);
                  },
                ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.share, color: Colors.white, size: 20),
              ),
              onPressed: () => _shareListing(displayListing),
            ),
              const SizedBox(width: 8),
              if (isSeller)
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Listing'),
                        content: const Text('Are you sure you want to delete this listing?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await ref.read(listingNotifierProvider.notifier).deleteListing(displayListing.id);
                              if (context.mounted) context.pop();
                            },
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          displayListing.title,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '₹${displayListing.price.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTag(context, displayListing.condition.name.toUpperCase(), Icons.check_circle_outline),
                      _buildTag(context, displayListing.category.name.toUpperCase(), Icons.category_outlined),
                      if (displayListing.status == ListingStatus.sold)
                        _buildTag(
                          context, 
                          isBuyer ? 'PURCHASED' : (isSeller ? 'SOLD' : 'SOLD'), 
                          isBuyer ? Icons.shopping_bag : Icons.sell, 
                          color: (isBuyer || isSeller) ? Colors.green : Colors.red,
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                   Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.grey[600], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        displayListing.location,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  
                  const Divider(height: 48),
                  
                  if (displayListing.proofOfOwnership != null) ...[
                    Text(
                      'Verification',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.verified_user, color: Colors.blue),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Seller has provided proof of ownership.',
                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blue),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              final proofPath = displayListing.proofOfOwnership;
                              if (proofPath == null) return;

                              final isImage = proofPath.toLowerCase().endsWith('.jpg') || 
                                             proofPath.toLowerCase().endsWith('.jpeg') || 
                                             proofPath.toLowerCase().endsWith('.png');
                              
                              if (isImage) {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog.fullscreen(
                                    child: Scaffold(
                                      appBar: AppBar(
                                        title: const Text('Proof of Ownership'),
                                        leading: IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                      ),
                                      body: Center(
                                        child: InteractiveViewer(
                                          minScale: 0.5,
                                          maxScale: 4.0,
                                          child: AppImage(
                                            imageUrl: proofPath,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                final uri = proofPath.startsWith('http') 
                                    ? Uri.parse(proofPath) 
                                    : Uri.file(proofPath);
                                launchUrl(uri, mode: LaunchMode.externalApplication).catchError((e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Could not open document: $e')),
                                    );
                                  }
                                  return false;
                                });
                              }
                            },
                            child: const Text('View'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    displayListing.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: Colors.grey[800],
                    ),
                  ),

                  if (isBuyer && displayListing.status == ListingStatus.sold) ...[
                    const Divider(height: 64),
                    Text(
                      'Purchase Summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Purchase Date', DateFormat.yMMMd().add_jm().format(displayListing.updatedAt ?? displayListing.createdAt)),
                          const Divider(height: 24),
                          _buildDetailRow('Amount Paid', '₹${displayListing.price.toStringAsFixed(0)}', isBold: true),
                          const Divider(height: 24),
                          _buildDetailRow('Transaction ID', 'TXN-${displayListing.id.length > 8 ? displayListing.id.substring(0, 8).toUpperCase() : displayListing.id.toUpperCase()}'),
                          const Divider(height: 24),
                          _buildDetailRow('Status', 'Success', valueColor: Colors.green[700]),
                        ],
                      ),
                    ),
                  ],

                  const Divider(height: 64),

                  Text(
                    'Seller Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  if (isBuyer && displayListing.status == ListingStatus.sold) ...[
                    _buildContactRow(Icons.email_outlined, 'Email', displayListing.sellerEmail ?? 'Not shared'),
                    const SizedBox(height: 12),
                    _buildContactRow(Icons.phone_outlined, 'Phone', displayListing.sellerPhone ?? 'Not shared'),
                    const SizedBox(height: 24),
                  ],
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        child: Text(
                          displayListing.sellerName.isNotEmpty ? displayListing.sellerName.substring(0, 1).toUpperCase() : '?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayListing.sellerName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              'Member since ${DateFormat.yMMM().format(displayListing.createdAt)}',
                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      if (!isSeller)
                        IconButton.filledTonal(
                          onPressed: () => _contactSeller(context, displayListing),
                          icon: const Icon(Icons.chevron_right),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              if (displayListing.status == ListingStatus.active) ...[
                if (!isSeller) ...[
                  _buildCompactActionButton(
                    context,
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Chat',
                    onTap: () => _contactSeller(context, displayListing),
                  ),
                  const SizedBox(width: 8),
                  _buildCompactActionButton(
                    context,
                    icon: Icons.local_offer_outlined,
                    label: 'Offer',
                    onTap: () => _showMakeOfferDialog(context, displayListing),
                  ),
                  const SizedBox(width: 12),
                ]
                else
                  OutlinedButton.icon(
                    onPressed: () {
                       showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Listing?'),
                              content: const Text('This action cannot be undone.'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                TextButton(
                                  onPressed: () async {
                                    await ref.read(listingNotifierProvider.notifier).deleteListing(displayListing.id);
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      context.pop();
                                    }
                                  },
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text('Delete', style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                const SizedBox(width: 16),
              ] else ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 16),
              ],

              Expanded(
                child: displayListing.status == ListingStatus.active
                    ? FilledButton(
                        onPressed: () {
                           if (isSeller) {
                              context.push('/edit-listing', extra: displayListing);
                            } else {
                              if (user != null) {
                                context.push('/checkout', extra: displayListing);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please login to buy listing')),
                                );
                              }
                            }
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: Text(
                          isSeller ? 'Edit Listing' : 'Buy Now',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: (isBuyer || isSeller) ? Colors.green.withValues(alpha: 0.1) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                          border: (isBuyer || isSeller) ? Border.all(color: Colors.green.withValues(alpha: 0.2)) : null,
                        ),
                        child: Text(
                          isBuyer ? 'ITEM PURCHASED' : (isSeller ? 'ITEM SOLD' : 'SOLD'),
                          style: TextStyle(
                            color: (isBuyer || isSeller) ? Colors.green : Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
              ),
              
              if (isSeller && displayListing.status == ListingStatus.active) ...[
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Mark as Sold?'),
                          content: const Text('This will move the listing to your sold items history.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                            TextButton(
                              onPressed: () async {
                                await ref.read(listingNotifierProvider.notifier).markAsSold(displayListing.id);
                                if (context.mounted) Navigator.pop(context);
                              },
                              child: const Text('Mark as Sold'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.check, color: theme.colorScheme.onPrimaryContainer),
                    tooltip: 'Mark as Sold',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.grey[700]),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildTag(BuildContext context, String label, IconData icon, {Color? color}) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: effectiveColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: effectiveColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: effectiveColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        debugPrint('Could not launch tel:$phoneNumber');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not call $phoneNumber')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching call: $e');
    }
  }

  Future<void> _sendSms(BuildContext context, String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );
     try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
          debugPrint('Could not launch sms:$phoneNumber');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not send SMS to $phoneNumber')),
            );
          }
      }
    } catch (e) {
      debugPrint('Error launching SMS: $e');
    }
  }

  Future<void> _sendEmail(BuildContext context, String email, String subject) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
      },
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        debugPrint('Could not launch mailto:$email');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open email app for $email')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching email: $e');
    }
  }

  void _contactSeller(BuildContext context, Listing listing) {
    if (ref.read(authNotifierProvider).user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to contact the seller')),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Seller',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildContactOption(
                      context,
                      icon: Icons.chat_bubble_rounded,
                      label: 'Chat',
                      color: Theme.of(context).primaryColor,
                      onTap: () => _startAppChat(context, listing),
                    ),
                    _buildContactOption(
                      context,
                      icon: Icons.phone_rounded,
                      label: 'Call',
                      color: Colors.green,
                      onTap: () {
                         Navigator.pop(context);
                         if (listing.sellerPhone != null && listing.sellerPhone!.isNotEmpty) {
                           _makePhoneCall(context, listing.sellerPhone!);
                         } else {
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('Phone number not available')),
                           );
                         }
                      },
                    ),
                    _buildContactOption(
                      context,
                      icon: Icons.message_rounded,
                      label: 'SMS',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pop(context);
                        if (listing.sellerPhone != null && listing.sellerPhone!.isNotEmpty) {
                          _sendSms(context, listing.sellerPhone!);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Phone number not available')),
                          );
                        }
                      },
                    ),
                    _buildContactOption(
                      context,
                      icon: Icons.email_rounded,
                      label: 'Email',
                      color: Colors.orange,
                      onTap: () {
                        Navigator.pop(context);
                        if (listing.sellerEmail != null && listing.sellerEmail!.isNotEmpty) {
                          _sendEmail(context, listing.sellerEmail!, 'Inquiry about ${listing.title}');
                        } else {
                           ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Email not available')),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _startAppChat(BuildContext context, Listing listing) async {
    Navigator.pop(context); // Close modal
    
    try {
      final conversationId = await ref.read(chatNotifierProvider.notifier)
          .startChat(listing.id, listing.sellerId);
      
      if (mounted) {
        if (this.context.mounted) {
          this.context.push('/chat/$conversationId', extra: listing.sellerName);
        }
      }
    } catch (e) {
      if (mounted) {
        if (this.context.mounted) {
          ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(content: Text('Error starting chat: $e')),
          );
        }
      }
    }
  }

  Widget _buildContactOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showMakeOfferDialog(BuildContext context, Listing listing) {
    final amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Make an Offer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Text('Enter your offer amount for ${listing.title}'),
             const SizedBox(height: 16),
             TextField(
               controller: amountController,
               decoration: const InputDecoration(
                 labelText: 'Amount (₹)',
                 prefixText: '₹ ',
                 border: OutlineInputBorder(),
               ),
               keyboardType: const TextInputType.numberWithOptions(decimal: true),
             ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);
              if (amount == null || amount <= 0) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Please enter a valid amount')),
                 );
                 return;
              }

              final user = ref.read(authNotifierProvider).user;
              if (user == null) return;

              final offer = Offer(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                listingId: listing.id,
                buyerId: user.id,
                buyerName: user.name,
                amount: amount,
                timestamp: DateTime.now().millisecondsSinceEpoch,
              );

              await ref.read(listingNotifierProvider.notifier).makeOffer(listing.id, offer);
              
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Offer sent successfully!')),
                );
              }
            },
            child: const Text('Send Offer'),
          ),
        ],
      ),
    );
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
  Widget _buildCompactActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 22),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

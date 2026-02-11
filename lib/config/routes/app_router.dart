import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/controllers/auth_notifier.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/pin_entry_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/chat/presentation/screens/chat_list_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/listings/domain/entities/listing.dart';
import '../../features/listings/presentation/screens/checkout_screen.dart';
import '../../features/listings/presentation/screens/create_listing_screen.dart';
import '../../features/listings/presentation/screens/history_screen.dart';
import '../../features/listings/presentation/screens/listing_details_screen.dart';
import '../../features/listings/presentation/screens/order_details_screen.dart';
import '../../features/listings/presentation/screens/sale_details_screen.dart';
import '../../main_config_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: _AuthStateNotifier(ref),
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final status = authState.status;
      final hasPin = authState.hasPin;
      final isUnlocked = authState.isUnlocked;
      
      final isUnauthenticated = status == AuthStatus.unauthenticated;
      final isAuthenticated = status == AuthStatus.authenticated;
      final isInitial = status == AuthStatus.initial;
      final isLoading = status == AuthStatus.loading;
      
      final currentLoc = state.uri.toString();
      final isLoggingIn = currentLoc == '/login';
      final isRegistering = currentLoc == '/register';
      final isSettingPin = currentLoc == '/pin-setup';
      final isPinLogin = currentLoc == '/pin-login';
      if (isInitial || isLoading) return null;
      if (isUnauthenticated && !isLoggingIn && !isRegistering) {
        return '/login';
      }

      if (isAuthenticated) {
        if (!hasPin && !isSettingPin) {
          return '/pin-setup';
        }
        
        if (hasPin && !isUnlocked && !isPinLogin) {
          return '/pin-login';
        }
        if (isUnlocked && (isLoggingIn || isRegistering || isSettingPin || isPinLogin)) {
          return '/';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/pin-setup',
        builder: (context, state) => const PinEntryScreen(isSetup: true),
      ),
      GoRoute(
        path: '/pin-login',
        builder: (context, state) => const PinEntryScreen(isSetup: false),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const MainConfigScreen(), 
        routes: [
           GoRoute(
            path: 'create-listing',
            builder: (context, state) => const CreateListingScreen(),
          ),
          GoRoute(
            path: 'edit-listing',
            builder: (context, state) {
              final listing = state.extra as Listing?;
              try {
                if (listing == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Unable to load listing for editing'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    context.go('/');
                  });
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                return CreateListingScreen(listing: listing);
              } catch (e) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error loading listing: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  context.go('/');
                });
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
          GoRoute(
            path: 'history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: 'listing/:id',
            builder: (context, state) {
              final listing = state.extra as Listing?;
              final id = state.pathParameters['id']!;
              return ListingDetailsScreen(listingId: id, listing: listing);
             },
          ),
          GoRoute(
            path: 'checkout',
            builder: (context, state) {
              final listing = state.extra as Listing;
              return CheckoutScreen(listing: listing);
             },
          ),
          GoRoute(
            path: 'order-details',
            builder: (context, state) {
              final listing = state.extra as Listing;
              return OrderDetailsScreen(listing: listing);
             },
          ),
          GoRoute(
            path: 'sale-details',
            builder: (context, state) {
              final listing = state.extra as Listing;
              return SaleDetailsScreen(listing: listing);
             },
          ),
          GoRoute(
            path: 'messages',
            builder: (context, state) => const ChatListScreen(),
          ),
          GoRoute(
            path: 'chat/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final otherUserName = state.extra as String?;
              return ChatScreen(conversationId: id, otherUserName: otherUserName);
            },
          ),
        ],
      ),
    ],
  );
}
class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier(this._ref) {
    _ref.listen(authNotifierProvider, (previous, next) {
      notifyListeners();
    });
  }

  final GoRouterRef _ref;
}

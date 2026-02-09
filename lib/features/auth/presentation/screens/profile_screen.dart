import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../../../../core/providers/navigation_providers.dart';
import '../../../shared/services/image_service.dart';
import '../../domain/entities/user.dart';
import '../controllers/auth_notifier.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final theme = Theme.of(context);

    if (user == null) {
      if (authState.status == AuthStatus.unauthenticated) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_off_outlined, size: 64, color: theme.colorScheme.primary),
                const SizedBox(height: 16),
                const Text('Please log in to view your profile'),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  child: const Text('Go to Login'),
                ),
              ],
            ),
          ),
        );
      }
      if (authState.status == AuthStatus.error) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${authState.errorMessage ?? "User session not found"}'),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => ref.read(authNotifierProvider.notifier).checkAuthStatus(),
                  child: const Text('Retry'),
                ),
                TextButton(
                  onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        );
      }
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: _buildProfileImage(user, theme),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                              border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
                            ),
                            child: const Icon(Icons.edit, size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        user.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        user.email,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Settings',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildProfileTile(
                    context,
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    subtitle: 'Manage your name, email, and contact info',
                    onTap: () => _showEditProfileDialog(context, user),
                  ),
                  _buildProfileTile(
                    context,
                    icon: Icons.history_rounded,
                    title: 'My Orders',
                    onTap: () => ref.read(navigationNotifierProvider.notifier).setIndex(1),
                  ),
                  _buildProfileTile(
                    context,
                    icon: Icons.favorite_border_rounded,
                    title: 'Wishlist',
                    onTap: () {
                      ref.read(dashboardTabProvider.notifier).state = 2; // Set to Saved tab
                      ref.read(navigationNotifierProvider.notifier).setIndex(2); // Go to Dashboard
                    },
                  ),
                  _buildProfileTile(
                    context,
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No new notifications')),
                      );
                    },
                  ),
                  
                  const Divider(height: 48),
                  
                  Text(
                    'Support',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildProfileTile(
                    context,
                    icon: Icons.help_outline_rounded,
                    title: 'Help Center',
                    onTap: () {},
                  ),
                   _buildProfileTile(
                    context,
                    icon: Icons.policy_outlined,
                    title: 'Privacy Policy',
                    onTap: () {},
                  ),
                  
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _handleLogout(context),
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Logout'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile(BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: Colors.grey[800]),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  void _showEditProfileDialog(BuildContext context, User user) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phoneNumber ?? '');
    final locationController = TextEditingController(text: user.location ?? '');
    File? pickedImage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 32,
            left: 24,
            right: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Profile',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Image Picker in Modal
                Center(
                  child: Stack(
                    children: [
                      FutureBuilder<ImageProvider?>(
                        future: pickedImage != null 
                            ? Future.value(FileImage(pickedImage!)) 
                            : _getImageProvider(user.profileImage),
                        builder: (context, snapshot) {
                          final imageProvider = snapshot.data;
                          return CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: imageProvider,
                            child: imageProvider == null && user.profileImage == null 
                                ? const Icon(Icons.person, size: 50) 
                                : null,
                          );
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                            onPressed: () async {
                              final picker = ImagePicker();
                              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                              if (image != null) {
                                setModalState(() {
                                  pickedImage = File(image.path);
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                TextFormField(
                  controller: nameController,
                  decoration: _buildInputDecoration(context, 'Full Name', Icons.person_outline),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: _buildInputDecoration(context, 'Email', Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneController,
                  decoration: _buildInputDecoration(context, 'Phone Number', Icons.phone_outlined),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: locationController,
                  decoration: _buildInputDecoration(context, 'Location', Icons.location_on_outlined),
                ),
                const SizedBox(height: 32),
                
                FilledButton(
                  onPressed: () async {
                    String? profileImagePath;
                    if (pickedImage != null) {
                       final imageService = ref.read(imageServiceProvider);
                       profileImagePath = await imageService.uploadImage(pickedImage!);
                    }

                    await ref.read(authNotifierProvider.notifier).updateProfile(
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                      phoneNumber: phoneController.text.trim(),
                      location: locationController.text.trim(),
                      profileImage: profileImagePath,
                    );
                    
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('Save Changes'),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authNotifierProvider.notifier).logout();
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
  InputDecoration _buildInputDecoration(BuildContext context, String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
      ),
    );
  }

  Widget _buildProfileImage(User user, ThemeData theme) {
    return FutureBuilder<ImageProvider?>(
      future: _getImageProvider(user.profileImage),
      builder: (context, snapshot) {
        final imageProvider = snapshot.data;
        return CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey[200],
          backgroundImage: imageProvider,
          child: (imageProvider == null && user.profileImage == null) 
              ? Icon(Icons.person, size: 50, color: theme.colorScheme.primary) 
              : null,
        );
      },
    );
  }

  Future<ImageProvider?> _getImageProvider(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) return null;
    
    // Check if it's a network URL
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    }

    // Remove file:// prefix if present
    final cleanPath = imagePath.replaceFirst('file://', '');
    final file = File(cleanPath);
    
    if (file.existsSync()) {
      return FileImage(file);
    }
    
    // Resolve via filename if absolute path is outdated
    try {
      final fileName = path.basename(cleanPath);
      final appDir = await getApplicationDocumentsDirectory();
      final newPath = path.join(appDir.path, fileName);
      final newFile = File(newPath);
      if (newFile.existsSync()) {
        return FileImage(newFile);
      }
    } catch (_) {}
    
    return null;
  }
}

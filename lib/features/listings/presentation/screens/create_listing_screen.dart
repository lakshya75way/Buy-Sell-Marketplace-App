import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/widgets/app_image.dart';
import '../../../auth/presentation/controllers/auth_notifier.dart';
import '../../../shared/services/image_service.dart';
import '../../domain/entities/listing.dart';
import '../controllers/listing_notifier.dart';

class CreateListingScreen extends ConsumerStatefulWidget {
  final Listing? listing;
  const CreateListingScreen({super.key, this.listing});

  @override
  ConsumerState<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _locationController;
  late ListingCategory _selectedCategory;
  late ListingCondition _selectedCondition;

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = [];
  final List<XFile> _selectedVideos = [];
  PlatformFile? _proofFile;
  
final List<String> _existingImages = [];
  final List<String> _existingVideos = [];
  String? _existingProof;

  @override
  void initState() {
    super.initState();
    final l = widget.listing;
    _titleController = TextEditingController(text: l?.title ?? '');
    _descriptionController = TextEditingController(text: l?.description ?? '');
    _priceController = TextEditingController(text: l?.price != null ? l!.price.toStringAsFixed(0) : '');
    _locationController = TextEditingController(text: l?.location ?? '');
    _selectedCategory = l?.category ?? ListingCategory.electronics;
    _selectedCondition = l?.condition ?? ListingCondition.newCondition;
    
    if (l != null) {
      _existingImages.addAll(l.images);
      _existingVideos.addAll(l.videos ?? []);
      _existingProof = l.proofOfOwnership;
    }
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _selectedVideos.add(video);
      });
    }
  }

  Future<void> _pickProof() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        _proofFile = result.files.first;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = ref.read(authNotifierProvider).user;
        final imageService = ref.read(imageServiceProvider);
        final List<String> newImageUrls = [];
        for (final image in _selectedImages) {
          final url = await imageService.uploadImage(File(image.path));
          newImageUrls.add(url);
        }
        final List<String> newVideoUrls = [];
        for (final video in _selectedVideos) {
          final url = await imageService.uploadImage(File(video.path));
          newVideoUrls.add(url);
        }
        
        String? proofUrl = _existingProof;
        if (_proofFile != null && _proofFile!.path != null) {
          proofUrl = await imageService.uploadImage(File(_proofFile!.path!));
        }

        final listing = Listing(
          id: widget.listing?.id ?? '',
          sellerId: user?.id ?? 'unknown_user',
          sellerName: user?.name ?? 'Unknown Seller',
          sellerEmail: user?.email,
          sellerPhone: user?.phoneNumber,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          price: double.parse(_priceController.text.trim()),
          category: _selectedCategory,
          condition: _selectedCondition,
          images: [..._existingImages, ...newImageUrls].isNotEmpty
              ? [..._existingImages, ...newImageUrls]
              : ['https://img.freepik.com/free-vector/placeholder-concept-illustration_114360-4987.jpg'],
          videos: [..._existingVideos, ...newVideoUrls],
          location: _locationController.text.trim(),
          proofOfOwnership: proofUrl,
          createdAt: widget.listing?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
          status: widget.listing?.status ?? ListingStatus.active,
        );

        if (widget.listing == null) {
          await ref.read(listingNotifierProvider.notifier).createListing(listing);
        } else {
          await ref.read(listingNotifierProvider.notifier).updateListing(listing);
        }
        
        if (mounted) context.pop();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text(widget.listing == null ? 'New Listing' : 'Edit Listing')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Photos',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[200]!, width: 2),
                  ),
                  child: (_selectedImages.isEmpty && _existingImages.isEmpty)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, size: 40, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(height: 8),
                            Text(
                              'Add Photos',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.all(12),
                          itemCount: _existingImages.length + _selectedImages.length + 1,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return _buildAddButton(_pickImages, Icons.add_a_photo);
                            }
                            
                            final displayIndex = index - 1;
                            final isExisting = displayIndex < _existingImages.length;
                            final imageUrl = isExisting ? _existingImages[displayIndex] : null;
                            final imageFile = isExisting ? null : _selectedImages[displayIndex - _existingImages.length];

                            return _buildMediaCard(
                              imageUrl: imageUrl,
                              imageFile: imageFile != null ? File(imageFile.path) : null,
                              onDelete: () {
                                setState(() {
                                  if (isExisting) {
                                    _existingImages.removeAt(displayIndex);
                                  } else {
                                    _selectedImages.removeAt(displayIndex - _existingImages.length);
                                  }
                                });
                              },
                            );
                          },
                        ),
                ),
              ),
              
              const SizedBox(height: 16),
              Text(
                'Videos',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickVideo,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[200]!, width: 2),
                  ),
                  child: (_selectedVideos.isEmpty && _existingVideos.isEmpty)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.video_call_outlined, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Add Video',
                               style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.all(12),
                          itemCount: _existingVideos.length + _selectedVideos.length + 1,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return _buildAddButton(_pickVideo, Icons.video_call);
                            }
                            
                            final displayIndex = index - 1;
                            final isExisting = displayIndex < _existingVideos.length;
                            
                            return _buildMediaCard(
                              isVideo: true,
                              onDelete: () {
                                setState(() {
                                  if (isExisting) {
                                    _existingVideos.removeAt(displayIndex);
                                  } else {
                                    _selectedVideos.removeAt(displayIndex - _existingVideos.length);
                                  }
                                });
                              },
                            );
                          },
                        ),
                ),
              ),
              
              const SizedBox(height: 32),
              Text(
                'Item Details',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'What are you selling?',
                  prefixIcon: Icon(Icons.title),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) =>
                    value != null && value.isNotEmpty ? null : 'Enter a title',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter a price';
                  final price = double.tryParse(value);
                  if (price == null) return 'Enter a valid number';
                  if (price <= 0) return 'Price must be greater than 0';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<ListingCategory>(
                initialValue: _selectedCategory,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: ListingCategory.values.map((c) {
                  return DropdownMenuItem(
                    value: c, 
                    child: Text(c.name.toUpperCase(), overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ListingCondition>(
                initialValue: _selectedCondition,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Condition',
                  prefixIcon: Icon(Icons.star_outline),
                ),
                items: ListingCondition.values.map((c) {
                  return DropdownMenuItem(
                    value: c, 
                    child: Text(c.name.toUpperCase(), overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedCondition = v!),
              ),
              
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe your item in detail...',
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                   if (value == null || value.isEmpty) return 'Enter a description';
                   if (value.length < 10) return 'Description must be at least 10 characters';
                   return null;
                },
              ),
              
              const SizedBox(height: 32),
              Text(
                 'Verification & Location',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                 textCapitalization: TextCapitalization.words,
                validator: (value) =>
                    value != null && value.isNotEmpty ? null : 'Enter location',
              ),
              const SizedBox(height: 16),
              
               Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.verified_user_outlined, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Proof of Ownership',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Optional. Upload a receipt or invoice to increase trust.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blue[600]),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _pickProof,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                        ),
                        child: _proofFile == null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.upload_file, color: Colors.blue[400]),
                                  const SizedBox(width: 8),
                                  Text('Upload Document', style: TextStyle(color: Colors.blue[600])),
                                ],
                              )
                            : Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Icon(
                                    _proofFile!.extension == 'pdf' ? Icons.picture_as_pdf : Icons.image,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      _proofFile!.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.grey),
                                    onPressed: () {
                                      setState(() {
                                        _proofFile = null;
                                      });
                                    },
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                child: Text(widget.listing == null ? 'Post Listing' : 'Save Changes'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(VoidCallback onTap, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  Widget _buildMediaCard({String? imageUrl, File? imageFile, bool isVideo = false, required VoidCallback onDelete}) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: Colors.black12,
              width: double.infinity,
              height: double.infinity,
              child: isVideo
                  ? const Center(child: Icon(Icons.play_circle_fill, size: 32, color: Colors.black54))
                  : (imageUrl != null
                      ? AppImage(imageUrl: imageUrl, fit: BoxFit.cover)
                      : (imageFile != null ? Image.file(imageFile, fit: BoxFit.cover) : const SizedBox())),
            ),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
          if (isVideo)
            const Positioned(
              left: 4,
              bottom: 4,
              child: Icon(Icons.videocam, color: Colors.white, size: 16),
            ),
        ],
      ),
    );
  }
}

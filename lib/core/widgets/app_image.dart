import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class AppImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    
    final isNetwork = imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    final isFile = imageUrl.startsWith('file://') || imageUrl.startsWith('/');
    final cleanPath = imageUrl.replaceFirst('file://', '');
    
    if (isNetwork) {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[100],
          child: const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: Colors.grey[100],
          child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
        ),
      );
    } else if (imageUrl.isNotEmpty) {
      imageWidget = FutureBuilder<File?>(
        future: _resolveLocalFile(cleanPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
             return Container(width: width, height: height, color: Colors.grey[50]);
          }
          final file = snapshot.data;
          if (file != null && file.existsSync()) {
            return Image.file(
              file,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
            );
          }
          return _buildErrorWidget();
        },
      );
    } else {
       imageWidget = _buildPlaceholderWidget();
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }
    return imageWidget;
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[100],
      child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
    );
  }

  Widget _buildPlaceholderWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[100],
      child: const Icon(Icons.image_outlined, color: Colors.grey),
    );
  }

  Future<File?> _resolveLocalFile(String inputPath) async {
    if (inputPath.isEmpty) return null;
    
    final file = File(inputPath);
    if (file.existsSync()) return file;
    
    try {
      final fileName = path.basename(inputPath);
      final appDir = await getApplicationDocumentsDirectory();
      final newPath = path.join(appDir.path, fileName);
      final newFile = File(newPath);
      
      if (newFile.existsSync()) return newFile;
      
      if (newFile.existsSync()) return newFile;
    } catch (_) {}
    
    return null;
  }
}

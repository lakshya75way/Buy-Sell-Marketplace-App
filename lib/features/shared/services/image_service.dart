import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageService {
  Future<String> uploadImage(File file) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(file.path);
      final savedImage = await file.copy('${appDir.path}/$fileName');
      return savedImage.path;
    } catch (e) {
      return file.path;
    }
  }
}

final imageServiceProvider = Provider((ref) => ImageService());

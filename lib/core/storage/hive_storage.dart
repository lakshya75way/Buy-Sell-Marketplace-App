import 'package:hive_flutter/hive_flutter.dart';

class HiveStorage {
  static Future<void> init() async {
    await Hive.initFlutter();
    
    
    
    
    
    await Hive.openBox('favorites');
  }
}

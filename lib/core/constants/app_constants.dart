import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Marketplace App';
  
  // Storage Keys
  static const String authBox = 'authBox';
  static const String listingBox = 'listingBox';
  static const String favoritesBox = 'favoritesBox';
  static const String themeKey = 'isDarkMode';
  
  // API Limits
  static const int defaultPageSize = 20;
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Validation
  static const int minPasswordLength = 6;
  static const int minDescriptionLength = 10;
  
  // Assets
  static const String placeholderImage = 'https://img.freepik.com/free-vector/placeholder-concept-illustration_114360-4987.jpg';
  
  // Colors (if not in theme)
  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;
}

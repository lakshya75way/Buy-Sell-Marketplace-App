import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String name, String phoneNumber, String? profileImage);
  Future<User?> getCurrentUser(String token);
  Future<User> updateProfile(User user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final List<User> _users = [];
  final Map<String, String> _passwords = {};
  
  final _delay = const Duration(seconds: 1);
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/users.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        final Map<String, dynamic> data = json.decode(content);
        final List<dynamic> usersList = data['users'];
        final Map<String, dynamic> passwordsMap = data['passwords'];
        
        _users.clear();
        _users.addAll(usersList.map((u) => User.fromJson(u)).toList());
        _passwords.clear();
        _passwords.addAll(Map<String, String>.from(passwordsMap));
      }
    } catch (e) {
      debugPrint('Error loading users: $e');
    }
    _initialized = true;
  }

  Future<void> _save() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/users.json');
      final data = {
        'users': _users.map((u) => u.toJson()).toList(),
        'passwords': _passwords,
      };
      await file.writeAsString(json.encode(data));
    } catch (e) {
      debugPrint('Error saving users: $e');
    }
  }

  @override
  Future<User> login(String email, String password) async {
    await _init();
    await Future.delayed(_delay);
    try {
      final user = _users.firstWhere(
        (u) => u.email == email,
        orElse: () => throw Exception('User not found'),
      );
      
      if (_passwords[email] != password) {
        throw Exception('Invalid credentials');
      }

      return user;
    } catch (e) {
      throw Exception('Invalid credentials');
    }
  }

  @override
  Future<User> register(String email, String password, String name, String phoneNumber, String? profileImage) async {
    await _init();
    await Future.delayed(_delay);
    if (_users.any((u) => u.email == email)) {
      throw Exception('User already exists');
    }
    final newUser = User(
      id: const Uuid().v4(),
      email: email,
      name: name,
      phoneNumber: phoneNumber,
      profileImage: profileImage ?? 'https://ui-avatars.com/api/?name=$name&background=random&size=256',
    );
    _users.add(newUser);
    _passwords[email] = password;
    await _save();
    return newUser;
  }

  @override
  Future<User?> getCurrentUser(String token) async {
    await _init();
    await Future.delayed(_delay);
    
    if (token.startsWith('mock_token_')) {
      final userId = token.replaceFirst('mock_token_', '');
      try {
        return _users.firstWhere((u) => u.id == userId);
      } catch (e) {
        return null;
      }
    }
    
    return null;
  }

  @override
  Future<User> updateProfile(User user) async {
    await _init();
    await Future.delayed(_delay);
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
      await _save();
      return user;
    }
    
    if (_users.isNotEmpty) {
       _users[_users.length - 1] = user;
       await _save();
       return user;
    }
    return user;
  }
}

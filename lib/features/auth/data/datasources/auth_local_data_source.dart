import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<void> savePin(String pin);
  Future<String?> getPin();
  Future<bool> hasPin();
  Future<bool> canCheckBiometrics();
  Future<bool> authenticateWithBiometrics();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final LocalAuthentication localAuth;

  AuthLocalDataSourceImpl({required this.secureStorage, required this.localAuth});

  static const _tokenKey = 'auth_token';
  static const _pinKey = 'user_pin';

  @override
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: _tokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await secureStorage.delete(key: _tokenKey);
  }

  @override
  Future<void> savePin(String pin) async {
    await secureStorage.write(key: _pinKey, value: pin);
  }

  @override
  Future<String?> getPin() async {
    return await secureStorage.read(key: _pinKey);
  }

  @override
  Future<bool> hasPin() async {
    final pin = await secureStorage.read(key: _pinKey);
    return pin != null && pin.isNotEmpty;
  }

  @override
  Future<bool> canCheckBiometrics() async {
    try {
      return await localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> authenticateWithBiometrics() async {
    try {
      final bool canCheck = await localAuth.canCheckBiometrics;
      final bool isSupported = await localAuth.isDeviceSupported();
      
      if (!canCheck && !isSupported) return false;

      return await localAuth.authenticate(
        localizedReason: 'Please authenticate to access the app',
      );
    } catch (e) {
      debugPrint('Biometric Error: $e');
      return false;
    }
  }
}

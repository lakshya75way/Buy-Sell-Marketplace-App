import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../providers/auth_providers.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  final bool hasPin;
  final bool isUnlocked;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.hasPin = false,
    this.isUnlocked = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool? hasPin,
    bool? isUnlocked,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      hasPin: hasPin ?? this.hasPin,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _repository.getCurrentUser();
    final pinResult = await _repository.isPinSet();
    final hasPin = pinResult.fold((_) => false, (isSet) => isSet);

    result.fold(
      (failure) => state = state.copyWith(status: AuthStatus.unauthenticated, hasPin: hasPin),
      (user) => state = state.copyWith(status: AuthStatus.authenticated, user: user, hasPin: hasPin),
    );
  }

  Timer? _sessionTimer;

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _repository.login(email: email, password: password);
    result.fold(
      (failure) => state = state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      (user) async {
        final pinResult = await _repository.isPinSet();
        final hasPin = pinResult.fold((_) => false, (isSet) => isSet);
        state = state.copyWith(
          status: AuthStatus.authenticated, 
          user: user, 
          hasPin: hasPin,
          isUnlocked: true,
        );
        _startSessionTimer();
      },
    );
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(const Duration(minutes: 30), () {
      logout();
    });
  }

  Future<void> logout() async {
    _sessionTimer?.cancel();
    await _repository.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> register(String email, String password, String name, String phoneNumber, String? profileImagePath) async {
    state = state.copyWith(status: AuthStatus.loading);
    final String? finalProfileImage = profileImagePath;
    
    final result = await _repository.register(
      email: email, 
      password: password, 
      name: name, 
      phoneNumber: phoneNumber,
      profileImage: finalProfileImage,
    );
    
    result.fold(
      (failure) => state = state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      (user) async {
        final pinResult = await _repository.isPinSet();
        final hasPin = pinResult.fold((_) => false, (isSet) => isSet);
        state = state.copyWith(
          status: AuthStatus.authenticated, 
          user: user, 
          hasPin: hasPin,
          isUnlocked: true,
        );
      },
    );
  }


  Future<bool> setPin(String pin) async {
    final result = await _repository.setPin(pin);
    return result.fold(
      (_) => false, 
      (_) {
        state = state.copyWith(hasPin: true, isUnlocked: true);
        return true;
      },
    );
  }

  Future<bool> verifyPin(String pin) async {
    final result = await _repository.verifyPin(pin);
    return result.fold(
      (_) => false, 
      (isValid) {
        if (isValid) {
          state = state.copyWith(isUnlocked: true);
        }
        return isValid;
      },
    );
  }

  Future<bool> checkBiometrics() async {
    final result = await _repository.checkBiometrics();
    return result.fold((_) => false, (isAvailable) => isAvailable);
  }

  Future<bool> authenticateWithBiometrics() async {
    final result = await _repository.authenticateWithBiometrics();
    return result.fold(
      (_) => false, 
      (isAuthenticated) {
        if (isAuthenticated) {
          state = state.copyWith(isUnlocked: true);
        }
        return isAuthenticated;
      },
    );
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phoneNumber,
    required String location,
    String? profileImage,
  }) async {
    if (state.user == null) return;
    
    state = state.copyWith(status: AuthStatus.loading);
    final updatedUser = state.user!.copyWith(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      location: location,
      profileImage: profileImage ?? state.user!.profileImage,
    );
    
    final result = await _repository.updateProfile(updatedUser);
    result.fold(
      (failure) => state = state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      (user) => state = state.copyWith(status: AuthStatus.authenticated, user: user),
    );
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

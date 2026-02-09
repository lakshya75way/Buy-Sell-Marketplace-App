import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, User>> login({required String email, required String password}) async {
    try {
      final user = await remoteDataSource.login(email, password);
      
      await localDataSource.saveToken('mock_token_${user.id}');
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    String? profileImage,
  }) async {
     try {
      final user = await remoteDataSource.register(email, password, name, phoneNumber, profileImage);
      await localDataSource.saveToken('mock_token_${user.id}');
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.deleteToken();
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to logout'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final token = await localDataSource.getToken();
      if (token != null) {
        final user = await remoteDataSource.getCurrentUser(token);
        if (user != null) {
          return Right(user);
        }
      }
      return const Left(AuthFailure('No user logged in'));
    } catch (e) {
      return const Left(AuthFailure('Failed to get current user'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkBiometrics() async {
    try {
      final result = await localDataSource.canCheckBiometrics();
      return Right(result);
    } catch (e) {
      return const Left(CacheFailure('Failed to check biometrics'));
    }
  }

  @override
  Future<Either<Failure, bool>> authenticateWithBiometrics() async {
    try {
      final result = await localDataSource.authenticateWithBiometrics();
      return Right(result);
    } catch (e) {
      return const Left(AuthFailure('Biometric authentication failed'));
    }
  }

  @override
  Future<Either<Failure, void>> setPin(String pin) async {
    try {
      await localDataSource.savePin(pin);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to set PIN'));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyPin(String pin) async {
    try {
      final storedPin = await localDataSource.getPin();
      return Right(storedPin == pin);
    } catch (e) {
      return const Left(CacheFailure('Failed to verify PIN'));
    }
  }

  @override
  Future<Either<Failure, bool>> isPinSet() async {
    try {
      final result = await localDataSource.hasPin();
      return Right(result);
    } catch (e) {
      return const Left(CacheFailure('Failed to check PIN'));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile(User user) async {
    try {
      final updatedUser = await remoteDataSource.updateProfile(user);
      return Right(updatedUser);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

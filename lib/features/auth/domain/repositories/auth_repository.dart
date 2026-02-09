import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({required String email, required String password});
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    String? profileImage,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, bool>> checkBiometrics();
  Future<Either<Failure, bool>> authenticateWithBiometrics();
  Future<Either<Failure, void>> setPin(String pin);
  Future<Either<Failure, bool>> verifyPin(String pin);
  Future<Either<Failure, bool>> isPinSet();
  Future<Either<Failure, User>> updateProfile(User user);
}

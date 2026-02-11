import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    String? profileImage,
    String? phoneNumber,
    String? location, 
    @Default(false) bool isVerified,
    @Default(false) bool isSeller,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

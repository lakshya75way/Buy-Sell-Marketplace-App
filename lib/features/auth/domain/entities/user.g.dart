// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      profileImage: json['profileImage'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      location: json['location'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      isSeller: json['isSeller'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'profileImage': instance.profileImage,
      'phoneNumber': instance.phoneNumber,
      'location': instance.location,
      'isVerified': instance.isVerified,
      'isSeller': instance.isSeller,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
    };

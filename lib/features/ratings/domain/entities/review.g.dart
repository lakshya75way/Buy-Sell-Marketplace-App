// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
      id: json['id'] as String,
      reviewerId: json['reviewerId'] as String,
      reviewerName: json['reviewerName'] as String,
      revieweeId: json['revieweeId'] as String,
      listingId: json['listingId'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
    );

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reviewerId': instance.reviewerId,
      'reviewerName': instance.reviewerName,
      'revieweeId': instance.revieweeId,
      'listingId': instance.listingId,
      'rating': instance.rating,
      'comment': instance.comment,
      'timestamp': instance.timestamp,
    };

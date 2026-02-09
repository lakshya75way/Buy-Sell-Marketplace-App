// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListingImpl _$$ListingImplFromJson(Map<String, dynamic> json) =>
    _$ListingImpl(
      id: json['id'] as String,
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      sellerEmail: json['sellerEmail'] as String?,
      sellerPhone: json['sellerPhone'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: $enumDecode(_$ListingCategoryEnumMap, json['category']),
      condition: $enumDecode(_$ListingConditionEnumMap, json['condition']),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      videos:
          (json['videos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      location: json['location'] as String,
      proofOfOwnership: json['proofOfOwnership'] as String?,
      buyerId: json['buyerId'] as String?,
      buyerName: json['buyerName'] as String?,
      buyerEmail: json['buyerEmail'] as String?,
      status: $enumDecodeNullable(_$ListingStatusEnumMap, json['status']) ??
          ListingStatus.active,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ListingImplToJson(_$ListingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sellerId': instance.sellerId,
      'sellerName': instance.sellerName,
      'sellerEmail': instance.sellerEmail,
      'sellerPhone': instance.sellerPhone,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'category': _$ListingCategoryEnumMap[instance.category]!,
      'condition': _$ListingConditionEnumMap[instance.condition]!,
      'images': instance.images,
      'videos': instance.videos,
      'location': instance.location,
      'proofOfOwnership': instance.proofOfOwnership,
      'buyerId': instance.buyerId,
      'buyerName': instance.buyerName,
      'buyerEmail': instance.buyerEmail,
      'status': _$ListingStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ListingCategoryEnumMap = {
  ListingCategory.electronics: 'electronics',
  ListingCategory.fashion: 'fashion',
  ListingCategory.home: 'home',
  ListingCategory.vehicles: 'vehicles',
  ListingCategory.sports: 'sports',
  ListingCategory.other: 'other',
};

const _$ListingConditionEnumMap = {
  ListingCondition.newCondition: 'newCondition',
  ListingCondition.likeNew: 'likeNew',
  ListingCondition.good: 'good',
  ListingCondition.fair: 'fair',
  ListingCondition.poor: 'poor',
};

const _$ListingStatusEnumMap = {
  ListingStatus.active: 'active',
  ListingStatus.sold: 'sold',
  ListingStatus.reserved: 'reserved',
  ListingStatus.deleted: 'deleted',
};

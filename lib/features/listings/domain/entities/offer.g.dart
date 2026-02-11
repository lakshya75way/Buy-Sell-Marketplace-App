// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OfferImpl _$$OfferImplFromJson(Map<String, dynamic> json) => _$OfferImpl(
      id: json['id'] as String,
      listingId: json['listingId'] as String,
      buyerId: json['buyerId'] as String,
      buyerName: json['buyerName'] as String,
      amount: (json['amount'] as num).toDouble(),
      timestamp: (json['timestamp'] as num).toInt(),
      status: $enumDecodeNullable(_$OfferStatusEnumMap, json['status']) ??
          OfferStatus.pending,
    );

Map<String, dynamic> _$$OfferImplToJson(_$OfferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'listingId': instance.listingId,
      'buyerId': instance.buyerId,
      'buyerName': instance.buyerName,
      'amount': instance.amount,
      'timestamp': instance.timestamp,
      'status': _$OfferStatusEnumMap[instance.status]!,
    };

const _$OfferStatusEnumMap = {
  OfferStatus.pending: 'pending',
  OfferStatus.accepted: 'accepted',
  OfferStatus.rejected: 'rejected',
  OfferStatus.counterDeleted: 'counterDeleted',
};

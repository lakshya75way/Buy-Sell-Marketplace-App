import 'package:freezed_annotation/freezed_annotation.dart';

part 'offer.freezed.dart';
part 'offer.g.dart';

enum OfferStatus { pending, accepted, rejected, counterDeleted }

@freezed
class Offer with _$Offer {
  const factory Offer({
    required String id,
    required String listingId,
    required String buyerId,
    required String buyerName,
    required double amount,
    required int timestamp,
    @Default(OfferStatus.pending) OfferStatus status,
  }) = _Offer;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
}

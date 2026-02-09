import 'package:freezed_annotation/freezed_annotation.dart';

part 'listing.freezed.dart';
part 'listing.g.dart';

enum ListingCondition { newCondition, likeNew, good, fair, poor }
enum ListingCategory { electronics, fashion, home, vehicles, sports, other }
enum ListingStatus { active, sold, reserved, deleted }

@freezed
class Listing with _$Listing {
  const factory Listing({
    required String id,
    required String sellerId,
    required String sellerName,
    String? sellerEmail,
    String? sellerPhone,
    required String title,
    required String description,
    required double price,
    required ListingCategory category,
    required ListingCondition condition,
    required List<String> images,
    List<String>? videos,
    required String location,
    String? proofOfOwnership,
    String? buyerId,
    String? buyerName,
    String? buyerEmail,
    @Default(ListingStatus.active) ListingStatus status,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Listing;

  factory Listing.fromJson(Map<String, dynamic> json) => _$ListingFromJson(json);
}

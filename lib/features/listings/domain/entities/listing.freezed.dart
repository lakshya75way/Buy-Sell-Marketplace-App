// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Listing _$ListingFromJson(Map<String, dynamic> json) {
  return _Listing.fromJson(json);
}

/// @nodoc
mixin _$Listing {
  String get id => throw _privateConstructorUsedError;
  String get sellerId => throw _privateConstructorUsedError;
  String get sellerName => throw _privateConstructorUsedError;
  String? get sellerEmail => throw _privateConstructorUsedError;
  String? get sellerPhone => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  ListingCategory get category => throw _privateConstructorUsedError;
  ListingCondition get condition => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  List<String>? get videos => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String? get proofOfOwnership => throw _privateConstructorUsedError;
  String? get buyerId => throw _privateConstructorUsedError;
  String? get buyerName => throw _privateConstructorUsedError;
  String? get buyerEmail => throw _privateConstructorUsedError;
  ListingStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ListingCopyWith<Listing> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListingCopyWith<$Res> {
  factory $ListingCopyWith(Listing value, $Res Function(Listing) then) =
      _$ListingCopyWithImpl<$Res, Listing>;
  @useResult
  $Res call(
      {String id,
      String sellerId,
      String sellerName,
      String? sellerEmail,
      String? sellerPhone,
      String title,
      String description,
      double price,
      ListingCategory category,
      ListingCondition condition,
      List<String> images,
      List<String>? videos,
      String location,
      String? proofOfOwnership,
      String? buyerId,
      String? buyerName,
      String? buyerEmail,
      ListingStatus status,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ListingCopyWithImpl<$Res, $Val extends Listing>
    implements $ListingCopyWith<$Res> {
  _$ListingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellerId = null,
    Object? sellerName = null,
    Object? sellerEmail = freezed,
    Object? sellerPhone = freezed,
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? category = null,
    Object? condition = null,
    Object? images = null,
    Object? videos = freezed,
    Object? location = null,
    Object? proofOfOwnership = freezed,
    Object? buyerId = freezed,
    Object? buyerName = freezed,
    Object? buyerEmail = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      sellerName: null == sellerName
          ? _value.sellerName
          : sellerName // ignore: cast_nullable_to_non_nullable
              as String,
      sellerEmail: freezed == sellerEmail
          ? _value.sellerEmail
          : sellerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      sellerPhone: freezed == sellerPhone
          ? _value.sellerPhone
          : sellerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ListingCategory,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as ListingCondition,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videos: freezed == videos
          ? _value.videos
          : videos // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      proofOfOwnership: freezed == proofOfOwnership
          ? _value.proofOfOwnership
          : proofOfOwnership // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerId: freezed == buyerId
          ? _value.buyerId
          : buyerId // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerName: freezed == buyerName
          ? _value.buyerName
          : buyerName // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerEmail: freezed == buyerEmail
          ? _value.buyerEmail
          : buyerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ListingStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListingImplCopyWith<$Res> implements $ListingCopyWith<$Res> {
  factory _$$ListingImplCopyWith(
          _$ListingImpl value, $Res Function(_$ListingImpl) then) =
      __$$ListingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String sellerId,
      String sellerName,
      String? sellerEmail,
      String? sellerPhone,
      String title,
      String description,
      double price,
      ListingCategory category,
      ListingCondition condition,
      List<String> images,
      List<String>? videos,
      String location,
      String? proofOfOwnership,
      String? buyerId,
      String? buyerName,
      String? buyerEmail,
      ListingStatus status,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ListingImplCopyWithImpl<$Res>
    extends _$ListingCopyWithImpl<$Res, _$ListingImpl>
    implements _$$ListingImplCopyWith<$Res> {
  __$$ListingImplCopyWithImpl(
      _$ListingImpl _value, $Res Function(_$ListingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellerId = null,
    Object? sellerName = null,
    Object? sellerEmail = freezed,
    Object? sellerPhone = freezed,
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? category = null,
    Object? condition = null,
    Object? images = null,
    Object? videos = freezed,
    Object? location = null,
    Object? proofOfOwnership = freezed,
    Object? buyerId = freezed,
    Object? buyerName = freezed,
    Object? buyerEmail = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ListingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      sellerName: null == sellerName
          ? _value.sellerName
          : sellerName // ignore: cast_nullable_to_non_nullable
              as String,
      sellerEmail: freezed == sellerEmail
          ? _value.sellerEmail
          : sellerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      sellerPhone: freezed == sellerPhone
          ? _value.sellerPhone
          : sellerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ListingCategory,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as ListingCondition,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videos: freezed == videos
          ? _value._videos
          : videos // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      proofOfOwnership: freezed == proofOfOwnership
          ? _value.proofOfOwnership
          : proofOfOwnership // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerId: freezed == buyerId
          ? _value.buyerId
          : buyerId // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerName: freezed == buyerName
          ? _value.buyerName
          : buyerName // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerEmail: freezed == buyerEmail
          ? _value.buyerEmail
          : buyerEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ListingStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListingImpl implements _Listing {
  const _$ListingImpl(
      {required this.id,
      required this.sellerId,
      required this.sellerName,
      this.sellerEmail,
      this.sellerPhone,
      required this.title,
      required this.description,
      required this.price,
      required this.category,
      required this.condition,
      required final List<String> images,
      final List<String>? videos,
      required this.location,
      this.proofOfOwnership,
      this.buyerId,
      this.buyerName,
      this.buyerEmail,
      this.status = ListingStatus.active,
      required this.createdAt,
      this.updatedAt})
      : _images = images,
        _videos = videos;

  factory _$ListingImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListingImplFromJson(json);

  @override
  final String id;
  @override
  final String sellerId;
  @override
  final String sellerName;
  @override
  final String? sellerEmail;
  @override
  final String? sellerPhone;
  @override
  final String title;
  @override
  final String description;
  @override
  final double price;
  @override
  final ListingCategory category;
  @override
  final ListingCondition condition;
  final List<String> _images;
  @override
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<String>? _videos;
  @override
  List<String>? get videos {
    final value = _videos;
    if (value == null) return null;
    if (_videos is EqualUnmodifiableListView) return _videos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String location;
  @override
  final String? proofOfOwnership;
  @override
  final String? buyerId;
  @override
  final String? buyerName;
  @override
  final String? buyerEmail;
  @override
  @JsonKey()
  final ListingStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Listing(id: $id, sellerId: $sellerId, sellerName: $sellerName, sellerEmail: $sellerEmail, sellerPhone: $sellerPhone, title: $title, description: $description, price: $price, category: $category, condition: $condition, images: $images, videos: $videos, location: $location, proofOfOwnership: $proofOfOwnership, buyerId: $buyerId, buyerName: $buyerName, buyerEmail: $buyerEmail, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            (identical(other.sellerName, sellerName) ||
                other.sellerName == sellerName) &&
            (identical(other.sellerEmail, sellerEmail) ||
                other.sellerEmail == sellerEmail) &&
            (identical(other.sellerPhone, sellerPhone) ||
                other.sellerPhone == sellerPhone) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(other._videos, _videos) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.proofOfOwnership, proofOfOwnership) ||
                other.proofOfOwnership == proofOfOwnership) &&
            (identical(other.buyerId, buyerId) || other.buyerId == buyerId) &&
            (identical(other.buyerName, buyerName) ||
                other.buyerName == buyerName) &&
            (identical(other.buyerEmail, buyerEmail) ||
                other.buyerEmail == buyerEmail) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        sellerId,
        sellerName,
        sellerEmail,
        sellerPhone,
        title,
        description,
        price,
        category,
        condition,
        const DeepCollectionEquality().hash(_images),
        const DeepCollectionEquality().hash(_videos),
        location,
        proofOfOwnership,
        buyerId,
        buyerName,
        buyerEmail,
        status,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListingImplCopyWith<_$ListingImpl> get copyWith =>
      __$$ListingImplCopyWithImpl<_$ListingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListingImplToJson(
      this,
    );
  }
}

abstract class _Listing implements Listing {
  const factory _Listing(
      {required final String id,
      required final String sellerId,
      required final String sellerName,
      final String? sellerEmail,
      final String? sellerPhone,
      required final String title,
      required final String description,
      required final double price,
      required final ListingCategory category,
      required final ListingCondition condition,
      required final List<String> images,
      final List<String>? videos,
      required final String location,
      final String? proofOfOwnership,
      final String? buyerId,
      final String? buyerName,
      final String? buyerEmail,
      final ListingStatus status,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$ListingImpl;

  factory _Listing.fromJson(Map<String, dynamic> json) = _$ListingImpl.fromJson;

  @override
  String get id;
  @override
  String get sellerId;
  @override
  String get sellerName;
  @override
  String? get sellerEmail;
  @override
  String? get sellerPhone;
  @override
  String get title;
  @override
  String get description;
  @override
  double get price;
  @override
  ListingCategory get category;
  @override
  ListingCondition get condition;
  @override
  List<String> get images;
  @override
  List<String>? get videos;
  @override
  String get location;
  @override
  String? get proofOfOwnership;
  @override
  String? get buyerId;
  @override
  String? get buyerName;
  @override
  String? get buyerEmail;
  @override
  ListingStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ListingImplCopyWith<_$ListingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

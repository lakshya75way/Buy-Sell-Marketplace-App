// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  String get id => throw _privateConstructorUsedError;
  String get conversationId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get receiverId => throw _privateConstructorUsedError;
  String get listingId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
          ChatMessage value, $Res Function(ChatMessage) then) =
      _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call(
      {String id,
      String conversationId,
      String senderId,
      String receiverId,
      String listingId,
      String content,
      int timestamp,
      bool isRead});
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = null,
    Object? receiverId = null,
    Object? listingId = null,
    Object? content = null,
    Object? timestamp = null,
    Object? isRead = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
      listingId: null == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
          _$ChatMessageImpl value, $Res Function(_$ChatMessageImpl) then) =
      __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String conversationId,
      String senderId,
      String receiverId,
      String listingId,
      String content,
      int timestamp,
      bool isRead});
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
      _$ChatMessageImpl _value, $Res Function(_$ChatMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = null,
    Object? receiverId = null,
    Object? listingId = null,
    Object? content = null,
    Object? timestamp = null,
    Object? isRead = null,
  }) {
    return _then(_$ChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
      listingId: null == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl(
      {required this.id,
      required this.conversationId,
      required this.senderId,
      required this.receiverId,
      required this.listingId,
      required this.content,
      required this.timestamp,
      this.isRead = false});

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String conversationId;
  @override
  final String senderId;
  @override
  final String receiverId;
  @override
  final String listingId;
  @override
  final String content;
  @override
  final int timestamp;
  @override
  @JsonKey()
  final bool isRead;

  @override
  String toString() {
    return 'ChatMessage(id: $id, conversationId: $conversationId, senderId: $senderId, receiverId: $receiverId, listingId: $listingId, content: $content, timestamp: $timestamp, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.listingId, listingId) ||
                other.listingId == listingId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isRead, isRead) || other.isRead == isRead));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, conversationId, senderId,
      receiverId, listingId, content, timestamp, isRead);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(
      this,
    );
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage(
      {required final String id,
      required final String conversationId,
      required final String senderId,
      required final String receiverId,
      required final String listingId,
      required final String content,
      required final int timestamp,
      final bool isRead}) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get conversationId;
  @override
  String get senderId;
  @override
  String get receiverId;
  @override
  String get listingId;
  @override
  String get content;
  @override
  int get timestamp;
  @override
  bool get isRead;
  @override
  @JsonKey(ignore: true)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatConversation _$ChatConversationFromJson(Map<String, dynamic> json) {
  return _ChatConversation.fromJson(json);
}

/// @nodoc
mixin _$ChatConversation {
  String get id => throw _privateConstructorUsedError;
  String get listingId => throw _privateConstructorUsedError;
  String get buyerId => throw _privateConstructorUsedError;
  String get sellerId => throw _privateConstructorUsedError;
  String get lastMessage => throw _privateConstructorUsedError;
  int get lastMessageTimestamp => throw _privateConstructorUsedError;
  int get unreadCount =>
      throw _privateConstructorUsedError; // UI convenience fields (would be populated by joining data)
  String? get listingTitle => throw _privateConstructorUsedError;
  String? get listingImage => throw _privateConstructorUsedError;
  String? get otherUserName => throw _privateConstructorUsedError;
  String? get otherUserImage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatConversationCopyWith<ChatConversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatConversationCopyWith<$Res> {
  factory $ChatConversationCopyWith(
          ChatConversation value, $Res Function(ChatConversation) then) =
      _$ChatConversationCopyWithImpl<$Res, ChatConversation>;
  @useResult
  $Res call(
      {String id,
      String listingId,
      String buyerId,
      String sellerId,
      String lastMessage,
      int lastMessageTimestamp,
      int unreadCount,
      String? listingTitle,
      String? listingImage,
      String? otherUserName,
      String? otherUserImage});
}

/// @nodoc
class _$ChatConversationCopyWithImpl<$Res, $Val extends ChatConversation>
    implements $ChatConversationCopyWith<$Res> {
  _$ChatConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? listingId = null,
    Object? buyerId = null,
    Object? sellerId = null,
    Object? lastMessage = null,
    Object? lastMessageTimestamp = null,
    Object? unreadCount = null,
    Object? listingTitle = freezed,
    Object? listingImage = freezed,
    Object? otherUserName = freezed,
    Object? otherUserImage = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      listingId: null == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String,
      buyerId: null == buyerId
          ? _value.buyerId
          : buyerId // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageTimestamp: null == lastMessageTimestamp
          ? _value.lastMessageTimestamp
          : lastMessageTimestamp // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      listingTitle: freezed == listingTitle
          ? _value.listingTitle
          : listingTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      listingImage: freezed == listingImage
          ? _value.listingImage
          : listingImage // ignore: cast_nullable_to_non_nullable
              as String?,
      otherUserName: freezed == otherUserName
          ? _value.otherUserName
          : otherUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      otherUserImage: freezed == otherUserImage
          ? _value.otherUserImage
          : otherUserImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatConversationImplCopyWith<$Res>
    implements $ChatConversationCopyWith<$Res> {
  factory _$$ChatConversationImplCopyWith(_$ChatConversationImpl value,
          $Res Function(_$ChatConversationImpl) then) =
      __$$ChatConversationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String listingId,
      String buyerId,
      String sellerId,
      String lastMessage,
      int lastMessageTimestamp,
      int unreadCount,
      String? listingTitle,
      String? listingImage,
      String? otherUserName,
      String? otherUserImage});
}

/// @nodoc
class __$$ChatConversationImplCopyWithImpl<$Res>
    extends _$ChatConversationCopyWithImpl<$Res, _$ChatConversationImpl>
    implements _$$ChatConversationImplCopyWith<$Res> {
  __$$ChatConversationImplCopyWithImpl(_$ChatConversationImpl _value,
      $Res Function(_$ChatConversationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? listingId = null,
    Object? buyerId = null,
    Object? sellerId = null,
    Object? lastMessage = null,
    Object? lastMessageTimestamp = null,
    Object? unreadCount = null,
    Object? listingTitle = freezed,
    Object? listingImage = freezed,
    Object? otherUserName = freezed,
    Object? otherUserImage = freezed,
  }) {
    return _then(_$ChatConversationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      listingId: null == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as String,
      buyerId: null == buyerId
          ? _value.buyerId
          : buyerId // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageTimestamp: null == lastMessageTimestamp
          ? _value.lastMessageTimestamp
          : lastMessageTimestamp // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      listingTitle: freezed == listingTitle
          ? _value.listingTitle
          : listingTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      listingImage: freezed == listingImage
          ? _value.listingImage
          : listingImage // ignore: cast_nullable_to_non_nullable
              as String?,
      otherUserName: freezed == otherUserName
          ? _value.otherUserName
          : otherUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      otherUserImage: freezed == otherUserImage
          ? _value.otherUserImage
          : otherUserImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatConversationImpl implements _ChatConversation {
  const _$ChatConversationImpl(
      {required this.id,
      required this.listingId,
      required this.buyerId,
      required this.sellerId,
      required this.lastMessage,
      required this.lastMessageTimestamp,
      this.unreadCount = 0,
      this.listingTitle,
      this.listingImage,
      this.otherUserName,
      this.otherUserImage});

  factory _$ChatConversationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatConversationImplFromJson(json);

  @override
  final String id;
  @override
  final String listingId;
  @override
  final String buyerId;
  @override
  final String sellerId;
  @override
  final String lastMessage;
  @override
  final int lastMessageTimestamp;
  @override
  @JsonKey()
  final int unreadCount;
// UI convenience fields (would be populated by joining data)
  @override
  final String? listingTitle;
  @override
  final String? listingImage;
  @override
  final String? otherUserName;
  @override
  final String? otherUserImage;

  @override
  String toString() {
    return 'ChatConversation(id: $id, listingId: $listingId, buyerId: $buyerId, sellerId: $sellerId, lastMessage: $lastMessage, lastMessageTimestamp: $lastMessageTimestamp, unreadCount: $unreadCount, listingTitle: $listingTitle, listingImage: $listingImage, otherUserName: $otherUserName, otherUserImage: $otherUserImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatConversationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.listingId, listingId) ||
                other.listingId == listingId) &&
            (identical(other.buyerId, buyerId) || other.buyerId == buyerId) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageTimestamp, lastMessageTimestamp) ||
                other.lastMessageTimestamp == lastMessageTimestamp) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.listingTitle, listingTitle) ||
                other.listingTitle == listingTitle) &&
            (identical(other.listingImage, listingImage) ||
                other.listingImage == listingImage) &&
            (identical(other.otherUserName, otherUserName) ||
                other.otherUserName == otherUserName) &&
            (identical(other.otherUserImage, otherUserImage) ||
                other.otherUserImage == otherUserImage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      listingId,
      buyerId,
      sellerId,
      lastMessage,
      lastMessageTimestamp,
      unreadCount,
      listingTitle,
      listingImage,
      otherUserName,
      otherUserImage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatConversationImplCopyWith<_$ChatConversationImpl> get copyWith =>
      __$$ChatConversationImplCopyWithImpl<_$ChatConversationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatConversationImplToJson(
      this,
    );
  }
}

abstract class _ChatConversation implements ChatConversation {
  const factory _ChatConversation(
      {required final String id,
      required final String listingId,
      required final String buyerId,
      required final String sellerId,
      required final String lastMessage,
      required final int lastMessageTimestamp,
      final int unreadCount,
      final String? listingTitle,
      final String? listingImage,
      final String? otherUserName,
      final String? otherUserImage}) = _$ChatConversationImpl;

  factory _ChatConversation.fromJson(Map<String, dynamic> json) =
      _$ChatConversationImpl.fromJson;

  @override
  String get id;
  @override
  String get listingId;
  @override
  String get buyerId;
  @override
  String get sellerId;
  @override
  String get lastMessage;
  @override
  int get lastMessageTimestamp;
  @override
  int get unreadCount;
  @override // UI convenience fields (would be populated by joining data)
  String? get listingTitle;
  @override
  String? get listingImage;
  @override
  String? get otherUserName;
  @override
  String? get otherUserImage;
  @override
  @JsonKey(ignore: true)
  _$$ChatConversationImplCopyWith<_$ChatConversationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

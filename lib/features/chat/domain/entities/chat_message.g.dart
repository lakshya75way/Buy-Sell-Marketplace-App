// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      listingId: json['listingId'] as String,
      content: json['content'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'listingId': instance.listingId,
      'content': instance.content,
      'timestamp': instance.timestamp,
      'isRead': instance.isRead,
    };

_$ChatConversationImpl _$$ChatConversationImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatConversationImpl(
      id: json['id'] as String,
      listingId: json['listingId'] as String,
      buyerId: json['buyerId'] as String,
      sellerId: json['sellerId'] as String,
      lastMessage: json['lastMessage'] as String,
      lastMessageTimestamp: (json['lastMessageTimestamp'] as num).toInt(),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      listingTitle: json['listingTitle'] as String?,
      listingImage: json['listingImage'] as String?,
      otherUserName: json['otherUserName'] as String?,
      otherUserImage: json['otherUserImage'] as String?,
    );

Map<String, dynamic> _$$ChatConversationImplToJson(
        _$ChatConversationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'listingId': instance.listingId,
      'buyerId': instance.buyerId,
      'sellerId': instance.sellerId,
      'lastMessage': instance.lastMessage,
      'lastMessageTimestamp': instance.lastMessageTimestamp,
      'unreadCount': instance.unreadCount,
      'listingTitle': instance.listingTitle,
      'listingImage': instance.listingImage,
      'otherUserName': instance.otherUserName,
      'otherUserImage': instance.otherUserImage,
    };

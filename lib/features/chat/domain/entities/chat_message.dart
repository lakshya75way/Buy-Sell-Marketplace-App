import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String listingId,
    required String content,
    required int timestamp,
    @Default(false) bool isRead,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}

@freezed
class ChatConversation with _$ChatConversation {
  const factory ChatConversation({
    required String id,
    required String listingId,
    required String buyerId,
    required String sellerId,
    required String lastMessage,
    required int lastMessageTimestamp,
    @Default(0) int unreadCount,
    
    // UI convenience fields (would be populated by joining data)
    String? listingTitle,
    String? listingImage,
    String? otherUserName,
    String? otherUserImage,
  }) = _ChatConversation;

  factory ChatConversation.fromJson(Map<String, dynamic> json) => _$ChatConversationFromJson(json);
}

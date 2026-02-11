import '../entities/chat_message.dart';

abstract class ChatRepository {
  Future<List<ChatConversation>> getConversations();
  Future<List<ChatMessage>> getMessages(String conversationId);
  Future<void> sendMessage(ChatMessage message);
  Future<String> startConversation(String listingId, String sellerId);
  Stream<List<ChatMessage>> getMessageStream(String conversationId);
}

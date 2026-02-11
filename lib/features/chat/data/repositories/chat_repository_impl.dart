import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl();
});

class ChatRepositoryImpl implements ChatRepository {
  // Mock In-Memory Storage
  final List<ChatConversation> _conversations = [];
  final Map<String, List<ChatMessage>> _messages = {};
  final _messageControllers = <String, StreamController<List<ChatMessage>>>{};

  ChatRepositoryImpl() {
    _seedData();
  }

  void _seedData() {
    // Optional: Add some mock data for testing
  }

  @override
  Future<List<ChatConversation>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate latency
    return _conversations;
  }

  @override
  Future<List<ChatMessage>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _messages[conversationId] ?? [];
  }

  @override
  Future<void> sendMessage(ChatMessage message) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final conversationId = message.conversationId;
    
    // Add message
    if (!_messages.containsKey(conversationId)) {
      _messages[conversationId] = [];
    }
    _messages[conversationId]!.add(message);

    // Update conversation last message
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final oldConv = _conversations[index];
      _conversations[index] = oldConv.copyWith(
        lastMessage: message.content,
        lastMessageTimestamp: message.timestamp,
      );
    }

    // Notify stream listeners
    if (_messageControllers.containsKey(conversationId)) {
      _messageControllers[conversationId]!.add(_messages[conversationId]!);
    }
  }

  @override
  Future<String> startConversation(String listingId, String sellerId) async {
    // Check if conversation already exists
    // In a real app, we'd check for existing (listingId, buyerId, sellerId) tuple
    // For this mock, we'll just create a new one every time or return existing if found
    final existingIndex = _conversations.indexWhere((c) => c.listingId == listingId && c.sellerId == sellerId);
    if (existingIndex != -1) {
      return _conversations[existingIndex].id;
    }

    final newId = const Uuid().v4();
    final newConversation = ChatConversation(
      id: newId,
      listingId: listingId,
      buyerId: 'CURRENT_USER_ID', // Replaced in Notifier
      sellerId: sellerId,
      lastMessage: 'Started conversation',
      lastMessageTimestamp: DateTime.now().millisecondsSinceEpoch,
    );
    
    _conversations.add(newConversation);
    _messages[newId] = [];
    
    return newId;
  }

  @override
  Stream<List<ChatMessage>> getMessageStream(String conversationId) {
    if (!_messageControllers.containsKey(conversationId)) {
      _messageControllers[conversationId] = StreamController<List<ChatMessage>>.broadcast();
       // Push initial data
       if (_messages.containsKey(conversationId)) {
         _messageControllers[conversationId]!.add(_messages[conversationId]!);
       }
    }
    return _messageControllers[conversationId]!.stream;
  }
}

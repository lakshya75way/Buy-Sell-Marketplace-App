import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/controllers/auth_notifier.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_message.dart';

part 'chat_notifier.g.dart';

@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  FutureOr<List<ChatConversation>> build() async {
    return ref.read(chatRepositoryProvider).getConversations();
  }

  Future<String> startChat(String listingId, String sellerId) async {
    final user = ref.read(authNotifierProvider).user;
    if (user == null) throw Exception('User not logged in');
    
    final repo = ref.read(chatRepositoryProvider);
    
    // Optimistically checking if conversation exists in current state
    final currentList = state.valueOrNull ?? [];
    final existing = currentList.where(
      (c) => c.listingId == listingId && (c.sellerId == sellerId || c.buyerId == sellerId)
    ).firstOrNull;

    if (existing != null) return existing.id;

    final newId = await repo.startConversation(listingId, sellerId);
    
    // Refresh the list
    ref.invalidateSelf(); 
    
    return newId;
  }

  Future<void> sendMessage(String conversationId, String content) async {
    final user = ref.read(authNotifierProvider).user;
    if (user == null) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: conversationId,
      senderId: user.id,
      receiverId: 'RECEIVER_ID_PLACEHOLDER', // In real app, derived from conversation
      listingId: 'LISTING_ID_PLACEHOLDER',
      content: content,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    await ref.read(chatRepositoryProvider).sendMessage(message);
    // Refreshing isn't strictly necessary if we rely on a separate stream for messages,
    // but useful for updating the "last message" snippet in the list.
    ref.invalidateSelf();
  }
}

@riverpod
Stream<List<ChatMessage>> conversationMessages(ConversationMessagesRef ref, String conversationId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getMessageStream(conversationId);
}

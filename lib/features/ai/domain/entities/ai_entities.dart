/// Conversation entity for AI chat
class ConversationEntity {
  final String id;
  final String userId;
  final String title;
  final List<MessageEntity> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ConversationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  ConversationEntity copyWith({
    String? id,
    String? userId,
    String? title,
    List<MessageEntity>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConversationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Message entity for AI conversation
class MessageEntity {
  final String id;
  final String conversationId;
  final String sender; // 'user' or 'ai'
  final String content;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.content,
    required this.timestamp,
    this.metadata,
  });

  MessageEntity copyWith({
    String? id,
    String? conversationId,
    String? sender,
    String? content,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'sender': sender,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }
}

/// AI Response entity
class AiResponseEntity {
  final String content;
  final String conversationId;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  const AiResponseEntity({
    required this.content,
    required this.conversationId,
    this.metadata,
    required this.timestamp,
  });
}

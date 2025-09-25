import '../../domain/entities/ai_entities.dart';

/// Conversation model
class ConversationModel extends ConversationEntity {
  const ConversationModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.messages,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? 'New Conversation',
      messages: (json['messages'] as List<dynamic>?)
          ?.map((msg) => MessageModel.fromMap(msg))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'messages': messages.map((msg) => (msg as MessageModel).toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Message model
class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.conversationId,
    required super.sender,
    required super.content,
    required super.timestamp,
    super.metadata,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      conversationId: map['conversationId'] ?? '',
      sender: map['sender'] ?? 'user',
      content: map['content'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      metadata: map['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversationId': conversationId,
      'sender': sender,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  Map<String, dynamic> toJson() => toMap();
}

/// AI Response model
class AiResponseModel {
  final String content;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  const AiResponseModel({
    required this.content,
    this.metadata,
    required this.timestamp,
  });

  factory AiResponseModel.fromMap(Map<String, dynamic> map) {
    return AiResponseModel(
      content: map['content'] ?? '',
      metadata: map['metadata'],
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
}

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

/// Translation entity
class TranslationEntity {
  final String id;
  final String userId;
  final String sourceText;
  final String sourceLanguage;
  final String targetText;
  final String targetLanguage;
  final double confidence;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const TranslationEntity({
    required this.id,
    required this.userId,
    required this.sourceText,
    required this.sourceLanguage,
    required this.targetText,
    required this.targetLanguage,
    required this.confidence,
    required this.createdAt,
    this.metadata,
  });

  TranslationEntity copyWith({
    String? id,
    String? userId,
    String? sourceText,
    String? sourceLanguage,
    String? targetText,
    String? targetLanguage,
    double? confidence,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return TranslationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sourceText: sourceText ?? this.sourceText,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetText: targetText ?? this.targetText,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      confidence: confidence ?? this.confidence,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Pronunciation assessment entity
class PronunciationAssessmentEntity {
  final String id;
  final String userId;
  final String word;
  final String language;
  final String audioUrl;
  final double score; // 0.0 to 1.0
  final String feedback;
  final List<PronunciationIssue> issues;
  final DateTime assessedAt;
  final Map<String, dynamic>? metadata;

  const PronunciationAssessmentEntity({
    required this.id,
    required this.userId,
    required this.word,
    required this.language,
    required this.audioUrl,
    required this.score,
    required this.feedback,
    required this.issues,
    required this.assessedAt,
    this.metadata,
  });

  PronunciationAssessmentEntity copyWith({
    String? id,
    String? userId,
    String? word,
    String? language,
    String? audioUrl,
    double? score,
    String? feedback,
    List<PronunciationIssue>? issues,
    DateTime? assessedAt,
    Map<String, dynamic>? metadata,
  }) {
    return PronunciationAssessmentEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      word: word ?? this.word,
      language: language ?? this.language,
      audioUrl: audioUrl ?? this.audioUrl,
      score: score ?? this.score,
      feedback: feedback ?? this.feedback,
      issues: issues ?? this.issues,
      assessedAt: assessedAt ?? this.assessedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Pronunciation issue details
class PronunciationIssue {
  final String type; // 'tone', 'consonant', 'vowel', 'stress'
  final String description;
  final double severity; // 0.0 to 1.0
  final String suggestion;

  const PronunciationIssue({
    required this.type,
    required this.description,
    required this.severity,
    required this.suggestion,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'description': description,
      'severity': severity,
      'suggestion': suggestion,
    };
  }

  factory PronunciationIssue.fromJson(Map<String, dynamic> json) {
    return PronunciationIssue(
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      severity: (json['severity'] ?? 0.0).toDouble(),
      suggestion: json['suggestion'] ?? '',
    );
  }
}

/// Content generation entity
class ContentGenerationEntity {
  final String id;
  final String userId;
  final String type; // 'lesson', 'exercise', 'story', 'dialogue'
  final String topic;
  final String language;
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  final String generatedContent;
  final List<String> tags;
  final DateTime generatedAt;
  final Map<String, dynamic>? metadata;

  const ContentGenerationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.topic,
    required this.language,
    required this.difficulty,
    required this.generatedContent,
    required this.tags,
    required this.generatedAt,
    this.metadata,
  });

  ContentGenerationEntity copyWith({
    String? id,
    String? userId,
    String? type,
    String? topic,
    String? language,
    String? difficulty,
    String? generatedContent,
    List<String>? tags,
    DateTime? generatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return ContentGenerationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      topic: topic ?? this.topic,
      language: language ?? this.language,
      difficulty: difficulty ?? this.difficulty,
      generatedContent: generatedContent ?? this.generatedContent,
      tags: tags ?? this.tags,
      generatedAt: generatedAt ?? this.generatedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// AI Learning Recommendation entity
class AiLearningRecommendationEntity {
  final String id;
  final String userId;
  final String type; // 'vocabulary', 'grammar', 'pronunciation', 'practice'
  final String title;
  final String description;
  final String reason;
  final int priority; // 1-5, higher is more important
  final bool isCompleted;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const AiLearningRecommendationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    required this.reason,
    required this.priority,
    required this.isCompleted,
    required this.createdAt,
    this.metadata,
  });

  AiLearningRecommendationEntity copyWith({
    String? id,
    String? userId,
    String? type,
    String? title,
    String? description,
    String? reason,
    int? priority,
    bool? isCompleted,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return AiLearningRecommendationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      reason: reason ?? this.reason,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

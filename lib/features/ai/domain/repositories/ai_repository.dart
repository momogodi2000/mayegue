import 'package:dartz/dartz.dart';
import '../entities/ai_entities.dart';
import '../../../../core/errors/failures.dart';

/// Abstract repository for AI operations
abstract class AiRepository {
  /// Start a new conversation
  Future<Either<Failure, ConversationEntity>> startConversation({
    required String userId,
    required String title,
  });

  /// Send message to AI
  Future<Either<Failure, AiResponseEntity>> sendMessage({
    required String conversationId,
    required String message,
    required String userId,
  });

  /// Get conversation history
  Future<Either<Failure, ConversationEntity>> getConversation(String conversationId);

  /// Get user conversations
  Future<Either<Failure, List<ConversationEntity>>> getUserConversations(String userId);

  /// Delete conversation
  Future<Either<Failure, bool>> deleteConversation(String conversationId);

  /// Get AI recommendations for user
  Future<Either<Failure, List<String>>> getRecommendations(String userId);

  /// Translate text between languages
  Future<Either<Failure, TranslationEntity>> translateText({
    required String userId,
    required String sourceText,
    required String sourceLanguage,
    required String targetLanguage,
  });

  /// Assess pronunciation from audio
  Future<Either<Failure, PronunciationAssessmentEntity>> assessPronunciation({
    required String userId,
    required String word,
    required String language,
    required String audioUrl,
  });

  /// Generate learning content
  Future<Either<Failure, ContentGenerationEntity>> generateContent({
    required String userId,
    required String type,
    required String topic,
    required String language,
    required String difficulty,
  });

  /// Get personalized learning recommendations
  Future<Either<Failure, List<AiLearningRecommendationEntity>>> getPersonalizedRecommendations(String userId);

  /// Save translation history
  Future<Either<Failure, bool>> saveTranslation(TranslationEntity translation);

  /// Get translation history
  Future<Either<Failure, List<TranslationEntity>>> getTranslationHistory(String userId);

  /// Save pronunciation assessment
  Future<Either<Failure, bool>> savePronunciationAssessment(PronunciationAssessmentEntity assessment);

  /// Get pronunciation history
  Future<Either<Failure, List<PronunciationAssessmentEntity>>> getPronunciationHistory(String userId);
}

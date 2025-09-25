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
}

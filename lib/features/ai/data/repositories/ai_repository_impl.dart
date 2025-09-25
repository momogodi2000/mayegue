import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/ai_remote_datasource.dart';
import '../models/ai_models.dart';
import '../../domain/entities/ai_entities.dart';
import '../../domain/repositories/ai_repository.dart';
class AiRepositoryImpl implements AiRepository {
  final AiRemoteDataSource remoteDataSource;
  final FirebaseFirestore firestore;
  AiRepositoryImpl({
    required this.remoteDataSource,
    required this.firestore,
  });
  @override
  Future<Either<Failure, ConversationEntity>> startConversation({
    required String userId,
    required String title,
  }) async {
    try {
      final conversationDoc = firestore.collection('conversations').doc();
      final conversationId = conversationDoc.id;
      final conversation = ConversationModel(
        id: conversationId,
        userId: userId,
        title: title,
        messages: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await conversationDoc.set(conversation.toJson());
      return Right(conversation);
    } catch (e) {
      return Left(ServerFailure('Failed to start conversation: $e'));
    }
  }
  @override
  Future<Either<Failure, AiResponseEntity>> sendMessage({
    required String conversationId,
    required String message,
    required String userId,
  }) async {
    try {
      final conversationDoc = firestore.collection('conversations').doc(conversationId);
      final conversationSnapshot = await conversationDoc.get();
      if (!conversationSnapshot.exists) {
        return Left(NotFoundFailure('Conversation not found'));
      }
      final conversation = ConversationModel.fromJson(conversationSnapshot.data()!);
      final userMessage = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: conversationId,
        sender: 'user',
        content: message,
        timestamp: DateTime.now(),
      );
      // Add user message to conversation
      final updatedMessages = [...conversation.messages, userMessage];
      await conversationDoc.update({
        'messages': updatedMessages.map((m) => (m as MessageModel).toJson()).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      // Get AI response
      final conversationHistory = conversation.messages.map((msg) => msg.toJson()).toList();
      final aiResponseData = await remoteDataSource.sendMessageToAI(
        message: message,
        conversationId: conversationId,
        conversationHistory: conversationHistory,
      );

      final aiResponse = AiResponseEntity(
        content: aiResponseData['content'] as String,
        conversationId: conversationId,
        metadata: aiResponseData,
        timestamp: DateTime.now(),
      );
      final aiMessage = MessageModel(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        conversationId: conversationId,
        sender: 'ai',
        content: aiResponse.content,
        timestamp: DateTime.now(),
        metadata: aiResponse.metadata,
      );
      final finalMessages = [...updatedMessages, aiMessage];
      await conversationDoc.update({
        'messages': finalMessages.map((m) => m.toJson()).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return Right(aiResponse);
    } catch (e) {
      return Left(ServerFailure('Failed to send message: $e'));
    }
  }
  @override
  Future<Either<Failure, ConversationEntity>> getConversation(String conversationId) async {
    try {
      final docSnapshot = await firestore
          .collection('conversations')
          .doc(conversationId)
          .get();
      if (!docSnapshot.exists) {
        return Left(NotFoundFailure('Conversation not found'));
      }
      final conversation = ConversationModel.fromJson(docSnapshot.data()!);
      return Right(conversation);
    } catch (e) {
      return Left(ServerFailure('Failed to get conversation: $e'));
    }
  }
  @override
  Future<Either<Failure, List<ConversationEntity>>> getUserConversations(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('conversations')
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();
      final conversations = querySnapshot.docs
          .map((doc) => ConversationModel.fromJson(doc.data()))
          .toList();
      return Right(conversations);
    } catch (e) {
      return Left(ServerFailure('Failed to get conversations: $e'));
    }
  }
  @override
  Future<Either<Failure, bool>> deleteConversation(String conversationId) async {
    try {
      await firestore.collection('conversations').doc(conversationId).delete();
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure('Failed to delete conversation: $e'));
    }
  }
  @override
  Future<Either<Failure, List<String>>> getRecommendations(String userId) async {
    try {
      final conversationsResult = await getUserConversations(userId);
      return conversationsResult.fold(
        (failure) => Left(failure),
        (conversations) {
          final recommendations = <String>[];
          if (conversations.isEmpty) {
            recommendations.addAll([
              'Practice basic greetings in Ewondo',
              'Learn common phrases for daily conversation',
              'Study Ewondo pronunciation',
            ]);
          } else {
            final hasPronunciationPractice = conversations.any(
              (conv) => conv.messages.any((msg) => msg.content.contains('pronunciation'))
            );
            if (!hasPronunciationPractice) {
              recommendations.add('Practice Ewondo pronunciation');
            }
            final hasGrammarQuestions = conversations.any(
              (conv) => conv.messages.any((msg) => msg.content.contains('grammar'))
            );
            if (!hasGrammarQuestions) {
              recommendations.add('Learn Ewondo grammar rules');
            }
            recommendations.add('Continue practicing vocabulary');
            recommendations.add('Try conversational exercises');
          }
          return Right(recommendations);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get recommendations: $e'));
    }
  }
}

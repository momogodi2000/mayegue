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
        return const Left(NotFoundFailure('Conversation not found'));
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
        return const Left(NotFoundFailure('Conversation not found'));
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

  @override
  Future<Either<Failure, TranslationEntity>> translateText({
    required String userId,
    required String sourceText,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    try {
      final translationData = await remoteDataSource.translateText(
        text: sourceText,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );

      final translation = AiTranslationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        sourceText: sourceText,
        sourceLanguage: sourceLanguage,
        targetText: translationData['targetText'] as String,
        targetLanguage: targetLanguage,
        confidence: (translationData['confidence'] ?? 0.0).toDouble(),
        createdAt: DateTime.now(),
        metadata: translationData,
      );

      // Save to Firestore
      await firestore.collection('translations').doc(translation.id).set(translation.toJson());

      return Right(translation);
    } catch (e) {
      return Left(ServerFailure('Failed to translate text: $e'));
    }
  }

  @override
  Future<Either<Failure, PronunciationAssessmentEntity>> assessPronunciation({
    required String userId,
    required String word,
    required String language,
    required String audioUrl,
  }) async {
    try {
      // For now, we'll use a mock base64 string since we don't have actual audio processing
      // In production, you'd convert the audio file to base64
      const mockAudioBase64 = 'mock_audio_data';

      final assessmentData = await remoteDataSource.assessPronunciation(
        word: word,
        language: language,
        audioBase64: mockAudioBase64,
      );

      final issues = (assessmentData['issues'] as List<dynamic>?)
          ?.map((issue) => PronunciationIssue.fromJson(issue))
          .toList() ?? [];

      final assessment = PronunciationAssessmentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        word: word,
        language: language,
        audioUrl: audioUrl,
        score: (assessmentData['score'] ?? 0.0).toDouble(),
        feedback: assessmentData['feedback'] as String,
        issues: issues,
        assessedAt: DateTime.now(),
        metadata: assessmentData,
      );

      // Save to Firestore
      await firestore.collection('pronunciation_assessments').doc(assessment.id).set(assessment.toJson());

      return Right(assessment);
    } catch (e) {
      return Left(ServerFailure('Failed to assess pronunciation: $e'));
    }
  }

  @override
  Future<Either<Failure, ContentGenerationEntity>> generateContent({
    required String userId,
    required String type,
    required String topic,
    required String language,
    required String difficulty,
  }) async {
    try {
      final contentData = await remoteDataSource.generateContent(
        type: type,
        topic: topic,
        language: language,
        difficulty: difficulty,
      );

      final content = ContentGenerationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        type: type,
        topic: topic,
        language: language,
        difficulty: difficulty,
        generatedContent: contentData['generatedContent'] as String,
        tags: List<String>.from(contentData['tags'] ?? []),
        generatedAt: DateTime.now(),
        metadata: contentData,
      );

      // Save to Firestore
      await firestore.collection('generated_content').doc(content.id).set(content.toJson());

      return Right(content);
    } catch (e) {
      return Left(ServerFailure('Failed to generate content: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AiLearningRecommendationEntity>>> getPersonalizedRecommendations(String userId) async {
    try {
      final recommendationsData = await remoteDataSource.getPersonalizedRecommendations(userId);

      final recommendations = recommendationsData.map((data) => AiLearningRecommendationModel(
        id: '${DateTime.now().millisecondsSinceEpoch}_${recommendationsData.indexOf(data)}',
        userId: userId,
        type: data['type'] as String,
        title: data['title'] as String,
        description: data['description'] as String,
        reason: data['reason'] as String,
        priority: data['priority'] as int,
        isCompleted: data['isCompleted'] as bool,
        createdAt: DateTime.now(),
        metadata: data,
      )).toList();

      return Right(recommendations);
    } catch (e) {
      return Left(ServerFailure('Failed to get personalized recommendations: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> saveTranslation(TranslationEntity translation) async {
    try {
      await firestore.collection('translations').doc(translation.id).set((translation as AiTranslationModel).toJson());
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure('Failed to save translation: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TranslationEntity>>> getTranslationHistory(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('translations')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      final translations = querySnapshot.docs
          .map((doc) => AiTranslationModel.fromJson(doc.data()))
          .toList();

      return Right(translations);
    } catch (e) {
      return Left(ServerFailure('Failed to get translation history: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> savePronunciationAssessment(PronunciationAssessmentEntity assessment) async {
    try {
      await firestore.collection('pronunciation_assessments').doc(assessment.id).set((assessment as PronunciationAssessmentModel).toJson());
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure('Failed to save pronunciation assessment: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PronunciationAssessmentEntity>>> getPronunciationHistory(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('pronunciation_assessments')
          .where('userId', isEqualTo: userId)
          .orderBy('assessedAt', descending: true)
          .limit(50)
          .get();

      final assessments = querySnapshot.docs
          .map((doc) => PronunciationAssessmentModel.fromJson(doc.data()))
          .toList();

      return Right(assessments);
    } catch (e) {
      return Left(ServerFailure('Failed to get pronunciation history: $e'));
    }
  }
}

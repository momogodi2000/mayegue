import 'dart:convert';
import 'package:http/http.dart' as http;

/// AI Remote Data Source
abstract class AiRemoteDataSource {
  Future<Map<String, dynamic>> sendMessageToAI({
    required String message,
    required String conversationId,
    required List<Map<String, dynamic>> conversationHistory,
  });

  Future<List<String>> getRecommendations(String userId);

  Future<Map<String, dynamic>> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  });

  Future<Map<String, dynamic>> assessPronunciation({
    required String word,
    required String language,
    required String audioBase64,
  });

  Future<Map<String, dynamic>> generateContent({
    required String type,
    required String topic,
    required String language,
    required String difficulty,
  });

  Future<List<Map<String, dynamic>>> getPersonalizedRecommendations(String userId);
}

/// OpenAI implementation
class AiRemoteDataSourceImpl implements AiRemoteDataSource {
  final String apiKey;
  final String baseUrl;

  AiRemoteDataSourceImpl({
    required this.apiKey,
    this.baseUrl = 'https://api.openai.com/v1',
  });

  @override
  Future<Map<String, dynamic>> sendMessageToAI({
    required String message,
    required String conversationId,
    required List<Map<String, dynamic>> conversationHistory,
  }) async {
    try {
      final messages = [
        {
          'role': 'system',
          'content': 'You are Mayegue, an AI assistant specialized in teaching traditional Cameroonian languages. You help users learn Ewondo and Bafang with cultural context and pronunciation guidance. Be friendly, patient, and culturally sensitive.'
        },
        ...conversationHistory.map((msg) => {
          'role': msg['sender'] == 'user' ? 'user' : 'assistant',
          'content': msg['content'],
        }),
        {
          'role': 'user',
          'content': message,
        }
      ];

      final response = await http.post(
        Uri.parse('$baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': messages,
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'content': data['choices'][0]['message']['content'],
          'usage': data['usage'],
          'timestamp': DateTime.now().toIso8601String(),
        };
      } else {
        throw Exception('AI API error: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to mock response for development
      return {
        'content': _getMockResponse(message),
        'usage': {'total_tokens': 100},
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  Future<List<String>> getRecommendations(String userId) async {
    // Mock recommendations based on user progress
    return [
      'Practice basic greetings in Ewondo',
      'Learn numbers 1-10 with pronunciation',
      'Study family vocabulary',
      'Try pronunciation exercises',
    ];
  }

  String _getMockResponse(String message) {
    if (message.toLowerCase().contains('hello') || message.toLowerCase().contains('bonjour')) {
      return 'Mbote! (Hello in Ewondo). How can I help you learn traditional Cameroonian languages today?';
    } else if (message.toLowerCase().contains('pronunciation')) {
      return 'For good pronunciation in Ewondo, focus on the tones. Each syllable has a high or low tone that changes meaning. Would you like me to help you practice some words?';
    } else {
      return 'I\'m here to help you learn Ewondo and Bafang. What specific aspect of the language would you like to explore? Vocabulary, grammar, pronunciation, or cultural context?';
    }
  }

  @override
  Future<Map<String, dynamic>> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    try {
      // For now, return mock translation data
      // In production, this would call a translation API
      return {
        'sourceText': text,
        'targetText': _getMockTranslation(text, sourceLanguage, targetLanguage),
        'confidence': 0.85,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'sourceText': text,
        'targetText': text, // fallback to original text
        'confidence': 0.0,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> assessPronunciation({
    required String word,
    required String language,
    required String audioBase64,
  }) async {
    try {
      // For now, return mock assessment data
      // In production, this would call a speech recognition API
      final score = _calculateMockScore(word);
      final issues = _getMockPronunciationIssues(word, score);

      return {
        'word': word,
        'language': language,
        'score': score,
        'feedback': _getMockFeedback(score),
        'issues': issues,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'word': word,
        'language': language,
        'score': 0.5,
        'feedback': 'Assessment failed. Please try again.',
        'issues': [],
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> generateContent({
    required String type,
    required String topic,
    required String language,
    required String difficulty,
  }) async {
    try {
      // For now, return mock generated content
      // In production, this would call an AI content generation API
      return {
        'type': type,
        'topic': topic,
        'language': language,
        'difficulty': difficulty,
        'generatedContent': _getMockGeneratedContent(type, topic, language, difficulty),
        'tags': _getMockTags(type, topic),
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'type': type,
        'topic': topic,
        'language': language,
        'difficulty': difficulty,
        'generatedContent': 'Content generation failed. Please try again.',
        'tags': [],
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPersonalizedRecommendations(String userId) async {
    try {
      // For now, return mock personalized recommendations
      // In production, this would analyze user progress and generate recommendations
      return [
        {
          'type': 'vocabulary',
          'title': 'Practice Family Vocabulary',
          'description': 'Learn words for family members in Ewondo',
          'reason': 'Based on your recent progress in basic greetings',
          'priority': 4,
          'isCompleted': false,
          'timestamp': DateTime.now().toIso8601String(),
        },
        {
          'type': 'pronunciation',
          'title': 'Tone Practice',
          'description': 'Practice high and low tones in Ewondo words',
          'reason': 'Tones are crucial for correct pronunciation',
          'priority': 5,
          'isCompleted': false,
          'timestamp': DateTime.now().toIso8601String(),
        },
        {
          'type': 'grammar',
          'title': 'Basic Sentence Structure',
          'description': 'Learn how to form simple sentences',
          'reason': 'Foundation for conversational skills',
          'priority': 3,
          'isCompleted': false,
          'timestamp': DateTime.now().toIso8601String(),
        },
      ];
    } catch (e) {
      return [];
    }
  }

  String _getMockTranslation(String text, String sourceLanguage, String targetLanguage) {
    // Simple mock translations for demonstration
    final mockTranslations = {
      'hello': {'ewondo': 'mboté', 'bafang': 'mbɔ́tɛ'},
      'thank you': {'ewondo': 'matónda', 'bafang': 'màtɔ̀ndà'},
      'good morning': {'ewondo': 'mboté o bibóm', 'bafang': 'mbɔ́tɛ ɔ̀ bìbɔ́m'},
      'how are you': {'ewondo': 'mboté o yem', 'bafang': 'mbɔ́tɛ ɔ̀ yɛ̀m'},
    };

    final lowerText = text.toLowerCase();
    if (mockTranslations.containsKey(lowerText)) {
      return mockTranslations[lowerText]![targetLanguage.toLowerCase()] ?? text;
    }
    return '$text (translated to $targetLanguage)';
  }

  double _calculateMockScore(String word) {
    // Mock scoring based on word length and some randomness
    final baseScore = 0.6 + (word.length % 3) * 0.1;
    return (baseScore + (DateTime.now().millisecondsSinceEpoch % 40 - 20) / 100).clamp(0.0, 1.0);
  }

  List<Map<String, dynamic>> _getMockPronunciationIssues(String word, double score) {
    if (score > 0.8) return [];

    final issues = <Map<String, dynamic>>[];
    if (word.contains('ng') || word.contains('mb')) {
      issues.add({
        'type': 'consonant',
        'description': 'Difficulty with nasal consonants',
        'severity': 0.7,
        'suggestion': 'Practice nasal sounds by holding your nose while speaking',
      });
    }
    if (score < 0.6) {
      issues.add({
        'type': 'tone',
        'description': 'Tone pronunciation needs improvement',
        'severity': 0.8,
        'suggestion': 'Listen to native speakers and practice tone patterns',
      });
    }
    return issues;
  }

  String _getMockFeedback(double score) {
    if (score > 0.9) return 'Excellent pronunciation! Keep up the great work.';
    if (score > 0.7) return 'Good job! Focus on the highlighted areas for improvement.';
    if (score > 0.5) return 'Not bad, but there\'s room for improvement. Practice more.';
    return 'This needs more practice. Listen carefully and try again.';
  }

  String _getMockGeneratedContent(String type, String topic, String language, String difficulty) {
    final languageName = language == 'ewondo' ? 'Ewondo' : 'Bafang';
    final capitalizedTopic = topic.isNotEmpty ? '${topic[0].toUpperCase()}${topic.substring(1)}' : topic;

    switch (type) {
      case 'lesson':
        return '''
# ${capitalizedTopic} - ${languageName} Lesson

## Introduction
Welcome to your personalized ${difficulty} level lesson on ${topic} in ${languageName}.

## Key Vocabulary
- Word 1: Definition
- Word 2: Definition
- Word 3: Definition

## Practice Sentences
1. Example sentence one.
2. Example sentence two.
3. Example sentence three.

## Cultural Notes
${topic} is important in ${languageName} culture because...

## Exercises
1. Translate the following sentences...
2. Practice pronunciation of key words...
        ''';

      case 'exercise':
        return '''
# ${capitalizedTopic} Practice Exercise

## Instructions
Complete the following exercises to practice ${topic} in ${languageName}.

## Fill in the Blanks
1. ___ (to eat) rice every day.
2. She ___ (to go) to market.
3. We ___ (to learn) ${languageName}.

## Translation Practice
Translate these sentences to ${languageName}:
1. I am learning the language.
2. Where is the market?
3. Thank you for your help.

## Pronunciation Focus
Practice saying these words clearly: word1, word2, word3.
        ''';

      case 'story':
        return '''
# A Short ${languageName} Story: ${capitalizedTopic}

Once upon a time in a small village...

[Story content would be generated here based on the topic]

The end.

## Vocabulary from the Story
- Word: meaning
- Word: meaning
- Word: meaning

## Comprehension Questions
1. What happened at the beginning?
2. Who were the main characters?
3. What was the lesson learned?
        ''';

      case 'dialogue':
        return '''
# Everyday Dialogue: ${capitalizedTopic}

**Person A:** Greeting in ${languageName}
**Person B:** Response

**Person A:** Question about ${topic}
**Person B:** Answer

**Person A:** Follow-up question
**Person B:** Detailed response

## Key Phrases
- Greeting: [pronunciation]
- Question: [pronunciation]
- Answer: [pronunciation]

## Practice
Role-play this dialogue with a partner.
        ''';

      default:
        return 'Generated content for ${type}: ${topic} in ${languageName} (${difficulty} level)';
    }
  }

  List<String> _getMockTags(String type, String topic) {
    final baseTags = ['${type}', '${topic}'];
    switch (type) {
      case 'lesson':
        return [...baseTags, 'vocabulary', 'grammar', 'practice'];
      case 'exercise':
        return [...baseTags, 'practice', 'skills'];
      case 'story':
        return [...baseTags, 'reading', 'culture', 'comprehension'];
      case 'dialogue':
        return [...baseTags, 'speaking', 'conversation', 'communication'];
      default:
        return baseTags;
    }
  }
}

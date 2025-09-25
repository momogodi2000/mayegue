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
}

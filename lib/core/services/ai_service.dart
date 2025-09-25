import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for Gemini AI integration
class GeminiAIService {
  final String apiKey;
  final String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  GeminiAIService({required this.apiKey});

  /// Generate content using Gemini AI
  Future<String> generateContent(String prompt, {
    String model = 'gemini-pro',
    double temperature = 0.7,
    int maxTokens = 1000,
  }) async {
    try {
      final url = Uri.parse('$baseUrl?key=$apiKey');

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': temperature,
          'maxOutputTokens': maxTokens,
        }
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            return parts[0]['text'] as String;
          }
        }
        throw Exception('Invalid response format from Gemini AI');
      } else {
        throw Exception('Gemini AI API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to generate content with Gemini AI: $e');
    }
  }

  /// Generate language learning content
  Future<String> generateLanguageLesson({
    required String languageName,
    required String topic,
    String difficulty = 'intermediate',
  }) async {
    final prompt = '''
Generate a comprehensive lesson for learning $languageName.
Topic: $topic
Difficulty level: $difficulty

Please provide:
1. Introduction to the topic in both English and $languageName
2. Key vocabulary with pronunciations
3. Grammar explanations
4. Practice exercises
5. Cultural context where relevant

Format the response in a structured, educational manner.
''';

    return await generateContent(prompt);
  }

  /// Translate text between languages
  Future<String> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final prompt = '''
Translate the following text from $sourceLanguage to $targetLanguage:

"$text"

Please provide:
1. The direct translation
2. Cultural context or nuances if applicable
3. Alternative translations if there are multiple meanings
''';

    return await generateContent(prompt);
  }

  /// Generate pronunciation guide
  Future<String> generatePronunciationGuide({
    required String word,
    required String language,
  }) async {
    final prompt = '''
Create a detailed pronunciation guide for the word "$word" in $language.

Please include:
1. Phonetic transcription (IPA)
2. Syllable breakdown
3. Common pronunciation mistakes
4. Audio description (how it sounds)
5. Similar sounds in English if applicable
''';

    return await generateContent(prompt);
  }

  /// Generate language statistics and insights
  Future<String> generateLanguageInsights({
    required String languageName,
    required String region,
    required int speakers,
    required String status,
  }) async {
    final prompt = '''
Provide insights about the $languageName language:

- Region: $region
- Estimated speakers: $speakers
- Status: $status

Please include:
1. Historical context
2. Current usage and domains
3. Challenges and preservation efforts
4. Interesting facts
5. Comparison with related languages
''';

    return await generateContent(prompt);
  }

  /// Generate quiz questions for language learning
  Future<String> generateQuizQuestions({
    required String languageName,
    required String topic,
    int numberOfQuestions = 5,
  }) async {
    final prompt = '''
Generate $numberOfQuestions quiz questions about $languageName, focusing on: $topic

For each question, provide:
1. The question
2. 4 multiple choice options (A, B, C, D)
3. The correct answer
4. Explanation

Format as JSON array of objects with keys: question, options, correctAnswer, explanation
''';

    return await generateContent(prompt);
  }
}

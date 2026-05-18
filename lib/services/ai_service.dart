import 'dart:io';

class AIService {
  static late final String _groqApiKey;

  static void initialize() {
    // Read from environment variable instead of hardcoding
    _groqApiKey = Platform.environment['GROQ_API_KEY'] ?? '';
    if (_groqApiKey.isEmpty) {
      throw Exception('GROQ_API_KEY environment variable not set');
    }
  }

  static String get groqApiKey => _groqApiKey;

  // Add your AI service methods here
}

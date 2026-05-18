import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  AiMessage({required this.text, required this.isUser, DateTime? time})
      : time = time ?? DateTime.now();
}

class AiService {
  static const int maxQuestionsPerDay = 30;
  static const _groqUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static String get _groqKey => dotenv.env['GROQ_API_KEY'] ?? '';
  static const _model = 'llama-3.3-70b-versatile';
  static const _historyKey = 'ai_chat_history';
  static const _usagePrefix = 'ai_usage_';

  static const _systemPrompt =
      'Siz "Smart Daily Planner" ilovasi uchun AI yordamchisiz. '
      'Faqat quyidagi mavzularda yordam bering: kunlik vazifalar va reja, '
      'produktivlik, vaqt boshqaruvi, odatlar, sogʿliq (uyqu, suv, sport, ovqat), '
      'oʼqish strategiyalari, namoz va Qibla, ob-havo, ilova funksiyalari. '
      'Boshqa mavzularda muloyimlik bilan ilovaga qaytaring. '
      'Foydalanuvchi yozgan tilda javob bering (oʼzbek, rus yoki ingliz). '
      'Javoblarni qisqa va amaliy qiling.';

  Future<List<AiMessage>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((m) => AiMessage(
        text: m['text'] as String,
        isUser: m['isUser'] as bool,
        time: DateTime.parse(m['time'] as String),
      )).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveHistory(List<AiMessage> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final list = messages.map((m) => {
      'text': m.text,
      'isUser': m.isUser,
      'time': m.time.toIso8601String(),
    }).toList();
    await prefs.setString(_historyKey, jsonEncode(list));
  }

  Future<int> getRemainingQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final used = prefs.getInt('$_usagePrefix$today') ?? 0;
    return (maxQuestionsPerDay - used).clamp(0, maxQuestionsPerDay);
  }

  Future<({String reply, int remaining})> sendMessage(String message) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final used = prefs.getInt('$_usagePrefix$today') ?? 0;

    if (used >= maxQuestionsPerDay) {
      return (
        reply: '⚠️ Bugun $maxQuestionsPerDay ta savol limitiga yetdingiz.\n\nErtaga yangi $maxQuestionsPerDay ta savol imkoniyati ochiladi! 🌅',
        remaining: 0,
      );
    }

    final history = await loadHistory();
    final recent = history.length > 8 ? history.sublist(history.length - 8) : history;

    final msgs = [
      {'role': 'system', 'content': _systemPrompt},
      for (final m in recent)
        {'role': m.isUser ? 'user' : 'assistant', 'content': m.text},
      {'role': 'user', 'content': message},
    ];

    try {
      final resp = await http.post(
        Uri.parse(_groqUrl),
        headers: {
          'Authorization': 'Bearer \$_groqKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'model': _model, 'messages': msgs, 'temperature': 0.7, 'max_tokens': 512}),
      ).timeout(const Duration(seconds: 25));

      if (resp.statusCode == 200) {
        final reply = jsonDecode(resp.body)['choices'][0]['message']['content'] as String;
        await _saveHistory([
          ...history,
          AiMessage(text: message, isUser: true),
          AiMessage(text: reply, isUser: false),
        ]);
        await prefs.setInt('$_usagePrefix$today', used + 1);
        return (reply: reply, remaining: maxQuestionsPerDay - used - 1);
      }

      if (resp.statusCode == 429) {
        return (reply: '⏳ AI hozirda band. Bir necha soniya kuting va qaytadan yuboring.', remaining: maxQuestionsPerDay - used);
      }

      return (reply: '❌ Xatolik: \${resp.statusCode}', remaining: maxQuestionsPerDay - used);
    } catch (e) {
      return (reply: '❌ Ulanishda xatolik. Internet aloqasini tekshiring.', remaining: maxQuestionsPerDay - used);
    }
  }

  List<AiMessage> buildWelcomeMessages(int remaining) {
    return [
      AiMessage(
        text: '👋 Salom! Men Smart Daily Planner ning AI yordamchisiman.\n\n'
            'Faqat ilova mavzularida yordam beraman:\n'
            '• 📋 Kunlik vazifalar va reja\n'
            '• ⚡ Produktivlik maslahatlari\n'
            '• 💪 Sogʿliq va sport\n'
            '• 📚 Oʼqish strategiyalari\n'
            '• 🕌 Namoz va Qibla\n\n'
            '📊 Bugun qolgan savollar: \$remaining / \$maxQuestionsPerDay\n\n'
            'Nima haqida gaplashamiz?',
        isUser: false,
      ),
    ];
  }
}

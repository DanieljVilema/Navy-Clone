import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';
import '../services/database_service.dart';

class ChatProvider extends ChangeNotifier {
  final GeminiService _gemini;
  final DatabaseService _db;
  List<ChatMessageModel> _messages = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  ChatProvider(this._gemini, this._db);

  List<ChatMessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isGeminiReady => _gemini.isInitialized;

  Future<void> initialize(String apiKey,
      {String? baremosContext, String? nutritionContext}) async {
    await _gemini.initialize(
      apiKey,
      baremosContext: baremosContext,
      nutritionContext: nutritionContext,
    );
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    _messages = await _db.getChatHistory(limit: 100);
    // Reverse so oldest are first (DB returns newest first)
    _messages = _messages.reversed.toList();
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    // Add user message
    final userMsg = ChatMessageModel(role: 'user', text: text);
    _messages.add(userMsg);
    await _db.insertChatMessage(userMsg);
    _isLoading = true;
    notifyListeners();

    // Get AI response
    final responseText = await _gemini.sendMessage(text);
    final botMsg = ChatMessageModel(role: 'assistant', text: responseText);
    _messages.add(botMsg);
    await _db.insertChatMessage(botMsg);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> clearChat() async {
    await _db.clearChatHistory();
    _messages.clear();
    _gemini.resetChat();
    notifyListeners();
  }
}

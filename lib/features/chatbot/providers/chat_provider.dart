import 'package:flutter/foundation.dart';
import 'package:navy_pfa_armada_ecuador/features/chatbot/models/chat_message.dart';
import 'package:navy_pfa_armada_ecuador/features/chatbot/services/gemini_service.dart';
import 'package:navy_pfa_armada_ecuador/shared/services/database_service.dart';

class ChatProvider extends ChangeNotifier {
  final GeminiService _gemini;
  final DatabaseService _db;
  List<ChatMessageModel> _messages = [];
  bool _isLoading = false;

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
    notifyListeners();
  }

  Future<void> loadHistory() async {
    try {
      _messages = await _db.getChatHistory(limit: 100);
    } catch (e) {
      debugPrint('Error loading chat history: $e');
      _messages = [];
    }
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    // Add user message
    final userMsg = ChatMessageModel(role: 'user', text: text);
    _messages.insert(0, userMsg);
    
    try {
      await _db.insertChatMessage(userMsg);
    } catch (e) {
      debugPrint('Warning: Could not save user message to DB: $e');
    }
    
    _isLoading = true;
    notifyListeners();

    try {
      final responseText = await _gemini.sendMessage(text);
      final botMsg = ChatMessageModel(role: 'assistant', text: responseText);
      _messages.insert(0, botMsg);
      
      try {
        await _db.insertChatMessage(botMsg);
      } catch (e) {
        debugPrint('Warning: Could not save bot message to DB: $e');
      }

    } catch (e) {
      final errorMsg = ChatMessageModel(
          role: 'assistant',
          text: 'Ocurrió un error al procesar la respuesta. Inténtalo de nuevo.');
      _messages.insert(0, errorMsg);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearChat() async {
    await _db.clearChatHistory();
    _messages.clear();
    _isLoading = false;
    _gemini.resetChat();
    notifyListeners();
  }
}

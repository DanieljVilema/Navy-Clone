import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../core/constants.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'Marino');
  final ChatUser _navyBot = ChatUser(
    id: '2',
    firstName: 'Asistente Naval',
    profileImage: 'https://cdn-icons-png.flaticon.com/512/3260/3260867.png',
  );
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(
      text: '¡Saludos! Soy el Asistente Virtual de la Armada del Ecuador. '
          '¿En qué te puedo ayudar sobre el reglamento de pruebas físicas hoy?',
      user: _navyBot,
      createdAt: DateTime.now(),
    ));
  }

  void _onSend(ChatMessage message) {
    setState(() => _messages.insert(0, message));
    final chatProvider = context.read<ChatProvider>();
    if (chatProvider.isGeminiReady) {
      chatProvider.sendMessage(message.text).then((_) {
        if (mounted) {
          final lastMsg = chatProvider.messages.last;
          setState(() {
            _messages.insert(0, ChatMessage(
              text: lastMsg.text,
              user: _navyBot,
              createdAt: lastMsg.timestamp,
            ));
          });
        }
      });
    } else {
      _simulateResponse(message.text);
    }
  }

  void _simulateResponse(String userText) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _messages.insert(0, ChatMessage(
            text: 'He recibido tu consulta sobre: "$userText".\n\n'
                'Actualmente el motor de I.A. no está configurado. '
                'Configure su API Key de Gemini para activarlo.\n\n'
                'Mientras tanto, consulte los reglamentos desde el menú lateral.',
            user: _navyBot,
            createdAt: DateTime.now(),
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: DashChat(
        currentUser: _currentUser,
        onSend: _onSend,
        messages: _messages,
        messageOptions: const MessageOptions(
          currentUserContainerColor: AppColors.primary,
          containerColor: AppColors.darkCardSec,
          textColor: AppColors.darkTextPrimary,
          currentUserTextColor: Colors.white,
          showOtherUsersAvatar: true,
        ),
        inputOptions: InputOptions(
          inputDecoration: InputDecoration(
            hintText: 'Escribe tu consulta...',
            hintStyle: TextStyle(color: AppColors.darkTextTertiary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Radii.m),
              borderSide: const BorderSide(color: AppColors.darkBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Radii.m),
              borderSide: const BorderSide(color: AppColors.darkBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Radii.m),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            filled: true,
            fillColor: AppColors.darkCard,
          ),
          inputTextStyle: const TextStyle(color: AppColors.darkTextPrimary),
        ),
      ),
    );
  }
}

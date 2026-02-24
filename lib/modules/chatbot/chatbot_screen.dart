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

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ChatProvider>().loadHistory();
    });
  }

  void _onSend(ChatMessage message) {
    context.read<ChatProvider>().sendMessage(message.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Consultas I.A.'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _showClearDialog,
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          final messages = chatProvider.messages
              .map(
                (msg) => ChatMessage(
                  text: msg.text,
                  user: msg.role == 'user' ? _currentUser : _navyBot,
                  createdAt: msg.timestamp,
                ),
              )
              .toList();

          return Stack(
            children: [
              DashChat(
                currentUser: _currentUser,
                onSend: _onSend,
                messages: messages,
                messageOptions: const MessageOptions(
                  currentUserContainerColor: AppColors.primary,
                  containerColor: AppColors.darkCardSec,
                  textColor: AppColors.darkTextPrimary,
                  currentUserTextColor: Colors.white,
                  showOtherUsersAvatar: true,
                  borderRadius: Radii.m,
                ),
                inputOptions: InputOptions(
                  cursorStyle: const CursorStyle(color: AppColors.primary),
                  inputDecoration: InputDecoration(
                    hintText: 'Escribe tu consulta...',
                    hintStyle:
                        const TextStyle(color: AppColors.darkTextTertiary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Radii.m),
                      borderSide:
                          const BorderSide(color: AppColors.darkBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Radii.m),
                      borderSide:
                          const BorderSide(color: AppColors.darkBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Radii.m),
                      borderSide:
                          const BorderSide(color: AppColors.primary),
                    ),
                    filled: true,
                    fillColor: AppColors.darkCard,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: Spacing.m,
                      vertical: Spacing.s,
                    ),
                  ),
                  inputTextStyle:
                      const TextStyle(color: AppColors.darkTextPrimary),
                ),
              ),
              if (chatProvider.isLoading)
                Positioned(
                  bottom: 70,
                  left: Spacing.m,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.m,
                      vertical: Spacing.s,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.darkCardSec,
                      borderRadius: BorderRadius.circular(Radii.m),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              AppColors.primary.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                        const SizedBox(width: Spacing.s),
                        const Text(
                          'Escribiendo...',
                          style: TextStyle(
                            color: AppColors.darkTextSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Borrar Historial'),
        content: const Text(
          '¿Deseas borrar todo el historial de conversaciones?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<ChatProvider>().clearChat();
              Navigator.pop(ctx);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Historial borrado')),
                );
              }
            },
            child: const Text('Borrar'),
          ),
        ],
      ),
    );
  }
}

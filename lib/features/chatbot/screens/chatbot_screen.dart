import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:navy_pfa_armada_ecuador/features/chatbot/providers/chat_provider.dart';
import 'package:navy_pfa_armada_ecuador/features/chatbot/models/chat_message.dart';
import 'package:navy_pfa_armada_ecuador/core/constants/constants.dart';
import 'package:navy_pfa_armada_ecuador/shared/providers/content_provider.dart';
import 'package:navy_pfa_armada_ecuador/shared/utils/pdf_opener.dart';

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
    debugPrint("Sending message: ${message.text}");
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
                messageOptions: MessageOptions(
                  currentUserContainerColor: AppColors.primary,
                  containerColor: AppColors.darkCardSec,
                  textColor: AppColors.darkTextPrimary,
                  currentUserTextColor: Colors.white,
                  showOtherUsersAvatar: true,
                  borderRadius: Radii.m,
                  messageTextBuilder: (message, previousMessage, nextMessage) {
                    final isUser = message.user.id == _currentUser.id;
                    final sourceMsg = chatProvider.messages.firstWhere(
                      (m) => m.text == message.text && m.timestamp == message.createdAt,
                      orElse: () => ChatMessageModel(role: 'user', text: ''),
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MarkdownBody(
                          data: message.text,
                          selectable: true,
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              color: isUser ? Colors.white : AppColors.darkTextPrimary,
                              fontSize: 15,
                            ),
                            strong: TextStyle(
                              color: isUser ? Colors.white : AppColors.darkTextPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            em: TextStyle(
                              color: isUser ? Colors.white : AppColors.darkTextPrimary,
                              fontStyle: FontStyle.italic,
                            ),
                            listBullet: TextStyle(
                              color: isUser ? Colors.white : AppColors.darkTextPrimary,
                            ),
                          ),
                        ),
                        if (!isUser && sourceMsg.sources.isNotEmpty) ...[
                          const SizedBox(height: Spacing.m),
                          const Divider(color: AppColors.darkBorder, height: 1),
                          const SizedBox(height: Spacing.s),
                          Text(
                            'Fuentes:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkTextSecondary,
                            ),
                          ),
                          const SizedBox(height: Spacing.xs),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: sourceMsg.sources.map((source) {
                              return ActionChip(
                                avatar: const Icon(Icons.picture_as_pdf, size: 16, color: AppColors.primary),
                                label: Text(
                                  source,
                                  style: const TextStyle(fontSize: 12, color: AppColors.darkTextPrimary),
                                ),
                                backgroundColor: AppColors.darkCard,
                                side: const BorderSide(color: AppColors.darkBorder),
                                onPressed: () {
                                  _openSourcePdf(source);
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    );
                  },
                ),
                inputOptions: InputOptions(
                  alwaysShowSend: true,
                  sendOnEnter: true,
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
              if (messages.isEmpty && !chatProvider.isLoading)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(Spacing.l),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 48,
                            color: AppColors.primary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: Spacing.m),
                          Text(
                            '¿En qué te puedo ayudar hoy?',
                            style: TextStyle(
                              color: AppColors.darkTextPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: Spacing.xs),
                          Text(
                            'Selecciona una consulta común o escribe la tuya.',
                            style: TextStyle(
                              color: AppColors.darkTextSecondary,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: Spacing.l),
                          Wrap(
                            spacing: Spacing.s,
                            runSpacing: Spacing.s,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildSuggestionChip('¿Cuáles son los estándares de flexiones?'),
                              _buildSuggestionChip('¿Cómo funciona el Control de Peso (BCA)?'),
                              _buildSuggestionChip('¿Qué es el Programa de Mejora Física?'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(text),
      labelStyle: const TextStyle(color: AppColors.darkTextPrimary, fontSize: 13),
      backgroundColor: AppColors.darkCardSec,
      side: const BorderSide(color: AppColors.darkBorder),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.m)),
      onPressed: () {
        _onSend(ChatMessage(
          user: _currentUser,
          createdAt: DateTime.now(),
          text: text,
        ));
      },
    );
  }

  void _openSourcePdf(String docName) {
    final pdfAssets = context.read<ContentProvider>().pdfPathsForGemini;
    // Map documentation name back to asset path if possible. Note we load from assets/pdfs/
    // This is a simple matching, assuming docName closely matches the file name.
    final assetPath = 'assets/pdfs/$docName.pdf';
    
    // Use the shared pdf opener utility
    PdfOpener.open(assetPath, context);
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
                  const SnackBar(content: Text('Historial y chat reiniciados')),
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

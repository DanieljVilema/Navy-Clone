import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  // 1. Definimos los usuarios (Tú y el Bot)
  final ChatUser _currentUser = ChatUser(
    id: '1',
    firstName: 'Marino',
  );

  final ChatUser _navyBot = ChatUser(
    id: '2',
    firstName: 'Asistente Naval',
    // Un icono de ancla temporal para el perfil del bot
    profileImage: 'https://cdn-icons-png.flaticon.com/512/3260/3260867.png', 
  );

  // 2. Lista de mensajes en la pantalla
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Mensaje de bienvenida que aparece al abrir la pantalla
    _messages.add(
      ChatMessage(
        text: '¡Saludos! Soy el Asistente Virtual de la Armada del Ecuador. ¿En qué te puedo ayudar sobre el reglamento de pruebas físicas hoy?',
        user: _navyBot,
        createdAt: DateTime.now(),
      ),
    );
  }

  // 3. Función que se ejecuta cuando el usuario presiona "Enviar"
  void _onSend(ChatMessage message) {
    setState(() {
      _messages.insert(0, message); // Añade tu mensaje a la pantalla
    });

    // Llamamos a la función que simulará la respuesta de la IA
    _simulateGeminiResponse(message.text);
  }

  // 4. El "Cerebro" Temporal (Aquí conectaremos Gemini después)
  void _simulateGeminiResponse(String userText) {
    // Simulamos que el bot está "escribiendo" durante 1.5 segundos
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              text: 'He recibido tu consulta sobre: "$userText". \n\n(Nota técnica: Esta es una respuesta de prueba. Pronto conectaremos el motor de Inteligencia Artificial para leer los Baremos oficiales).',
              user: _navyBot,
              createdAt: DateTime.now(),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Azul oficial de tu app
    const navyColor = Color(0xFF001F5B);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Consultas I.A.', 
          style: TextStyle(color: Colors.white, fontSize: 18)
        ),
        backgroundColor: navyColor,
        iconTheme: const IconThemeData(color: Colors.white), // Flecha de volver blanca
      ),
      body: DashChat(
        currentUser: _currentUser,
        onSend: _onSend,
        messages: _messages,
        messageOptions: const MessageOptions(
          currentUserContainerColor: navyColor, // Burbujas del usuario en Azul Navy
          containerColor: Color(0xFFE0E0E0), // Burbujas del bot en gris claro militar
          textColor: Colors.black,
          currentUserTextColor: Colors.white,
          showOtherUsersAvatar: true,
        ),
        inputOptions: const InputOptions(
          inputDecoration: InputDecoration(
            hintText: "Escribe tu consulta sobre el reglamento...",
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

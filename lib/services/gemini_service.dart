import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  GenerativeModel? _model;
  ChatSession? _chat;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  static const _systemInstructionTemplate = '''
Eres el Asistente Virtual de la Armada del Ecuador para el Programa de Evaluación Física.
Tu rol es responder consultas sobre:
- Baremos y estándares de evaluación física
- Procedimientos de Control de Peso (BCA)
- Reglamentos de la Evaluación Física
- Nutrición y preparación física
- Programas de Mejora Física (FEP)
- Ejercicios y rutinas de entrenamiento

Responde siempre en español. Sé conciso y profesional.
Usa un tono militar pero amigable.
Si no conoces la respuesta exacta, indica que la información será actualizada próximamente.

CONTEXTO DE BAREMOS Y ESTÁNDARES:
{{BAREMOS_PLACEHOLDER}}

CONTEXTO DE NUTRICIÓN:
{{NUTRITION_PLACEHOLDER}}
''';

  Future<void> initialize(
    String apiKey, {
    String? baremosContext,
    String? nutritionContext,
  }) async {
    if (apiKey.isEmpty) return;

    try {
      final instructions = _systemInstructionTemplate
          .replaceAll('{{BAREMOS_PLACEHOLDER}}',
              baremosContext ?? 'Datos de baremos pendientes de carga.')
          .replaceAll('{{NUTRITION_PLACEHOLDER}}',
              nutritionContext ?? 'Datos de nutrición pendientes de carga.');

      _model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: apiKey,
        systemInstruction: Content.system(instructions),
      );
      _chat = _model!.startChat();
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
    }
  }

  Future<String> sendMessage(String userMessage) async {
    if (!_isInitialized || _chat == null) {
      return 'Servicio de IA no disponible. Verifique su conexión a internet o la configuración de la API key.';
    }

    try {
      final response = await _chat!.sendMessage(Content.text(userMessage));
      return response.text ?? 'Sin respuesta del asistente.';
    } catch (e) {
      return 'Error al comunicarse con el asistente: $e';
    }
  }

  void resetChat() {
    _chat = _model?.startChat();
  }
}

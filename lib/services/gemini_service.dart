import 'dart:typed_data';
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

CONTEXTO DE REGLAMENTOS:
{{REGULATIONS_PLACEHOLDER}}
''';

  Future<void> initialize(
    String apiKey, {
    String? baremosContext,
    String? nutritionContext,
    String? regulationsContext,
    Uint8List? pdfBytes,
  }) async {
    if (apiKey.isEmpty) return;

    try {
      final instructions = _systemInstructionTemplate
          .replaceAll('{{BAREMOS_PLACEHOLDER}}',
              baremosContext ?? 'Datos de baremos pendientes de carga.')
          .replaceAll('{{NUTRITION_PLACEHOLDER}}',
              nutritionContext ?? 'Datos de nutrición pendientes de carga.')
          .replaceAll('{{REGULATIONS_PLACEHOLDER}}',
              regulationsContext ?? 'Datos de reglamentos pendientes de carga.');

      _model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: apiKey,
        systemInstruction: Content.system(instructions),
      );

      // If PDF bytes are provided, start chat with the PDF as initial context
      if (pdfBytes != null && pdfBytes.isNotEmpty) {
        _chat = _model!.startChat(history: [
          Content.multi([
            DataPart('application/pdf', pdfBytes),
            TextPart(
              'Este es el reglamento oficial COGMAR-EDU-001-2019-O de la Armada del Ecuador. '
              'Contiene las normas completas para la evaluación de condiciones físicas y '
              'la recuperación de pruebas físicas. Úsalo como referencia para responder consultas.',
            ),
          ]),
          Content.model([
            TextPart(
              'Entendido. He procesado el reglamento oficial COGMAR-EDU-001-2019-O. '
              'Estoy listo para responder consultas sobre evaluación física de la Armada del Ecuador.',
            ),
          ]),
        ]);
      } else {
        _chat = _model!.startChat();
      }

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

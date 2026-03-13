import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:navy_pfa_armada_ecuador/features/chatbot/services/pdf_loader_service.dart';

/// Result from a Gemini chat message containing the response text
/// and any source document names cited.
class GeminiResponse {
  final String text;
  final List<String> sources;

  const GeminiResponse({required this.text, this.sources = const []});
}

class GeminiService {
  GenerativeModel? _model;
  ChatSession? _chat;
  bool _isInitialized = false;
  List<String> _availableDocNames = [];

  bool get isInitialized => _isInitialized;
  List<String> get availableDocNames => _availableDocNames;

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

IMPORTANTE - LIMITACIÓN DE TEMA:
Si el usuario hace preguntas que NO están relacionadas con la evaluación física,
reglamentos militares, nutrición deportiva o la Armada del Ecuador, responde amablemente:
"Mi especialidad está enfocada en la evaluación física y reglamentos de la Armada del Ecuador.
¿Puedo ayudarte con algo relacionado a estos temas?"

IMPORTANTE - CITACIÓN DE FUENTES:
Los siguientes documentos están disponibles como referencia:
{{DOC_LIST_PLACEHOLDER}}

Cuando uses información de alguno de estos documentos en tu respuesta,
DEBES incluir al FINAL de tu respuesta una línea con el formato:
[FUENTES: nombre_doc1 | nombre_doc2]

Usa EXACTAMENTE los nombres de documento listados arriba.
Si no usaste ningún documento específico, NO incluyas la línea de fuentes.

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
    List<PdfAsset> pdfAssets = const [],
  }) async {
    if (apiKey.isEmpty) return;

    try {
      _availableDocNames = pdfAssets.map((p) => p.name).toList();

      final docListStr = _availableDocNames.isNotEmpty
          ? _availableDocNames.map((n) => '- $n').join('\n')
          : 'No hay documentos cargados.';

      final instructions = _systemInstructionTemplate
          .replaceAll('{{DOC_LIST_PLACEHOLDER}}', docListStr)
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

      // If PDFs are provided, start chat with all of them as initial context
      if (pdfAssets.isNotEmpty) {
        final parts = <Part>[];
        for (final pdf in pdfAssets) {
          parts.add(DataPart('application/pdf', pdf.bytes));
          parts.add(TextPart(
            'Documento: "${pdf.name}". '
            'Úsalo como referencia para responder consultas.',
          ));
        }
        parts.add(TextPart(
          'Estos son los documentos oficiales de la Armada del Ecuador. '
          'Contienen normas, reglamentos y manuales relevantes. '
          'Úsalos como referencia principal para responder consultas.',
        ));

        _chat = _model!.startChat(history: [
          Content.multi(parts),
          Content.model([
            TextPart(
              'Entendido. He procesado ${pdfAssets.length} documento(s) oficial(es). '
              'Estoy listo para responder consultas sobre la Armada del Ecuador.',
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

  /// Parses the `[FUENTES: ...]` tag from the response text.
  /// Returns a [GeminiResponse] with clean text and extracted source names.
  static GeminiResponse parseResponse(String rawText) {
    final fuentesPattern = RegExp(
      r'\[FUENTES:\s*(.+?)\]\s*$',
      multiLine: true,
    );

    final match = fuentesPattern.firstMatch(rawText);
    if (match == null) {
      return GeminiResponse(text: rawText.trim());
    }

    final sourcesStr = match.group(1) ?? '';
    final sources = sourcesStr
        .split('|')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final cleanText = rawText.substring(0, match.start).trim();
    return GeminiResponse(text: cleanText, sources: sources);
  }

  Future<GeminiResponse> sendMessage(String userMessage) async {
    if (!_isInitialized || _chat == null) {
      return const GeminiResponse(
        text:
            'Servicio de IA no disponible. Verifique su conexión a internet o la configuración de la API key.',
      );
    }

    try {
      final response = await _chat!.sendMessage(Content.text(userMessage));
      final rawText = response.text ?? 'Sin respuesta del asistente.';
      return parseResponse(rawText);
    } catch (e) {
      return GeminiResponse(text: 'Error al comunicarse con el asistente: $e');
    }
  }

  void resetChat() {
    _chat = _model?.startChat();
  }
}

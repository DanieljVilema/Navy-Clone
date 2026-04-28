import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  final apiKey = Platform.environment['GEMINI_API_KEY'] ?? '';
  if (apiKey.isEmpty) {
    stderr.writeln('Missing GEMINI_API_KEY. Set it in your environment before running this script.');
    exit(1);
  }
  final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey');
  
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final models = json['models'] as List;
      for (var model in models) {
        if (model['supportedGenerationMethods'].contains('generateContent')) {
          print(model['name']);
        }
      }
    } else {
      print('Failed: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

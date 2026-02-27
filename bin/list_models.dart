import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const apiKey = 'AIzaSyCGrRODbITFguUH_KBPxdqJbvgMcfdRyAU';
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

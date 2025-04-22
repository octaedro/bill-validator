import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../config/app_config.dart';
import '../../models/check_model.dart';

class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1';
  
  Future<Check> analyzeCheckImage(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    final base64Image = base64Encode(bytes);
    
    final response = await http.post(
      Uri.parse('$_baseUrl/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConfig.openAIApiKey}',
      },
      body: jsonEncode({
        'model': 'gpt-4o',
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text': AppConfig.openAIPrompt,
              },
              {
                'type': 'image_url',
                'image_url': {
                  'url': 'data:image/jpeg;base64,$base64Image',
                },
              },
            ],
          },
        ],
        'max_tokens': 500,
      }),
    );

    if (response.statusCode != 200) {
      print('❌ Error in OpenAI response: ${response.body}');
      throw Exception('Failed to analyze image: ${response.body}');
    }

    final jsonResponse = jsonDecode(response.body);
    print('✅ OpenAI response received:');
    print(const JsonEncoder.withIndent('  ').convert(jsonResponse));
    
    try {
      // Parse the response content
      final contentString = jsonResponse['choices'][0]['message']['content'] as String;
      // Clean any markdown format that might come in the response
      final cleanedContentString = contentString
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      
      print('📝 Parsed JSON content:');
      print(cleanedContentString);
      
      final checkData = jsonDecode(cleanedContentString) as Map<String, dynamic>;

      // Validate and convert items
      final List<dynamic> rawItems = checkData['body'] as List<dynamic>;
      final List<double> itemsList = rawItems
          .map((item) => (item is num) ? item.toDouble() : double.parse(item.toString()))
          .toList();

      // Calculate if amounts match
      final total = (checkData['total'] as num).toDouble();
      final calculatedTotal = itemsList.fold<double>(0, (sum, item) => sum + item);
      final match = (total - calculatedTotal).abs() < 0.01; // Allow a small difference for rounding

      print('🧮 Amount validation:');
      print('Items: $itemsList');
      print('Declared total: $total');
      print('Calculated total: $calculatedTotal');
      print('Match: $match');

      // Create and return Check instance
      return Check(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        establishmentName: checkData['name'] as String? ?? 'Name not detected',
        items: itemsList,
        total: total,
        match: match, // Use our calculation instead of API value
        imagePath: imagePath,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      print('❌ Error processing response: $e');
      throw Exception('Error processing OpenAI response: $e');
    }
  }
} 
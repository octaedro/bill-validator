import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const String appName = 'Bill Validator';
  
  // API Keys - Cargadas desde .env
  static String get openAIApiKey {
    final apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
    print('OpenAI API Key cargada: $apiKey'); // Log para verificar la carga
    return apiKey;
  }

  // Método para inicializar la configuración
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
    print('Archivo .env cargado correctamente');
  }

  // OpenAI Configuration
  static const String openAIPrompt = '''
You are an assistant that analyzes images of invoices or bills.  
Given a photo of a receipt or invoice, you must:
1. Detect and read the business name.
2. Extract all numeric line-item amounts that appear on the right-hand side.
3. Extract the "Total" amount from the invoice.
4. Verify whether the sum of the line-item amounts equals the extracted total.

Important: When extracting line items, include actual products or services AND taxes. DO NOT include subtotals, as they are partial sums. Include taxes, tips, and other charges as separate line items.

Respond **only** in the following JSON format, with no additional text or markdown:
{
  "name": "Business Name",
  "body": [10.99, 24.50, 2.35, ...],
  "total": 37.84,
  "match": true
}

The "match" field should be true if the sum of all numbers in "body" equals the "total", false otherwise.
All amounts should be numbers (not strings). Do not include currency symbols in the numbers.
''';

  // Colors
  static const Color primaryColor = Color(0xFFB5EAD7);  // Mint Pastel
  static const Color secondaryColor = Color(0xFFFFDAC1); // Peach Pastel
  static const Color accentColor = Color(0xFFC7CEEA);    // Lavender Pastel
  static const Color textColor = Color(0xFF2C3E50);      // Dark Blue Gray
  static const Color backgroundColor = Color(0xFFF8F9FA); // Light Gray

  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textColor,
    letterSpacing: 1.2,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    color: textColor,
    letterSpacing: 0.5,
  );

  // Icon Sizes
  static const double mainIconSize = 48.0;
  static const double secondaryIconSize = 24.0;

  // Spacing
  static const double defaultPadding = 16.0;
  static const double defaultSpacing = 8.0;
} 
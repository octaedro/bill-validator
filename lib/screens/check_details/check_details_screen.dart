import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../models/check_model.dart';
import '../../widgets/common/styled_title.dart';
import 'dart:io';

class CheckDetailsScreen extends StatelessWidget {
  final Check check;

  const CheckDetailsScreen({super.key, required this.check});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppConfig.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConfig.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título del establecimiento
            StyledTitle(text: check.establishmentName),
            const SizedBox(height: AppConfig.defaultPadding * 2),
            
            // Imagen y lista de items
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen pequeña a la izquierda
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GestureDetector(
                    onTap: () => _showOriginalImage(context),
                    child: Image.file(
                      File(check.imagePath),
                      width: 120,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: AppConfig.defaultPadding),
                
                // Lista de items a la derecha
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Items:',
                        style: AppConfig.subtitleStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConfig.defaultSpacing),
                      Text(
                        check.items.map((amount) => '\$$amount').join(' - '),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConfig.defaultPadding * 2),
            
            // Total
            Container(
              padding: const EdgeInsets.all(AppConfig.defaultPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: AppConfig.subtitleStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${check.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: check.match ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppConfig.defaultPadding * 2),
            
            // Indicador de match
            Center(
              child: Column(
                children: [
                  Icon(
                    check.match ? Icons.check_circle : Icons.cancel,
                    size: 80,
                    color: check.match ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: AppConfig.defaultSpacing),
                  Text(
                    check.match ? 'Amounts match' : 'Amounts do not match',
                    style: TextStyle(
                      fontSize: 16,
                      color: check.match ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOriginalImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: AppConfig.textColor),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Flexible(
              child: Image.file(
                File(check.imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
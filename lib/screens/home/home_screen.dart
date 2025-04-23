import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../widgets/common/styled_title.dart';
import '../../models/check_model.dart';
import '../check_details/check_details_screen.dart';
import '../../services/api/openai_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Check> _checks = [];
  final _openAIService = OpenAIService();
  bool _isLoading = false;

  Future<void> _processImage(String imagePath) async {
    setState(() => _isLoading = true);
    try {
      final check = await _openAIService.analyzeCheckImage(imagePath);
      setState(() {
        _checks.insert(0, check);
      });
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckDetailsScreen(check: check),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'An error occurred while processing the image.';
        
        // Check if it's our custom NotABillException
        if (e.toString().contains('The uploaded image does not appear to be a valid bill') ||
            e.toString().contains('The image could not be processed as a bill') ||
            e.toString().contains('The image doesn\'t contain the required bill information') ||
            e.toString().contains('No items were detected in this bill')) {
          errorMessage = e.toString();
        }
        
        // Show error dialog with more details
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Invalid Image'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        
        // Also show a brief snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('The image could not be processed as a valid bill'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _deleteCheck(int index) {
    setState(() {
      _checks.removeAt(index);
    });
  }

  Future<void> _editCheck(int index) async {
    final check = _checks[index];
    // Por ahora solo navegamos a la pantalla de detalles
    // Podríamos implementar la edición más adelante
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckDetailsScreen(check: check),
        ),
      );
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    
    if (pickedFile != null) {
      await _processImage(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppConfig.defaultPadding * 2),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConfig.defaultPadding),
              child: StyledTitle(text: AppConfig.appName),
            ),
            const SizedBox(height: AppConfig.defaultPadding * 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIconButton(
                  icon: Icons.camera_alt,
                  label: 'Take Photo',
                  onTap: () => _getImage(ImageSource.camera),
                ),
                const SizedBox(width: AppConfig.defaultPadding * 2),
                _buildIconButton(
                  icon: Icons.photo_library,
                  label: 'Upload',
                  onTap: () => _getImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: AppConfig.defaultPadding * 2),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _checks.isEmpty
                      ? Center(
                          child: Text(
                            'No bills yet',
                            style: AppConfig.subtitleStyle,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppConfig.defaultPadding),
                          itemCount: _checks.length,
                          itemBuilder: (context, index) {
                            final check = _checks[index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: AppConfig.defaultPadding),
                              child: ListTile(
                                leading: Container(
                                  width: 4,
                                  color: check.match ? Colors.green : Colors.red,
                                ),
                                title: Text(
                                  check.displayName,
                                  style: TextStyle(
                                    color: AppConfig.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '\$${check.total.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: check.match ? Colors.green : Colors.red,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => _editCheck(index),
                                      color: AppConfig.textColor,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => _deleteCheck(index),
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                                onTap: () => _editCheck(index),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppConfig.primaryColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.all(AppConfig.defaultPadding),
                child: Icon(
                  icon,
                  size: AppConfig.mainIconSize,
                  color: AppConfig.textColor,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppConfig.defaultSpacing),
        Text(
          label,
          style: AppConfig.subtitleStyle,
        ),
      ],
    );
  }
} 
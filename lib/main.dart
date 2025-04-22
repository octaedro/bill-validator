import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';
import 'config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: ThemeData(
        primaryColor: AppConfig.primaryColor,
        scaffoldBackgroundColor: AppConfig.backgroundColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppConfig.primaryColor,
          secondary: AppConfig.secondaryColor,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
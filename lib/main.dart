import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'pages/splash_screen.dart';  // ← MUST BE splash_screen.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Swap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.pageBackground,
        primaryColor: AppColors.primaryBlue,
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
      ),
      home: const SplashScreen(),  // ← MUST BE SplashScreen()
    );
  }
}
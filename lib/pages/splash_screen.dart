import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_colors.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Progress value for the loading bar (0.0 to 1.0)
  double _progress = 0.0;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    print('🚀 Custom SplashScreen loaded!');
    _startProgress();
  }

  void _startProgress() {
    // Update progress bar over 4 seconds (extra time for user to see it)
    const totalDuration = Duration(seconds: 4);
    const tickInterval = Duration(milliseconds: 30);
    final tickCount = totalDuration.inMilliseconds / tickInterval.inMilliseconds;

    int currentTick = 0;

    _progressTimer = Timer.periodic(tickInterval, (timer) {
      currentTick++;

      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _progress = (currentTick / tickCount).clamp(0.0, 1.0);
      });

      // When progress reaches 100%, navigate to LoginPage
      if (_progress >= 1.0) {
        timer.cancel();
        _navigateToLogin();
      }
    });
  }

  void _navigateToLogin() {
    // TODO: Later, check if user is signed in
    // If signed in → go to HomePage
    // If not → go to LoginPage

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1923),
      body: SafeArea(
        child: Stack(
          children: [
            // Logo image (centered)
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/splash_logo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  // Fallback if image not loaded
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.swap_horiz,
                        size: 100,
                        color: AppColors.primaryBlue,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Progress bar (below logo)
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 270),
                child: Container(
                  width: 160,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      // Animated progress fill
                      AnimatedFractionallySizedBox(
                        widthFactor: _progress,
                        duration: const Duration(milliseconds: 30),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Version text (bottom)
            const Align(
              alignment: Alignment(-0.03, 0.94),
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8899AA),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
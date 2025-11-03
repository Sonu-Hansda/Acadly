import 'package:flutter/material.dart';
import 'package:acadly/app/common/theme/colors.dart';
import 'package:acadly/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    checkAuth(context);
  }

  Future<void> checkAuth(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    if (prefs.containsKey('token')) {
      navigateToHome(context);
    } else {
      navigateToHome(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 1),
              builder: (context, value, child) {
                return Opacity(opacity: value, child: child);
              },
              child: Text(
                'Campusify',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.accent,
                  fontSize: 48,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.background),
            ),
          ],
        ),
      ),
    );
  }
}

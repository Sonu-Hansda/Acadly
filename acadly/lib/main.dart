import 'package:flutter/material.dart';
import 'package:acadly/app/common/theme/colors.dart';
import 'package:acadly/app/common/theme/text_field_theme.dart';
import 'package:acadly/app/common/theme/typography.dart';
import 'package:acadly/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campusify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.accent,
        ),
        textTheme: TextTheme(
          displayLarge: AppTypography.headline1,
          displayMedium: AppTypography.headline2,
          bodyLarge: AppTypography.bodyText1,
          bodyMedium: AppTypography.bodyText2,
          labelLarge: AppTypography.button,
        ),
        inputDecorationTheme: AppTextFieldTheme.theme,
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

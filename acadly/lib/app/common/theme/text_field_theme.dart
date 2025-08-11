import 'package:flutter/material.dart';
import 'package:acadly/app/common/theme/colors.dart';

class AppTextFieldTheme {
  static final InputDecorationTheme theme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.textLight, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.textLight, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    labelStyle: const TextStyle(color: AppColors.textLight),
  );
}

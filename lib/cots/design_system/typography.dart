import 'package:flutter/material.dart';
import 'colors.dart';

// [cite: 7]
class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.text,
  );
  
  static const TextStyle section = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.text,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal, // Regular
    color: AppColors.text,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal, // Regular
    color: AppColors.muted,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.surface,
  );
}
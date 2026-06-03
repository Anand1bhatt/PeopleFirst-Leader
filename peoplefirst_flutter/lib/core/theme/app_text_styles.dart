import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  static const TextStyle heavyTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    color: AppColors.contentHeavy,
  );

  static const TextStyle sectionHeader = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.contentModerate,
    letterSpacing: 0.03 * 13,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.contentHeavy,
  );

  static const TextStyle bodyModerate = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.contentModerate,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.contentModerate,
  );

  static const TextStyle captionMinimal = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.contentMinimal,
  );

  static const TextStyle label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.contentModerate,
    letterSpacing: 0.3,
  );

  static const TextStyle tabularNumbers = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.contentHeavy,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle bigNumber = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.contentHeavy,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle medNumber = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.contentHeavy,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle link = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.relianceBase,
  );

  static const TextStyle greeting = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    color: AppColors.contentHeavy,
  );

  static const TextStyle subGreeting = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
    color: AppColors.contentModerate,
  );

  static TextStyle sectionHeaderUppercase = sectionHeader.copyWith(
    letterSpacing: 0.03 * 13,
  );
}

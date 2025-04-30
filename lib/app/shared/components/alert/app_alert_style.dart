import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

enum AppAlertSize {
  short,
  long;
}

enum AppAlertVariant {
  info,
  warning,
  error,
  success;
}

/// *******************  STYLES DEFINITION ***********************

abstract class AppAlertColors {
  static const Color alertFont = AppColors.background_white;
  static const Color infoAlertBackground = AppColors.background_black;
  static const Color warningAlertBackground = AppColors.background_black;
  static const Color successAlertBackground = AppColors.background_black;
  static const Color errorAlertBackground = AppColors.background_black;
  static const Color infoAlertIcon = AppColors.palette_accent;
  static const Color warningAlertIcon = AppColors.palette_accent;
  static const Color successAlertIcon = AppColors.palette_accent;
  static const Color errorAlertIcon = AppColors.palette_accent;
}

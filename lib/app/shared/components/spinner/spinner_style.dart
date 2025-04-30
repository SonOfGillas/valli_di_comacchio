import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

enum AppSpinnerSize {
  s._(25),
  m._(50),
  l._(65);

  const AppSpinnerSize._(this.spinnerSize);

  final double spinnerSize;
}

enum AppSpinnerVariant {
  blue,
  white;
}

/// *******************  STYLES DEFINITION ***********************

abstract class AppSpinnerColors {
  static const Color appSpinner = AppColors.palette_primary;
  static const Color appSpinnerWhite = AppColors.shade_shade_white_50;
}

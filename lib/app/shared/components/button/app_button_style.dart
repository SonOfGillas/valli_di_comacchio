import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/icon_models.dart';

enum AppButtonSize {
  medium._(56, 19, 32);

  const AppButtonSize._(this.buttonHeight, this.fontSize, this.iconSize);

  final double buttonHeight;
  final double fontSize;
  final double iconSize;
}

enum AppButtonVariant { primary, secondary }

/// *******************  STYLES DEFINITION ***********************

const _borderRadius = BorderRadius.zero;

SvgColorDef primarySvgColors() => SvgColorDef(
      enabledColor: AppButtonColors.buttonLabelPrimary,
      disabledColor: AppButtonColors.buttonLabelPrimaryDisabled,
    );

ButtonStyle primaryButtonStyle({bool disabled = false}) =>
    ElevatedButton.styleFrom(
      disabledBackgroundColor: AppButtonColors.buttonPrimaryDisabled,
      disabledForegroundColor: AppButtonColors.buttonLabelPrimaryDisabled,
      backgroundColor: AppButtonColors.buttonPrimary,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: disabled
              ? AppButtonColors.buttonBorderPrimaryDisabled
              : AppButtonColors.buttonBorderPrimary,
          width: 2,
        ),
        // ignore: avoid_redundant_argument_values
        borderRadius: _borderRadius,
      ),
      foregroundColor: AppButtonColors.buttonLabelPrimary,
    );

SvgColorDef secondarySvgColors() => SvgColorDef(
      enabledColor: AppButtonColors.buttonPrimary,
      disabledColor: AppButtonColors.buttonLabelPrimaryDisabled,
    );

ButtonStyle secondaryButtonStyle({bool disabled = false}) =>
    ElevatedButton.styleFrom(
      disabledBackgroundColor: AppButtonColors.buttonPrimaryDisabled,
      disabledForegroundColor: AppButtonColors.buttonLabelPrimaryDisabled,
      backgroundColor: AppColors.palette_accent.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: disabled
              ? AppButtonColors.buttonBorderPrimaryDisabled
              : AppButtonColors.buttonBorderPrimary,
          width: 2,
        ),
        // ignore: avoid_redundant_argument_values
        borderRadius: _borderRadius,
      ),
      foregroundColor: AppButtonColors.buttonLabelSecondary,
    );

abstract class AppButtonColors {
  static const Color buttonPrimary = AppColors.palette_accent;
  static const Color buttonPrimaryDisabled = AppColors.background_light_gray;
  static const Color buttonLabelPrimaryDisabled =
      AppColors.shade_shade_white_50;
  static const Color buttonBorderPrimaryDisabled =
      AppColors.background_light_gray;
  static const Color buttonRipplePrimary = AppColors.shade_shade_white_50;
  static const Color buttonLabelPrimary = AppColors.background_black;
  static const Color buttonBorderPrimary = AppColors.palette_accent;
  static const Color buttonLabelSecondary = AppColors.palette_accent;
}

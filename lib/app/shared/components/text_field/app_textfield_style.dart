import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_text_style.dart';

enum AppTextFieldLabelStyle {
  normal,
  bold,
  italics,
  boldItalics;
}

enum AppTextFieldLabelPosition {
  left,
  top;
}

enum AppTextFieldType {
  text,
  password,
  textArea;
}

enum AppTextFieldVariant {
  standard,
  filled,
  error;
}

TextStyle normalLabelStyle = AppTextStyles.label;
TextStyle boldLabelStyle = AppTextStyles.title;
TextStyle italicsLabelStyle =
    normalLabelStyle.copyWith(fontStyle: FontStyle.italic);
TextStyle boldItalicsLabelStyle =
    boldLabelStyle.copyWith(fontStyle: FontStyle.italic);

abstract class AppTextFieldColors {
  static const Color border = AppColors.shade_shade_white_25;
  static const Color borderError = AppColors.utility_allert;
  static const Color text = AppColors.background_white;
  static const Color textError = AppColors.utility_allert;
  static const Color leftIcon = AppColors.background_white;
  static const Color rightIcon = AppColors.background_white;
  static const Color iconBackground = AppColors.shade_shade_white_50;
  static const Color fill = AppColors.shade_shade_gray_50;
  static const Color background = AppColors.shade_shade_white_15;
}

TextStyle textFieldPlaceHolderStyle =
    AppTextStyles.label.copyWith(color: AppColors.shade_shade_gray_50);

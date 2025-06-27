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
  number,
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
  static const Color border = AppColors.palette_primary;
  static const Color borderError = AppColors.utility_allert;
  static const Color text = AppColors.palette_primary;
  static const Color textError = AppColors.utility_allert;
  static const Color leftIcon = AppColors.palette_primary;
  static const Color rightIcon = AppColors.palette_primary;
  static const Color iconBackground = AppColors.palette_secondary;
  static const Color fill = AppColors.shade_shade_gray_50;
  static const Color background = AppColors.palette_secondary;
}

TextStyle textFieldPlaceHolderStyle =
    AppTextStyles.labelText.copyWith(color: AppColors.primary_light);

const appTextFieldBorderWidth = 3.0;
const appTextFieldBorderRadius = BorderRadius.all(Radius.circular(30));

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class AppTextStyles {
  static final primaryButtonTextStyle = GoogleFonts.lilitaOne(
    fontWeight: FontWeight.w400,
    fontSize: 20,
    height: 48 / 20,
    letterSpacing: -0.035 * (20),
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.39
      ..color = AppColors.black_shadow_80,
    shadows: const [
      Shadow(
        color: AppColors.black_shadow_80,
        offset: Offset(0, 2.79),
        blurRadius: 0,
      ),
    ],
  );

  static final defaultLetterSpacing = -0.060;
  static final defaultBorderWidth = 4.0;
  static final shadowXoffset = -0.08;
  static final shadowYoffset = 0.10;

  static final h1FontSize = 32.0;
  static final h1Height = 48 / 32;
  static final h1LetterSpacing = defaultLetterSpacing * (h1FontSize);

  static final h1OnPrimary = GoogleFonts.lilitaOne(
    color: AppColors.background_white,
    fontWeight: FontWeight.w400,
    fontSize: h1FontSize,
    height: h1Height,
    letterSpacing: h1LetterSpacing,
    shadows: [
      Shadow(
        color: AppColors.black_shadow_80,
        offset: Offset(shadowXoffset * h1FontSize, shadowYoffset * h1FontSize),
        blurRadius: 0,
      ),
    ],
  );

  static final h1OnPrimaryBorder = GoogleFonts.lilitaOne(
    fontWeight: FontWeight.w900,
    fontSize: h1FontSize,
    height: h1Height,
    letterSpacing: h1LetterSpacing,
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = defaultBorderWidth
      ..color = AppColors.black_shadow_80,
  );

  static final h3FontSize = 22.0;
  static final h3Height = 32 / 22;
  static final h3LetterSpacing = defaultLetterSpacing * h3FontSize;

  static final h3WithBoarder = GoogleFonts.lilitaOne(
    color: AppColors.background_white,
    fontWeight: FontWeight.w400,
    fontSize: h3FontSize,
    height: h3Height,
    letterSpacing: h3LetterSpacing,
    shadows: [
      Shadow(
        color: AppColors.black_shadow_80,
        offset: Offset(shadowXoffset * h3FontSize, shadowYoffset * h3FontSize),
        blurRadius: 0,
      ),
    ],
  );

  static final h3Border = GoogleFonts.lilitaOne(
    fontWeight: FontWeight.w900,
    fontSize: h3FontSize,
    height: h3Height,
    letterSpacing: h3LetterSpacing,
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = defaultBorderWidth
      ..color = AppColors.black_shadow_80,
  );

  static final labelTextFontSize = 18.0;
  static final labelTextHeight = 24 / 18;
  static final labelTextLetterSpacing =
      defaultLetterSpacing * labelTextFontSize;

  static final labelText = GoogleFonts.lilitaOne(
    color: AppColors.palette_primary,
    fontWeight: FontWeight.w400,
    fontSize: labelTextFontSize,
    height: labelTextHeight,
    letterSpacing: labelTextLetterSpacing,
  );

  static final labelTextWithBoarder = GoogleFonts.lilitaOne(
    color: AppColors.background_white,
    fontWeight: FontWeight.w400,
    fontSize: labelTextFontSize,
    height: labelTextHeight,
    letterSpacing: labelTextLetterSpacing,
    shadows: [
      Shadow(
        color: AppColors.black_shadow_80,
        offset: Offset(shadowXoffset * labelTextFontSize,
            shadowYoffset * labelTextFontSize),
        blurRadius: 0,
      ),
    ],
  );

  static final labelTextBorder = GoogleFonts.lilitaOne(
    fontWeight: FontWeight.w900,
    fontSize: labelTextFontSize,
    height: labelTextHeight,
    letterSpacing: labelTextLetterSpacing,
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = defaultBorderWidth
      ..color = AppColors.black_shadow_80,
  );

  static final buttonSectionTitle = GoogleFonts.roboto(
    color: AppColors.background_white,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontSize: 19,
  );
  static final title = GoogleFonts.roboto(
    color: AppColors.background_white,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 17,
  );
  static final label = GoogleFonts.roboto(
    color: AppColors.background_white,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 17,
  );
  static final innerText = GoogleFonts.roboto(
    color: AppColors.background_white,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 15,
  );
  static final notificationTitle = GoogleFonts.roboto(
    color: AppColors.background_white,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontSize: 13,
  );
  static final tag = GoogleFonts.roboto(
    color: AppColors.background_white,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 12,
  );
  static final notificationText = GoogleFonts.roboto(
    color: AppColors.background_white,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 11,
  );
  static final notificationInfo = GoogleFonts.roboto(
    color: AppColors.background_white,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 10,
  );
}

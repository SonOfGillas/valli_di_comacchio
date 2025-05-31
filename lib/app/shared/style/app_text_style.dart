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

  static final h1FontSize = 32.0;
  static final h1Height = 48 / 32;
  static final h1LetterSpacing = -0.035 * 32;

  static final h1OnPrimary = GoogleFonts.lilitaOne(
    color: AppColors.background_white,
    fontWeight: FontWeight.w400,
    fontSize: h1FontSize,
    height: h1Height,
    letterSpacing: h1LetterSpacing,
    shadows: const [
      Shadow(
        color: Color(0xFF080206),
        offset: Offset(0, 2.79),
        blurRadius: 0,
      ),
    ],
  );

  static final h1OnPrimaryBorder = GoogleFonts.lilitaOne(
    fontWeight: FontWeight.w400,
    fontSize: h1FontSize,
    height: h1Height,
    letterSpacing: h1LetterSpacing,
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.39
      ..color = AppColors.black_shadow_80,
  );

  static final h3OnBackground = GoogleFonts.lilitaOne(
    color: AppColors.background_white,
    fontWeight: FontWeight.w400,
    fontSize: 20,
    height: 32 / 24,
    letterSpacing: -0.035 * 24,
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.39
      ..color = AppColors.black_shadow_80,
  );

  static final h4OnBackground = GoogleFonts.lilitaOne(
    color: AppColors.palette_primary,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 48 / 20,
    letterSpacing: -0.035 * 20,
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

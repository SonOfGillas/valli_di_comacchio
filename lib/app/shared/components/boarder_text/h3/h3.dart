import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_text_style.dart';

class H3 extends StatelessWidget {
  const H3(this.text, {this.error = false, this.centre = false, super.key});

  final String text;
  final bool error;
  final bool centre;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: AppTextStyles.h3Border,
          textAlign: centre ? TextAlign.center : null,
        ),
        Text(
          text,
          style: AppTextStyles.h3WithBoarder.copyWith(
            color: error ? AppColors.shade_red_100 : null,
          ),
          textAlign: centre ? TextAlign.center : null,
        )
      ],
    );
  }
}

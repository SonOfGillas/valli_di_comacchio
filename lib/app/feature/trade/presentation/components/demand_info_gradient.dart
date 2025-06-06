import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/labelText.dart/label_text.dart';
import 'package:valli_di_comacchio/app/shared/l10n/l10n.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class DemandInfoGradient extends StatelessWidget {
  const DemandInfoGradient({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0),
      child: SizedBox(
        height: 32,
        child: Stack(
          children: [
            // Gradient bar
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    AppColors.shade_green_100,
                    AppColors.shade_green_90,
                    AppColors.shade_green_80,
                    AppColors.shade_green_70,
                    AppColors.shade_green_60,
                    AppColors.shade_green_50,
                    AppColors.shade_green_40,
                    AppColors.shade_green_30,
                    AppColors.shade_green_20,
                    AppColors.shade_green_10,
                    AppColors.shades_white_75,
                    AppColors.shade_red_10,
                    AppColors.shade_red_20,
                    AppColors.shade_red_30,
                    AppColors.shade_red_40,
                    AppColors.shade_red_50,
                    AppColors.shade_red_60,
                    AppColors.shade_red_70,
                    AppColors.shade_red_80,
                    AppColors.shade_red_90,
                    AppColors.shade_red_100,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            // Texts
            Positioned(
              left: 12,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: LabelText(
                  l10n.tradeInfoGradientGreen,
                  withBoarder: true,
                ),
              ),
            ),
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerRight,
                child: LabelText(
                  l10n.tradeInfoGradientRed,
                  withBoarder: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

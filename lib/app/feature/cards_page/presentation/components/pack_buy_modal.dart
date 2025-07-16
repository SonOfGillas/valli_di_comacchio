import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:valli_di_comacchio/app/feature/cards_page/logic/card_cubit.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';
import 'package:valli_di_comacchio/app/shared/components/modal/base_modal.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';
import 'package:valli_di_comacchio/app/shared/style/app_icons.dart';
import 'package:valli_di_comacchio/app/shared/style/app_images.dart';

Widget buyPackModal({
  required BuildContext context,
  required bool userHaveEnoughCoins,
  required VoidCallback onOpenPack,
}) {
  return BaseModal(
    child: Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: AppColors.palette_tertiary,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColors.palette_primary,
              width: 2,
            )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const H3('Apertura Pacchetto'),
            const SizedBox(height: 20),
            Image.asset(
              AppImages.pack_closed,
              width: 120,
              height: 180,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            if (!userHaveEnoughCoins)
              const Text(
                'credito insufficiente per aprire questo pacchetto.',
                style: TextStyle(
                  color: AppColors.shade_red_100,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppIcons.money,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColors.palette_primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '$packetCost Monete',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Annulla',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (userHaveEnoughCoins) {
                        Navigator.of(context).pop();
                        onOpenPack();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          userHaveEnoughCoins ? Colors.green : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Apri',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

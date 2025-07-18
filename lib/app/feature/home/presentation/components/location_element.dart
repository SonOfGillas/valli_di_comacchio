import 'package:flutter/material.dart';
import 'package:valli_di_comacchio/app/shared/components/boarder_text/h3/h3.dart';
import 'package:valli_di_comacchio/app/shared/components/npc_location_detail/npc_location_detail.dart';
import 'package:valli_di_comacchio/app/shared/domain/entities/npc.dart';
import 'package:valli_di_comacchio/app/shared/style/app_colors.dart';

class LocationElement extends StatelessWidget {
  final Npc npc;

  const LocationElement({
    super.key,
    required this.npc,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.black.withValues(alpha: 0.85),
          builder: (context) => NpcLocationDetail(
            npc: npc,
            onBack: () => Navigator.of(context).pop(),
          ),
        );
      },
      child: Card(
        color: AppColors.palette_primary,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      npc.locationInformation.imagePath,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                H3(npc.locationInformation.name),
              ],
            ),
            Image.asset(
              npc.imageLocalPath,
              height: 54,
            ),
          ],
        ),
      ),
    );
  }
}
